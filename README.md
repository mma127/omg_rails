# OMGmod Rails

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

### Start the webpack dev server
`./bin/webpack-dev-server`

This allows webpack to recompile assets continually, rather than on page reload.

### Start both the server and webpack
`bundle exec foreman start`

## Development

### Endpoints
We are using the `grape` gem to manage the API framework. Within this API, there are multiple API classes in 
`/app/api/omg` which each should correspond to a particular subpath. A new endpoint class
must be mounted in the base API class `api.rb`

To transform response entities, we use `grape-entity` to add a simple DSL on top
of ActiveRecord models. For any model we want to transform in an API response, we should add
the following in the class:
```ruby
  def entity
    Entity.new(self)
  end

  class Entity < Grape::Entity
    expose :id
    expose :name
    expose :player_id, as: :playerId
  end
```
Each exposed attribute is one on the model, and we should also use the `as` option to alias any
attribute names with underscores to camel case.