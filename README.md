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
Requires Ruby 2.7\
`bundle config set path 'vendor/bundle'`\
`bundle install`

Postgres

https://stackoverflow.com/a/20305467

`sudo service postgres restart`
```psql
postgres=# create role omg with createdb login password 'omgmod';
CREATE ROLE
postgres=# alter user omg superuser;
ALTER ROLE
postgres=# create database omg_development;
CREATE DATABASE
postgres=# create database omg_test;
CREATE DATABASE
postgres=# grant all privileges on database omg_development to omg;
GRANT
postgres=# grant all privileges on database omg_test to omg;
```
`bundle exec rails db:setup`

