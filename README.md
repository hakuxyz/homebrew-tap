# hakuxyz/homebrew-tap

Tap containing prebuilt-binary formulae for [RustDrop](https://github.com/hakuxyz/rustdrop).

```bash
brew install hakuxyz/tap/rustdrop
```

To update for a new release: bump `version`, `url` and `sha256` in
`Formula/rustdrop.rb` (checksums are published as `SHA256SUMS.txt` on each
GitHub release), then run `brew audit --strict --online rustdrop` and
`brew test rustdrop`.
