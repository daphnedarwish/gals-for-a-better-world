require 'bundler'
Bundler.require
require './app/models/answer'
require './app/models/survey'
require './app/models/user'
require './app/models/question'

configure :development do
  set :database, "sqlite3:db/database.db"
end