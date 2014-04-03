require './db.rb'
Mongoid.load!("test_mongoid.yml", :development)
puts "Start"

user_List = []
interaction_List = []

project_1 = Project.create(name: "Project 1", url: "www.project.com", interaction_types: ["button1", "button2"], accounts: ["Account 1", "Account 2"])

for i in 0..2
   user_List << User.create(name: "User #{i}", email: "email#{i}@gmail.com", project_id: "Project 1", account_name: "Account 1")
end

for i in 3..5
   user_List << User.create(name: "User #{i}", email: "email#{i}@gmail.com", project_id: "Project 2", account_name: "Account 2")
end


for i in 1..4
	interaction_List << Interaction.create(email: "email#{i}@gmail.com", project_id: "Project 1", account: "Account 1", time: DateTime.new(2014,4,i,10))
end

for i in 5..7
	interaction_List << Interaction.create(email: "email#{i}@gmail.com", project_id: "Project 2", account: "Account 2", time: DateTime.new(2014,4,i,11))
end

puts "done"