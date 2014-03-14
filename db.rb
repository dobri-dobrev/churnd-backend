require 'mongoid'

class Client
	include Mongoid::Document
	field :name, type: String
	field :email, type: String
	field :password_salt, type: String
	field :password_hash, type: String
	has_many :projects
end

class Project
	include Mongoid::Document
	field :name, type: String
	field :url, type: String
	belongs_to :client
	has_many :accounts
	embeds_many :types
end
#think about expiration dates, etc
class Account
	include Mongoid::Document
	field :name, type: String
	field :value, type: Integer
	has_many :users
	belongs_to :project

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
	belongs_to :account
	has_many :interactions
end

class Interaction
	include Mongoid::Document
	field :type, type: String
	field :time, type: DateTime
	belongs_to :user, dependent: :destroy
end

