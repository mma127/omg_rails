# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

## Setup
### Ubuntu 20.04

#### Ruby
Requires Ruby 2.7.4\
Follow to setup rbenv and Ruby: https://gorails.com/setup/ubuntu/16.04#ruby-rbenv

1. Install Node.js and Yarn repositories
```
sudo apt install curl
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

sudo apt-get update
sudo apt-get install git-core zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common libffi-dev nodejs yarn
```

2. Install Ruby with `rbenv`
```
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
exec $SHELL

git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
exec $SHELL

rbenv install 2.7.4
rbenv global 2.7.4
ruby -v
```

#### Postgres
https://stackoverflow.com/a/20305467

3. Install postgresql\
`sudo apt-get install postgresql libpq-dev phppgadmin pgadmin3`

4. Log into postgresql as the postgres user\
`sudo su postgres -c psql`

5. In psql, using the username of the logged in user
```
postgres=# create user mma with password 'password';
CREATE ROLE
postgres=# alter user mma superuser;
ALTER ROLE
postgres=# create database omg_development;
CREATE DATABASE
postgres=# create database omg_test;
CREATE DATABASE
postgres=# grant all privileges on database omg_development to mma;
GRANT
postgres=# grant all privileges on database omg_test to mma;
GRANT
postgres=# \q
```

6. Update `database.yml` with
```
development:
  <<: *default
  host: localhost
  database: omg_development
  username: mma
  password: password
```

#### Bundle
7. Install gems\
`bundle install`

#### Database 
8. Setup the database\
`bundle exec rails db:setup`

### Start the server
`bundle exec rails server`