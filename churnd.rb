require 'sinatra'
require 'json'

get '/hello' do
	content_type :json
	{ :key1 => 'value1', :key2 => 'value2' }.to_json
end	

get '/registerNewCustomer' do
	content_type :json
	{ :key1 => 'value1', :key2 => 'value2' }.to_json
end

get '/' do
	erb :index
end