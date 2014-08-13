require 'sinatra'

get '/' do  #localhost:port
	"hello, world"
end

get '/about' do  #localhost:port/about
	"something about myself and this site again"
end

get '/hello/:name' do  #/hello/austin
	params[:name]  #Use the params array to retrieve values from the url using its defined key. The params array contains GET and POST variables also.
end

get '/hello/:name/:city' do  #/hello/austin heiman/op
	"Hello there, #{params[:name].upcase} from #{params[:city].capitalize}!"
end

get '/more/*' do  #/more/some%20more%20stuff
	params[:splat]
end

get '/view' do
	erb :basic_view  #sinatra will look for "basic_view.erb" in ./views/ directory
end

get '/form' do
	erb :form
end

post '/form' do
	"<p>Message received as '#{params[:message]}' using HTTP POST.</p><p>Note the the 'name' attribute of the POST'ed item was 'message' so it is retrieved from the params array as <code>params[:message]</code>.</p>"
end

get '/secret' do
	erb :secret
end

post '/secret' do
	"<p>Encoded message follows:</p><p><code>#{params[:secret].reverse}</code></p><p><a href='/decrypt/#{params[:secret].reverse}'>Decrypt the message</a></p>"
end

get '/decrypt/:secret' do
	"<p>Decrypted message follows:</p><p><code>#{params[:secret].reverse}</code></p>"
end

not_found do
	# Use Sinatra's halt method for bad requests.
	# Note that halt is a method, in Ruby there is no need to wrap parameters in parentheses.
	# Meaning that the below line is the same as `halt(404,"page not found")`
	halt 404, 'page not found'
end
