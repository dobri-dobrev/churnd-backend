require 'sinatra'
require 'pony'
require './utils'
require 'json'
require 'bcrypt'
require './db.rb'


configure do
	Pony.options = {
	  :via => :smtp,
	  :via_options => {
	    :address => 'smtp.sendgrid.net',
	    :port => '587',
	    :domain => 'heroku.com',
	    :user_name => ENV['SENDGRID_USERNAME'],
	    :password => ENV['SENDGRID_PASSWORD'],
	    :authentication => :plain,
	    :enable_starttls_auto => true
	  }
	}
	set :protection, :except => [:http_origin]
 	Mongoid.load!("mongoid.yml")
 	use Rack::Session::Cookie, :secret => ENV['CHURND_COOKIE_SECRET']
end


[ '/projects', '/new_project', '/expanded_project', '/delete_project','/new_account', '/delete_account', '/new_interaction', '/delete_interaction', '/get_users'].each do |path|
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
			Interaction.create(email: @json_call_params['email'], project_id: @json_call_params['key'], account_name: @json_call_params['account'], type: "login", time: DateTime.now)
			puts "user already exists"
			halt 200
		else
			if @json_call_params['name'] == nil
				@json_call_params['name'] = 'anon'
			end
			User.create(name: @json_call_params['name'], email: @json_call_params['email'], project_id: @json_call_params['key'], account_name: @json_call_params['account'])
			@current_project.account_data[@json_call_params['account']]['user_count'] += 1
			Interaction.create(email: @json_call_params['email'], project_id: @json_call_params['key'], account_name: @json_call_params['account'], type: "login", time: DateTime.now)
			puts "user created"
			halt 200
		end
	end
	
end

get '/send_email' do
	enqueue_email("dobrev.d10@gmail.com", "dmd2169@columbia.edu", "queue", "wwwwwwaaaaaa")
	halt 200
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
	if session[:name] == nil
		erb :index
	else
		c = Client.where(name: session[:name]).to_a
		if c.length==0
			erb :index
		else
			redirect '/projects'
		end
	end
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
		@current_client.projects.create(name: params[:project_name], url: params[:url], accounts: [], interaction_types: ['login', 'logout'], account_data: {})
		return {:res => "win"}.to_json
	end
end

post '/delete_project' do
	puts params[:project_id]
	Project.where(_id: params[:project_id]).delete
	halt 200
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
		erb :expandedproject
	end
end
post '/new_account' do
	projects = Project.where(_id: params[:project_id]).to_a
	if projects.length == 0
		halt 404
	else
		@project_to_add_to = projects[0]
		unless @project_to_add_to.accounts.include?(params[:account_name])
			@project_to_add_to.accounts << params[:account_name]
			@project_to_add_to.account_data[params[:account_name]] = {}
			@project_to_add_to.account_data[params[:account_name]]['user_count'] = 0
			@project_to_add_to.save 
		end
		
		{:ret => 'win'}.to_json
	end
end

post '/delete_account' do
	projects = Project.where(_id: params[:project_id]).to_a
	if projects.length == 0
		halt 404
	else
		@project_to_add_to = projects[0]
		@project_to_add_to.accounts.delete(params[:account_name])
		@project_to_add_to.account_data[params[:account_name]] = {}
		@project_to_add_to.save
		halt 200
	end
end

post '/new_interaction' do
	projects = Project.where(_id: params[:project_id]).to_a
	if projects.length == 0
		halt 404
	else
		@project_to_add_to = projects[0]
		@project_to_add_to.interaction_types << params[:interaction_name] unless @project_to_add_to.interaction_types.include?(params[:interaction_name]) 
		@project_to_add_to.save
		{:ret => 'win'}.to_json
	end
end

post '/delete_interaction' do
	projects = Project.where(_id: params[:project_id]).to_a
	if projects.length == 0
		halt 404
	else
		@project_to_add_to = projects[0]
		@project_to_add_to.interaction_types.delete(params[:interaction_name])
		@project_to_add_to.save
		halt 200
	end
end

post '/get_users' do
	users = User.where(project_id: params[:project_id], account: params[:account_name]).to_a
	user_names = []
	emails = []
	for user in users
		user_names<< user.name
		emails << user.email
	end
	{:users => user_names, :emails =>emails}.to_json
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
