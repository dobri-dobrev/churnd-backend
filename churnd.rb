require 'sinatra'
require './utils'
require 'json'
require 'bcrypt'
require './db.rb'
# require 'mongo'

['/hello', '/projects', '/new_project'].each do |path|
    before path do
        if session[:name] == nil
        	redirect '/login'
        else
        	c = Client.where(name: session[:name]).to_a
    		if c.length==0
    			redirect '/login'
    		else
    			@current_client = c[0]
    		end
        end
    end
end

configure do
 	Mongoid.load!("mongoid.yml")
 	use Rack::Session::Cookie, :secret => 'naigolemiqborec'
end


get '/hello' do
	puts @current_client.name
	content_type :json
	{ :key1 => 'value1', :key2 => 'value2' }.to_json
end	

get '/' do
	erb :index
end

get '/register' do
	erb :register
end

get '/projects' do
	@projects = @current_client.projects
	erb :project
end

post '/new_project' do
	puts params[:project_name]
	if @current_client.projects.where(name: params[:project_name]).exists?
		puts "project already exists"
		return {:res => "exists"}.to_json
	else
		puts "created new project"
		@current_client.projects.create(name: params[:project_name], url: params[:url])
		return {:res => "win"}.to_json
	end
end

get '/addproject' do
	erb :addproject
end

post '/register' do
	if Client.where(name: params[:name]).exists?
		halt 404
		
	else
		password_salt = BCrypt::Engine.generate_salt
		password_hash = BCrypt::Engine.hash_secret(params[:password], password_salt)
		c = Client.create(name: params[:name], email: params[:email], password_salt: password_salt, password_hash: password_hash)
		session[:name] = params[:name]
		puts c._id
		content_type :json
		{:ret => 'win'}.to_json
	end
	
end

get '/contact' do
	erb :contact
end

get '/logout' do
	session[:name] = nil
	redirect '/'
end

get '/login' do
	erb :login
end

post '/api/register_event' do
#unique id for project + email+ event name
	{:key => "test"}.to_json
end

post '/login' do
	c = Client.where(name: params[:name]).to_a
	if c.length==0
		halt 404
	else
		salt = c[0].password_salt
		if BCrypt::Engine.hash_secret(params[:password], salt) == c[0].password_hash
			session[:name]= params[:name] 
			{ :result => 'good'}.to_json
		else
			halt 404
		end
		
	end
end
