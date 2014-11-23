## Foregit

Foregit is an interface between Foreman and Git.  
You can describe and maintain a Foreman instance through a Git repository.


### Install and configure

#### Step 1: Install the gem

`gem install foregit`

#### Step 2: Add a configuration file

Foregit is using a `hammer-cli` plugin for commands. So, you should add the module settings either in
`/etc/hammer/cli.modules.d/foregit.yml` or `/home/.hammer/cli.modules.d/foregit.yml` directories.  
You can copy the `foregit/config/foregit.yml` to one of the directories above,

#### Step 3: Add your settings

Add settings like: 
 - Foreman URL, Foreman API client and token
 - the desired path for your Git repo
 - an existent GitHub URL for the repo

### Sync Foreman and Git

#### Sync Foreman configuration into Git repository

  - Command: `hammer pull`
  - Options: a list of resources

If it's the first time you use the command on the machine then it will do:
  - check for a GitHub repo URL in your settings file
  - if it exists, then clone it on the machine at the given Git repo path
  - else initialize a new Git project in the given Git repo path
  - download the Foreman resource on machine and commit changes

Otherwise, it will: 
  - download Foreman resources in the Git repo path
  - commit changes

#### Sync Git repository into Foreman instance

   - Command `hammer push`
   - Options: resources list
 
If you want to update or delete a resource, you just have to:
   - for **update** - edit the resource file in the Git directory, and save the file,
   - for **delete** - run the `git rm <file_or_directory` command.

And then run the `hammer push` command. It will detect the change type and it will call the correct action on the resource, with the updated attributes.  

If you want to create a new resource, read below.

#### Create a new Foreman resource

There are two ways of creating a new resource in the Foreman instance, which will be also synced in the Git repository

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
 - `-a field_name=field_value,field_name_two=field_value_two` - pass a list of *key=value* pairs for each field you want to set. Remember the required fields, and that the "id" is optional.

The command will create the resource in the Foreman instance, sync Foreman resource in the Git repository and commit the changes.
