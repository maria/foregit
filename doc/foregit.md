## Foregit

Foregit is an interface between Foreman and Git. You can synchronize and define
a Foreman instance through a Git repository.


### Install and configure

Step 1: Install the gem

`gem install foregit`

Step 2: Add a configuration file

Foregit is a `hammer-cli` plugin, so you should add the module settings either in
`/etc/hammer/cli.modules.d/foregit.yml` or `/home/.hammer/cli.modules.d/foregit.yml`.

Copy the `foregit/config/foregit.yml` to one of the directories above.

Step 3: Add your settings
Add your settings, like API client and token, or Git repo path in the `settings.yaml` file.

### Sync Foreman and Git

To sync a Foreman configuration into a Git repository it's done using the `hammer pull` command.
Configuring a Foreman instance through a Git repository it's done using the `hammer push` command.

Use `hammer -h` or `hammer pull -h` to learn more about you can use the commands.
