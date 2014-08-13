require 'sinatra'
require 'data_mapper'

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

# DataMapper below. Assign all notes from DB to @notes instance variable. Use '@' (instance variable) so that the variable is available within the view.
get '/' do
	@notes = Note.all :order => :id.desc
	@title = 'All Notes'
	erb :home
end

# Handle POST of new notes.
post '/' do
	n = Note.new
	# Content column is the 'content' textarea from the form.
	n.content = params[:content]
	n.created_at = Time.now
	n.updated_at = Time.now
	n.save
	# Once new note added, return to default view (GET /)
	redirect '/'
end

# Handle editing notes as /:id
get '/:id' do
	@note = Note.get params[:id]
	@title = "Edit note ##{params[:id]}"
	erb :edit
end

# PUT is actually the proper HTTP method for modifying
put '/:id' do
	# DataMapper SELECT
	n = Note.get params[:id]
	n.content = params[:content]
	# Does checkbox param exist? if so, set complete column to true. This works because Checkboxes are only submitted thru forms if checked, so we only need to check if the param exists, not true/false.
	n.complete = params[:complete] ? 1 : 0
	n.updated_at = Time.now
	n.save
	redirect '/'
end

get '/:id/delete' do
	@note = Note.get params[:id]
	@title = "Confirm deletion of note ##{params[:id]}"
	erb :delete
end

# Again, the DELETE HTTP method was spoofed because browsers do not support it.
delete '/:id' do
	n = Note.get params[:id]
	n.destroy
	redirect '/'
end

# Complete notes at /:id/complete
get '/:id/complete' do
	n = Note.get params[:id]
	n.complete = n.complete ? 0 : 1 # flip it
	n.updated_at = Time.now
	n.save
	redirect '/'
end