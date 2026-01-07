- https://github.com/orgs/vague-theme/discussions/44 vague md settings
    * this guys nvim config: https://github.com/pkazmier/nvim (really sick should take some notes on it)
- weird flashing bug with nvim autocomplete? maybe swtich to cmp
- investigate ANY sort of lazy loading/optimization

## Lazy Loading Research (LZE vs Native)
I did some research on wanting to migrate my config to use `lze` for lazy loading, noticing that my current setup with `mini.deps` `now()` and `later()` is okay but `lze` combined with `vim.pack.add` (especially in 0.12) seemed cleaner.

I explored a 'Single Definition' pattern where I could override `vim.pack.add` to automatically pipe a `data` field into `lze`. This would let me define installation and lazy-loading logic in one place, like this:
```lua
vim.pack.add({
  { src = "user/repo", data = { event = "BufRead" } }
})
```

However, I'm holding off for now. There are rumors that Neovim 0.12+ might upstream the `now()`/`later()` concept natively (possibly `vim.fn.later` or similar startup scheduling). If that happens, I'd rather migrate directly to the native API than do an intermediate switch to `lze`. I need to keep an eye on Neovim changelogs for native "deferred loading" primitives.

Relevant Github Issue: [https://github.com/neovim/neovim/issues/35562]
