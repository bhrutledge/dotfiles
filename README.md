# dotfiles

For a fresh install, create symbolic links in `$HOME` of all files in `src`, with backups of existing files:

```
$ brew install coreutils
$ gcp -asTvb $PWD/src $HOME
```

Inspired by [symlink - How to copy a folder structure and make symbolic links to files?](https://unix.stackexchange.com/questions/196537/how-to-copy-a-folder-structure-and-make-symbolic-links-to-files)

## TODO

- Separate Python utility for linking/adding/removing via `os`/`shutil` modules
- Clean/diff backups
- Prune dead links
