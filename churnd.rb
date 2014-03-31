require 'sinatra'
require './utils'
require 'json'
require 'bcrypt'
require './db.rb'
# require 'mongo'

configure do
	set :protection, :except => [:http_origin]
 	Mongoid.load!("mongoid.yml")
 	use Rack::Session::Cookie, :secret => ENV['CHURND_COOKIE_SECRET']
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
options '/api/*' do
  response.headers["Access-Control-Allow-Origin"] = "*"
  response.headers["Access-Control-Allow-Headers"] = "Content-Type"
  response.headers["Access-Control-Allow-Methods"] = "POST"
  
end

#need to make sure this is just for post and not OPTIONS
before '/api/*' do
	if request.request_method == "POST"
		@json_call_params = JSON.parse(request.body.read)
		puts @json_call_params.inspect
		puts @json_call_params['key']
		if @json_call_params['key'] == nil
			halt 404
		else
			p = Project.where(_id: @json_call_params['key']).to_a
			if p.length == 0
				halt 404
			else
				@current_project = p[0]
				puts @current_project.name
			end	
		end
	end
end


#needs to check if project has that account
post '/api/login' do
	response.headers["Access-Control-Allow-Origin"] = "*"
	if @json_call_params['email']==nil || @json_call_params['key'] == nil || @json_call_params['account'] == nil
		halt 404
	else 
		if User.where(email: @json_call_params['email'], project_id: @json_call_params['key'], account_name: @json_call_params['account']).exists?
			puts "user already exists"
			halt 200
		else
			if @json_call_params['name'] == nil
				@json_call_params['name'] = 'anon'
			end
			User.create(name: @json_call_params['name'], email: @json_call_params['email'], project_id: @json_call_params['key'], account_name: @json_call_params['account'])
			puts "user created"
			halt 200
		end
	end
	
end

#needs to check if project has the type registered and the account
post '/api/track' do
	response.headers["Access-Control-Allow-Origin"] = "*"
	if @json_call_params['email'] == nil || @json_call_params['type'] == nil || @json_call_params['key'] == nil || @json_call_params['account'] == nil
		halt 404
	else
		if User.where(email: @json_call_params['email'], project_id: @json_call_params['key'], account_name: @json_call_params['account']).exists?
			Interaction.create(email: @json_call_params['email'], project_id: @json_call_params['key'], account_name: @json_call_params['account'], type: @json_call_params['type'], time: DateTime.now)
			puts "created interaction"
			halt 200
		else
			halt 404
		end
		
	end
end

post '/api/logout' do
	response.headers["Access-Control-Allow-Origin"] = "*"
	if @json_call_params['email'] == nil || @json_call_params['key'] == nil || @json_call_params['account'] == nil
		halt 404
	else
		if User.where(email: @json_call_params['email'], project_id: @json_call_params['key'], account_name: @json_call_params['account']).exists?
			Interaction.create(email: @json_call_params['email'], project_id: @json_call_params['key'], account_name: @json_call_params['account'], type: "logout", time: DateTime.now)
			puts "logout recorded"
			halt 200
		else
			halt 404
		end
		
	end
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
		@current_client.projects.create(name: params[:project_name], url: params[:url], accounts: [], interaction_types: [])
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

get '/expanded_project' do
	projects = Project.where(_id: params[:project_id]).to_a
	if projects.length == 0
		halt 404
	else
		@project_to_view = projects[0]
		erb :account
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
