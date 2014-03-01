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


get '/hello' do
	content_type :json
	Utils.test()
	{ :key1 => 'value1', :key2 => 'value2' }.to_json
end	

get '/registerNewCustomer' do
	content_type :json
	{ :key1 => 'value1', :key2 => 'value2' }.to_json
end

get '/' do
	puts session[:name]
	erb :index
end

get '/register' do
	erb :register
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

post '/login' do
	c = Client.where(name: params[:name]).to_a
	puts params[:password]
	if c.length==0
		puts "wrong username"
		halt 404
	else
		salt = c[0].password_salt
		if BCrypt::Engine.hash_secret(params[:password], salt) == c[0].password_hash
			session[:name]= params[:name] 
			{ :result => 'good'}.to_json
		else
			puts "hash problem"
			halt 404
		end
		
	end
end
