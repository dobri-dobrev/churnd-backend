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
	#account data is kept in a hash
	# current fields in the hash: weekly_login_rate, user_count
	#interaction data is kept in arrays weirdly enough
	include Mongoid::Document
	field :name, type: String
	field :url, type: String
	field :interaction_types, type: Array
	field :accounts, type: Array
	field :account_data, type: Hash
	field :weekly_login_rate, type: Float
	field :daily_interaction_type_use, type: Array
	field :weekly_interaction_type_use, type: Array
	field :total_interaction_type_use, type: Array
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

class Email
	include Mongoid::Document
	field :to, type: String
	field :from, type: String
	field :subject, type: String
	field :body, type: String
	field :sent, type: Boolean
	field :sent_at, type: DateTime
end

def enqueue_email(from, to, subject, body)
	Email.create(from: from, to: to, subject: subject, body: body, sent: false)
end



