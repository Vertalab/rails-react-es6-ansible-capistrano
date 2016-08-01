# rails-react-es6-ansible-capistrano
## Fast confguration server and deploy with [Ansible](https://github.com/ansible/ansible) and [Capistrano](https://github.com/capistrano/capistrano)

###Info
 This example shows how to make a simple initial configuration server based on Ubuntu 14.04 x64 to deploy Rails application with
  * Ruby on Rails on back-end
  * ReactJs (es6) on front-end
  * Postgress on database
  * Nginx and puma on web-server


The efficiency was tested
* DigitalOcean Ubuntu 14.04 x64
* Ruby 2.3.1
* Rails 5.0.0
* Puma 3.4.0
* Node 6.3.0 (webpack for es6)
* Capistrano 3.4.0
* Ansible 2.1.0.0
---

####1. Change variables to setup Ansible

[config/ansible/group_vars/all.yml]()
* ruby_version
* name - application name (use to create folder)
* node_version - like in package.json
* db:
  * name: database name
  * user: database user
  * password: database password

####2. Run init_user
This step will remove access the server like root and will create a new deploy user
Command:

```
$ cd config/ansible
$ ansible-playbook -i SERVER_IP, init_user.yml
```

Attention! Access to the server for the root wiil be close! If you are not sure, remove rows 36-41 (Remove root SSH access) from init_user.yml

####3. Run playbook
This step will configure server and includes few parts:

1. Install dependences (relating to you'r rails application)
2. Install ruby through rbenv (may take longer)
3. Install and configuring Postgres
4. Install and configuring Nginx and Puma
5. Install Node through nvm
6. Else small configuring, some relating to DigitalOcean

Command:

```
$ ansible-playbook -i SERVER_IP, playbook.yml
```

####4. Change variables to setup Capistrano
[config/deploy.rb]()
Server is ready for deploying through Capistrano
But after initial setup Capistrano, you need to change the variables according to the ansible variables

:application - the same name: in all.yml
:user - the same remote_user: in playbook.yml and user: in all.yml
:rbenv_ruby - the same ruby_version: in all.yml
:nvm_node, - the same nvm.node_version: in all.yml

####5. Run deploy
```
$ cd ../..
$ cap staging deploy
```
