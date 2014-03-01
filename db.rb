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
	has_many :users
	embeds_many :types
end

class Type
	include Mongoid::Document
	field :name, type: String
	field :html_id, type: String
	embedded_in :project
end

class User
	include Mongoid::Document
	field :name, type: String
	field :email, type: String
	belongs_to :project
	has_many :interactions
end

class Interaction
	include Mongoid::Document
	field :type, type: String
	field :time, type: DateTime
	belongs_to :user, dependent: :destroy
end

