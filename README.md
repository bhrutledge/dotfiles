# dotfiles

For a fresh install, create symbolic links in `$HOME` to all files in `src`, with backups of existing files:

```
$ brew install coreutils
$ ./install.sh -b
```

To overwrite existing files, replace `-b` with `-f`.

## TODO

- Single script in `src/bin` for linking/adding/removing/pruning
- Clean/diff backups
