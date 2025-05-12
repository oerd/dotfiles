### Different (path-based) gitconfig settings

Git profiles for work/public/opensource work/etc. can be difficult to manage.
The main `.gitconfig` uses git `includeIf`s to set/overwrite user-related settings
in separate `.gitconfig.<profile>` configuration files.

I mainly use this for user-related settings (i.e. `user.name` and `user.email`)
but other can be included, too. For example, see the github url switch with `insteadOf`
in for homebrew use in [`gitconfig.homebrew.symlink`](./gitconfig.homebrew.symlink).
