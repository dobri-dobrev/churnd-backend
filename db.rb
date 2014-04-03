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
	field :interaction_types, type: Array
	field :accounts, type: Array
	field :account_data, type: Hash
	field :weekly_login_rate, type: Float
	belongs_to :client
end



class User
	include Mongoid::Document
	field :name, type: String
	field :email, type: String
	field :project_id, type: String
	field :account, type: String
	field :weekly_login_rate, type: Float
end

class Interaction
	include Mongoid::Document
	field :type, type: String
	field :time, type: DateTime
	field :email, type: String
	field :project_id, type: String
	field :account, type: String
	belongs_to :user, dependent: :destroy
end
