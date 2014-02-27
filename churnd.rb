require 'sinatra'
require './User.rb'
require './utils'
require 'json'

# configure do
# 	db = Mongo::Connection.new("localhost", 27017).db("testdb")
# end


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

get '/contact' do
	erb :contact
end