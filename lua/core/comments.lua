local M = {}

local function get_comment_tokens(bufnr)
  local commentstring = vim.bo[bufnr].commentstring
  if not commentstring or commentstring == '' then
    return nil
  end

  local left, right = commentstring:match('^(.*)%%s(.*)$')
  if not left then
    return nil
  end

  left = vim.trim(left)
  right = vim.trim(right)

  if left == '' then
    return nil
  end

  return left, right
end

local function is_comment_node(node)
  while node do
    local node_type = node:type()
    if node_type == 'comment' or node_type:find('comment', 1, true) then
      return true
    end

    if node_type == 'string' or node_type:find('string', 1, true) then
      return false
    end

    node = node:parent()
  end

  return false
end

local function has_treesitter_comment_at(bufnr, row, col)
  local ok, parser = pcall(vim.treesitter.get_parser, bufnr)
  if not ok or not parser then
    return nil
  end

  local trees = parser:parse()
  for _, tree in ipairs(trees) do
    local root = tree:root()
    local node = root:named_descendant_for_range(row, col, row, col)
    if node and is_comment_node(node) then
      return true
    end
  end

  return false
end

local function find_comment_start(bufnr, row, line)
  local left = get_comment_tokens(bufnr)
  if not left then
    return nil
  end

  local init = 1
  while true do
    local byte_start = line:find(left, init, true)
    if not byte_start then
      return nil
    end

    local before = line:sub(1, byte_start - 1)
    if before:find('%S') then
      local has_comment = has_treesitter_comment_at(bufnr, row, byte_start - 1)
      if has_comment ~= false then
        return byte_start
      end
    end

    init = byte_start + #left
  end
end

local function strip_line(bufnr, row)
  local line = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1]
  if not line or line == '' then
    return
  end

  local comment_start = find_comment_start(bufnr, row, line)
  if not comment_start then
    return
  end

  local code = line:sub(1, comment_start - 1):gsub('%s+$', '')
  if code == '' then
    return
  end

  vim.api.nvim_buf_set_lines(bufnr, row, row + 1, false, { code })
end

function M.delete_trailing_comment()
  strip_line(0, vim.api.nvim_win_get_cursor(0)[1] - 1)
end

function M.delete_trailing_comments_in_selection()
  local bufnr = vim.api.nvim_get_current_buf()
  local start_row = vim.fn.getpos("'<")[2] - 1
  local end_row = vim.fn.getpos("'>")[2] - 1

  if start_row > end_row then
    start_row, end_row = end_row, start_row
  end

  for row = start_row, end_row do
    strip_line(bufnr, row)
  end
end

return M
