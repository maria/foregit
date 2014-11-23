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
Add your settings, like API client and token, or Git repo path.

### Sync Foreman and Git

#### Sync Foreman configuration into Git repository

  - Command: `hammer pull`
  - Options: resources list

If it's the first time you use it, it will check for a GitHub repo URL in your settings file, and clone it on the machine.
Else, it will create a directory with the given path and sync Foreman resources in the new Git project.
In general the command downloads Foreman resources in the Git project and commit the changes.


#### Sync Git repository into Foreman instance

   - Command `hammer push`
   - Options: resources list

#### Create a new Foreman resource

	There are two ways of creating a new resource in the Foreman instance, which will be synced in the Git repository

    - Create file in Git repository and do `hammer push`:

Create a JSON file in `git_repo_path>/resource_name/`, the file name has to be: `id_name.json`.
So, you should know what id the new resource is going to have, and that no other resource exists with that ID.
The file content should look like this:

```json
{
   "id": "id_value",
   "another_required_field_name": "another_require_fiedl_value",
   "fiel_name": "field_value"
}
```

    - Use the `hammer add` command:

 If you don't want to bother with finding a proper ID and saving the file in the correct path, you can use `hammer add -r <resource_name` and one of the options:

      - `-f <file_name>` - where the file is a JSON file representing the resource attributes as the one described above. The "id" field is optional.
      - `-a field_name=field_value,field_name_two=field_value_two` - pass a list of *key=value* pairs for each field you want to configure.

The command will create the resource in the Foreman instance, sync Foreman resource in the Git repository and commit the changes.
