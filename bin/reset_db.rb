require './db.rb'
Mongoid.load!("mongoid.yml", :development)

User.delete_all
Account.delete_all
Project.delete_all
Interaction.delete_all