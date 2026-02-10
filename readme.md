This is my nvim config, use it if you want! It works best with nvim nightly and ghostty on MacOS, but I also install/use it on linux servers and it mostly works fine there too.

# Use this config for your install

clone with `git clone git@github.com:zacswider/nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim`

# To use on MacOS and Linux:

## install nvim on Amazon Linux

If nvim isn't installed, (`nvim --version`), run these commands:

- `sudo yum -y install ninja-build cmake gcc make unzip gettext git`
- `git clone https://github.com/neovim/neovim.git`
- `cd neovim`
- `git checkout master` (or anything >= version 0.12; as of Jan 2026 v0.12 was on master)
- `make CMAKE_BUILD_TYPE=Release` (or `make CMAKE_BUILD_TYPE=RelWithDebInfo` if you want debug flags)
- `sudo make install`
- confirm version >= 0.12 with `nvim --version`

## install rust nightly

- `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`
- `. "$HOME/.cargo/env"`
- `rustup toolchain install nightly`
- `rustup default nightly`

## install luarocks

- `brew install luarocks`
- `sudo apt install luarocks`

## will probably need imagemagick for image rendering in notebooks

- `brew install imagemagick`
- `sudo apt install imagemagick`

## install ty (Python LSP)

ty is used for Python LSP features (go-to-definition, hover, completions, etc.). Install it via uv:

- `uv tool install ty`

This installs the `ty` executable to `~/.local/bin/`. Ensure this is in your `$PATH`.
