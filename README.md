#Vagrant-Hubot

Sets up Hubot on a Vagrant-provisioned machine via Puppet.

Uses the Slack adapter.

##Pre-reqs

- [Vagrant](https://www.vagrantup.com/) (duh)
- [librarian-puppet](https://github.com/rodjek/librarian-puppet) for installing/managing Puppet modules

##Getting started

Install the Puppet modules using `librarian-puppet`

    librarian-puppet install

Update `files/common.yaml` to specify your Slack API token

Start the VM

    vagrant up



