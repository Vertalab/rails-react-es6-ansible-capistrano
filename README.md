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

[config/ansible/group_vars/all.yml](https://github.com/Miicky/rails-react-es6-ansible-capistrano/blob/master/config/ansible/group_vars/all.yml)
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

Tasks:
1. Check ping host
2. Create new group for user
3. Create new user with group
4. Ensure sudoers.d is enabled
5. Remove password from user
6. Add public keys for SSH
7. Remote access with SSH for root user
8. Remote password SSH access
9. Restart SSH to apply changes
10. Update apt-get libraries

####3. Run playbook
This step will configure server and includes few parts:

*  Install dependencies (relating to you'r rails application)
  1. Check ping host
  2. apt-get upgrade
  3. Install dependencies from /group_vars/all.yml
* Install ruby through rbenv (may take longer)
  1. Update rbenv repository
  2. Add rbenv to path
  3. Copy initialization to profile
  4. Check if ruby-build installed
  5. Create temporary folder
  6. Clone ruby-build repository
  7. Install ruby-build
  8. Remove temporary folder
  9. Check ruby installed
  10. Install ruby
  11. Set global verson ruby
  12. Rehash rbenv
  13. Copy germs
* Install and configuring Postgres
  1. Check default user enabled
  2. Copy auth type
  3. Restart service
  4. Create shared folder for database.yml
  5. Copy database.yml to shared folder
  6. Create database
  7. Ensure user has access to database
  8. Change privilege user
* Install and configuring Nginx and Puma
  1. Check enabled config
  2. Create folder
  3. Copy config file
  4. Restart Nginx
* Install Node through nvm
  1. Install dependencies
  2. Install nvm
  3. Source nvm in ~/.profile
  4. Install Node
  5. Check default Node version
  6. Set default Node version
* Else small configuring, some relating to DigitalOcean
  1. Copy secrets.yml for Rails
  2. set CHMOd for rbenv
  3. Install bundler
  4. Run rbenv Rehash
  5. Install locales package (for DigitalOcean)
  6. Ensure locale exists (for DigitalOcean)
  7. Add locale to environment (for DigitalOcean)

Command:

```
$ ansible-playbook -i SERVER_IP, playbook.yml
```

####4. Change variables to setup Capistrano
[config/deploy.rb](https://github.com/Miicky/rails-react-es6-ansible-capistrano/blob/master/config/deploy.rb)
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
