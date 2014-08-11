require 'sinatra'
require 'datamapper'

# Set up a new SQLite3 database in the current directory, named recall.db
DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/recall.db")

=begin
Set up Notes table in DB
The 'Notes' table will have 5 fields. An id field which will be an integer primary key and auto-incrementing (this is what 'Serial' means). A content field containing text, a boolean complete field and two datetime fields, created_at and updated_at.
=end
class Note
	include DataMapper::Resource
	property :id, Serial
	property :content, Text, :required => true
	property :complete, Boolean, :required => true, :default => false
	property :created_at, DateTime
	property :updated_at, DateTime
end

# Automatically update the database to contain the tables and fields we have set, and do so again if we make any changes to the schema
DataMapper.finalize.auto_upgrade!

get '/' do
	@notes = Note.all :.order => :id.desc
	@title = 'All Notes'
	erb :home
end