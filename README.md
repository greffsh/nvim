This is a very basic neovim configuration that relies at lazy.nvim to load plugins. It covers all core editor functions and some quality of life aspects. Most bindings can be found at **vim-options.lua** file, except for some individual plugin configuration.

## Requirements

To properly load and use all plugins, you will need to have the following installed:

### Core

1. [Neovim](https://neovim.io/) **>= 0.12** (see [Neovim version](#neovim-version) below)
2. A C compiler (`gcc` or `cc`) — required for treesitter parser compilation
3. [Git](https://git-scm.com/)
4. [`tree-sitter` CLI](https://github.com/tree-sitter/tree-sitter) — installed automatically via Mason on first launch

### Language toolchains

4. [Node.js](https://nodejs.org/) and npm — required by Mason for most LSP servers and formatters
5. [Python 3](https://www.python.org/) with `pipx` or `python3-venv` — used by Mason to install `ruff`
6. [Rust](https://www.rust-lang.org/) and Cargo — required for `rust_analyzer`, `rustfmt`
7. [Typst](https://typst.app/) — required for `tinymist` (LSP) and `prettypst` (formatter)
8. [Gleam](https://gleam.run/) — provides its own LSP (`gleam lsp`), used when editing `.gleam` files inside a project with `gleam.toml`
9. _(optional)_ [Lean 4](https://lean-lang.org/) via [elan](https://github.com/leanprover/elan) — only needed if you edit `.lean` files

Language support included: TypeScript/JavaScript (with Tailwind, HTML, CSS, JSON, Biome/Prettier), Python, Rust, Typst, Gleam, Lua, and Markdown.

### External tools

10. [ripgrep](https://github.com/BurntSushi/ripgrep) — used by Telescope for `live_grep`
11. [lazygit](https://github.com/jesseduffield/lazygit) — git TUI integration

For JS/TS projects, if a `biome.json` is present, Biome will be used for formatting; otherwise, Prettier (`prettierd`) will be used as the fallback.

## Neovim version

This config targets **Neovim 0.12+**. It relies on APIs introduced in 0.12 (new `vim.treesitter` entry points, `vim.lsp.config()` / `vim.lsp.enable()`, `vim.hl`) and on plugins that require 0.12 — notably [`tree-sitter-manager.nvim`](https://github.com/romus204/tree-sitter-manager.nvim), used after the original `nvim-treesitter` was archived.

Fedora 43 ships only 0.11.x in the official repos, so on Fedora you need to build from source:

```sh
sudo dnf -y install ninja-build cmake gcc make gettext curl glibc-gconv-extra git unzip
git clone https://github.com/neovim/neovim ~/programming/neovim
cd ~/programming/neovim
git checkout v0.12.2          # or any later 0.12.x tag
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install              # installs to /usr/local
```

Verify with `nvim --version` (should print `NVIM v0.12.x`). On Arch / macOS (homebrew) / nixpkgs the distro package is usually new enough — check before building.

## Installation

### First time on a new machine

```sh
git clone <this-repo-url> ~/.config/nvim
nvim
```

On first launch, `lazy.nvim` bootstraps itself and installs every plugin pinned in `lazy-lock.json`, and Mason installs the LSPs / tools listed in `lua/plugins/lsp-config.lua` (including `tree-sitter-cli`).

Treesitter parsers are **installed lazily** by `tree-sitter-manager.nvim`: the first time you open a file of a given language, the corresponding parser is cloned and compiled (~5s, one-time, requires a C compiler). No `:TSUpdate` step needed.

### Keeping multiple machines in sync

The `lazy-lock.json` file pins each plugin to a specific commit so that every machine runs the same versions.

**On the machine where you update plugins:**

```vim
:Lazy sync
```

Then commit the resulting `lazy-lock.json` change:

```sh
git add lazy-lock.json
git commit -m "lazy: update plugins"
git push
```

**On the other machine:**

```sh
cd ~/.config/nvim
git pull
nvim +':Lazy restore' +qa
```

`:Lazy restore` checks out the exact commits recorded in the lock file.

### Resetting a broken plugin state

If plugins on a machine get into an inconsistent state, clear the install directory and let Lazy rebuild from the lock file. This does not touch your config:

```sh
rm -rf ~/.local/share/nvim/lazy
nvim +':Lazy restore' +qa
```
