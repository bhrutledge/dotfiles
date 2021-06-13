# dotfiles

For a fresh install, create symbolic links in `$HOME` to all files in `src`, with backups of existing files:

```
% brew bundle install --no-lock --verbose

% ./install.sh -b
```

To overwrite existing files, replace `-b` with `-f`.

## TODO

- Single Python script in `src/bin` for linking/adding/removing/pruning
