# dotfiles

For a fresh install, create symbolic links in `$HOME` to all files in `src`, with backups of existing files:

```
brew bundle install --no-lock --verbose

./install.sh -b
```

To overwrite existing files, replace `-b` with `-f`.
