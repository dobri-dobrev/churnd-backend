require 'sinatra'
require './utils'
require 'json'
require 'bcrypt'
require './db.rb'
# require 'mongo'

configure do
 	Mongoid.load!("mongoid.yml")
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
	erb :index
end

get '/register' do
	erb :register
end

post '/register' do
	puts params[:password]
	password_salt = BCrypt::Engine.generate_salt
	password_hash = BCrypt::Engine.hash_secret(params[:password], password_salt)
	Client.create(name: params[:name], email: params[:email], password_salt: password_salt, password_hash: password_hash)
	content_type :json
	{:ret => 'win'}.to_json
end

get '/contact' do
	erb :contact
end