require 'sinatra'
require 'pony'
require './utils'
require 'json'
require 'bcrypt'
require './db.rb'
require 'active_support/all'


configure do
	set :protection, :except => [:http_origin]
 	Mongoid.load!("mongoid.yml")
 	use Rack::Session::Cookie, :secret => ENV['CHURND_COOKIE_SECRET']
end


[ '/projects', '/new_project', '/expanded_project', '/delete_project','/new_account', '/delete_account', '/new_interaction', '/delete_interaction', '/expanded_account'].each do |path|
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
	current_account = Account.where(project_id: @json_call_params['key'], name: @json_call_params['account']).to_a[0]
	if current_account.nil?
		halt 404
	end
	if @json_call_params['email']==nil || @json_call_params['key'] == nil || @json_call_params['account'] == nil
		halt 404
	else 
		if User.where(email: @json_call_params['email'], project_id: @json_call_params['key'], account_id: current_account._id ).exists?
			Interaction.create(email: @json_call_params['email'], project_id: @json_call_params['key'], account_id: current_account._id, type: "login", time: DateTime.now)
			halt 200
		else
			if @json_call_params['name'] == nil
				@json_call_params['name'] = 'anon'
			end
			User.create(name: @json_call_params['name'], email: @json_call_params['email'], project_id: @json_call_params['key'], account_name: current_account._id)
			current_account.user_count += 1
			current_account.save
			Interaction.create(email: @json_call_params['email'], project_id: @json_call_params['key'], account_id: current_account._id, type: "login", time: DateTime.now)
			halt 200
		end
	end
	
end
# GET RID OF THIS
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
		current_account = Account.where(project_id: @json_call_params['key'], name: @json_call_params['account']).to_a[0]
		if current_account.nil?
			halt 404
		end
		if User.where(email: @json_call_params['email'], project_id: @json_call_params['key'], account_id: current_account._id).exists?
			Interaction.create(email: @json_call_params['email'], project_id: @json_call_params['key'], account_id: current_account._id, type: @json_call_params['type'], time: DateTime.now)
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
		current_account = Account.where(project_id: @json_call_params['key'], name: @json_call_params['account']).to_a[0]
		if current_account.nil?
			halt 404
		end
		if User.where(email: @json_call_params['email'], project_id: @json_call_params['key'], account_id: current_account._id).exists?
			Interaction.create(email: @json_call_params['email'], project_id: @json_call_params['key'], account_id: current_account._id, type: "logout", time: DateTime.now)
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
		@current_client.projects.create(name: params[:project_name], url: params[:url], interaction_types: ['login', 'logout'])
		return {:res => "win"}.to_json
	end
end

post '/delete_project' do
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
		@accounts = Account.where(project_id: @project_to_view._id).to_a
		erb :expandedproject
	end
end
post '/new_account' do
	projects = Project.where(_id: params[:project_id]).to_a
	if projects.length == 0
		halt 404
	else
		@project_to_add_to = projects[0]
		unless Account.where(name: params[:account_name], project_id: @project_to_add_to._id).exists?
			Account.create(name: params[:account_name], project_id: @project_to_add_to._id, user_count: 0, data_by_week: [])
		end
		
		{:ret => 'win'}.to_json
	end
end

post '/delete_account' do
	acc = Account.where(project_id: params[:project_id], name: params[:account_name]).to_a[0]
	if acc.nil?
		halt 404
		
	else
		acc.delete
		Rule.where(account_id: acc._id ).delete
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

get '/expanded_account' do
	@current_account = Account.where(project_id: params[:project_id], name: params[:account]).to_a[0]
	if @current_account.nil?
		halt 404
	end
	@users_in_account = User.where(project_id: params[:project_id], account_id: @current_account._id).to_a
	@rules_in_account = Account.where(account_id: @current_account._id)
	erb :expanded_account
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
