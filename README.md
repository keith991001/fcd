# fcd

A tiny shell function to fuzzy-`cd` into any directory under your home.

```
fcd            # open picker for all dirs under ~
fcd devs       # prefill picker with "devs"; auto-cd if only one match
```

## Requirements

- [`fd`](https://github.com/sharkdp/fd) — a fast, sane replacement for `find`
- [`fzf`](https://github.com/junegunn/fzf) — a general-purpose fuzzy finder

On macOS:

```sh
brew install fd fzf
```

## Install

Clone this repo somewhere, then source `fcd.sh` from your shell rc file.

```sh
git clone https://github.com/keith991001/fcd.git ~/.fcd
echo 'source ~/.fcd/fcd.sh' >> ~/.zshrc   # or ~/.bashrc
```

Open a new shell (or `source ~/.zshrc`) and `fcd` is ready.

## How it works

```sh
fcd() {
  local dir
  dir=$(fd -t d . ~ 2>/dev/null | fzf --select-1 --exit-0 --query "${1:-}") || return
  [ -n "$dir" ] && cd "$dir"
}
```

- `fd -t d . ~` lists every directory under your home.
- `fzf --query "${1:-}"` opens the fuzzy picker, prefilled with your argument (if any).
- `--select-1` auto-selects when there is only one match, so `fcd unique-name` jumps immediately.
- `--exit-0` bails out silently when nothing matches.
- The `local dir` + `[ -n "$dir" ]` guard prevents `cd ""` (which would send you to `$HOME`) if you press `Esc`.

## License

MIT
