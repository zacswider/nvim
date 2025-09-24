# To use on MacOS and Linux:

clone with `git clone git@github.com:zacswider/nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim`

## install rust nightly

- `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`
- `. "$HOME/.cargo/env"`
- `rustup toolchain install nightly`
- `rustup default nightly`

## install luarocks

- `sudo apt install luarocks`
