require 'sinatra'
require './utils'
require 'json'
require 'bcrypt'
require './db.rb'
# require 'mongo'

configure do
 	Mongoid.load!("mongoid.yml")
 	use Rack::Session::Cookie, :secret => 'naigolemiqborec'
end


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

before '/api/*' do
	if params[:key]== nil
		halt 404
	else
		p = Project.where(_id: params[:key]).to_a
		if p.length == 0
			halt 404
		else
			@current_project = p[0]
		end	
	end
end

#have to do empty field checking and email validation client side
post '/api/register_user' do
	if params[:email]==nil
		halt 404
	else
		if @current_project.users.where(email: params[:email]).exists?
			halt 200
		else
			if params[:name] == nil
				params[:name] = 'anon'
			end
			@current_project.users.create(name: params[:name], email: params[:email])
			halt 200
		end
	end
	
end

post '/api/track' do
	if params[:email] == nil || params[:type] == nil
		halt 404
	else
		users = @current_project.users.where(email: params[:email]).to_a
		#register new user in case it does not exist
		if users.length == 0
			user = @current_project.users.create(name: 'anon', email: params[:email])
		else
			user = users[0]
		end
		user.interactions.create(type: params[:type], time: DateTime.now)
		halt 200
	end
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
