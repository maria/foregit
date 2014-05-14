foregit
=======

## What is Foregit?

Sysadmins don't like UIs that much. API/CLI is better but still, there is an ultimate tool every administrator loves: git. 
The idea is to have a tooling, that would turn the Foreman instance into a git repository of the managed infrastructure, allowing the user to edit that as any other config files, and reflecting the changes into the Foreman instance again via the API,once the changes are pushed.

Effectively, you would have a git repository representing the whole infrastructure. Cloning a host would copying a file, changing a parameter would mean just editing it's representation. One could even manage the whole infrastructure with Puppet.

[Chef](http://docs.opscode.com/) has a similar tool called [Knife](http://docs.opscode.com/knife.html).

## OPW

The project is developt during [GNOME Outreach Program for Women](http://gnome.org/opw/).
Organization: [Foreman](http://theforeman.org/gnomeopw.html)
Mentor: Ivan Nečas

