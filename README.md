This is a very basic neovim configuration that relies at lazy.nvim to load plugins. It covers all core editor functions and some quality of life aspects. Most bindings can be found at **vim-options.lua** file, except for some individual plugin configuration.

## Requirements

To properly load and use all plugins, you will need to have the following installed:

### Core

1. [Neovim](https://neovim.io/) >= 0.11
2. A C compiler (`gcc` or `cc`) — required for treesitter parser compilation
3. [Git](https://git-scm.com/)

### Language toolchains

4. [Node.js](https://nodejs.org/) and npm — required by Mason for most LSP servers and formatters
5. [Python 3](https://www.python.org/) with `pipx` or `python3-venv` — used by Mason to install `ruff`
6. [Rust](https://www.rust-lang.org/) and Cargo — required for `rust_analyzer`, `rustfmt`
7. [Typst](https://typst.app/) — required for `tinymist` (LSP) and `prettypst` (formatter)
8. _(optional)_ [Lean 4](https://lean-lang.org/) via [elan](https://github.com/leanprover/elan) — only needed if you edit `.lean` files

Language support included: TypeScript/JavaScript (with Tailwind, HTML, CSS, JSON, Biome/Prettier), Python, Rust, Typst, Lua, and Markdown.

### External tools

10. [ripgrep](https://github.com/BurntSushi/ripgrep) — used by Telescope for `live_grep`
11. [lazygit](https://github.com/jesseduffield/lazygit) — git TUI integration

For JS/TS projects, if a `biome.json` is present, Biome will be used for formatting; otherwise, Prettier (`prettierd`) will be used as the fallback.

## Installation

### First time on a new machine

```sh
git clone <this-repo-url> ~/.config/nvim
nvim
```

On first launch, `lazy.nvim` bootstraps itself and installs every plugin pinned in `lazy-lock.json`. After plugins finish installing, run inside Neovim:

```vim
:TSUpdate
```

This compiles the treesitter parsers listed in `lua/plugins/treesitter.lua` (requires a C compiler).

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
