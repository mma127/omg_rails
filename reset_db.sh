#!/bin/bash
bundle exec rake db:drop db:create db:migrate db:seed --trace