## Foregit

Foregit is an interface between Foreman and Git. You can synchronize and define
a Foreman instance through a Git repository.


### Install and configure

Step 1: Install the gem

`gem install foregit`

Step 2: Add a configuration file
Copy the `foregit/settings.yaml.example` to `foregit/settings.yaml`

Step 3: Add your settings
Add your settings, like API client and token, or Git repo path in the `settings.yaml` file.

### Sync Foreman and Git

To sync a Foreman configuration into a Git repository it's done using the `foregit-talk pull` command.
Configuring a Foreman instance through a Git repository it's done using the `foregit-talk push` command.

Each command accepts a list of resources which will be synced.
