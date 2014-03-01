require 'mongoid'

class Client
	include Mongoid::Document
	field :name, type: String
	field :email, type: String
	field :password_salt, type: String
	field :password_hash, type: String
	embeds_many :projects
end

class Project
	include Mongoid::Document
	field :name, type: String
	embedded_in :client
end