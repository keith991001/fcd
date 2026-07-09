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

1. Install the dependencies:

   ```sh
   brew install fd fzf
   ```

2. Clone this repo somewhere on your machine:

   ```sh
   git clone https://github.com/keith991001/fcd.git ~/.fcd
   ```

3. Register `fcd.sh` in your shell startup file so it loads on every new shell:

   ```sh
   echo 'source ~/.fcd/fcd.sh' >> ~/.zshrc   # or ~/.bashrc
   ```

4. Reload your current shell (or just open a new terminal):

   ```sh
   source ~/.zshrc
   ```

`fcd` is now available.

## Why does it need `source`?

`fcd` is a shell **function**, not a standalone executable. Functions only exist
inside the shell process that defined them, so running `bash fcd.sh` would spawn
a subshell, define the function there, and then throw it away when the subshell
exits — your interactive shell would still not know about `fcd`.

`source` (a.k.a. `.`) runs a file's contents in the *current* shell, keeping
whatever it defines. Adding the `source` line to `~/.zshrc` makes every new
shell run it at startup, so `fcd` is always available.

The function also needs to run in your current shell because `cd` only affects
the shell that executes it — a subshell's `cd` cannot change your interactive
shell's working directory. That is why tools like `nvm`, `rbenv`, and
`zoxide init` also require sourcing rather than being called as scripts.

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
