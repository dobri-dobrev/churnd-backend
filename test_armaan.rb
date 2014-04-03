require './db.rb'
Mongoid.load!("mongoid.yml", :development)
puts "Start"

user_List = []
interaction_List = []


#project_1 = Project.create(name: "Project 1", url: "www.project.com", interaction_types: ["button1", "button2"], accounts: ["Account 1", "Account 2"])

c = Client.where(name: "facebook").to_a
client_1 = c[0]
p1 = client_1.projects.create(name: "Project 1", url: "www.project1.com", interaction_types: ["button1", "button2"], accounts: ["Account 1", "Account 2"])
p2 = client_1.projects.create(name: "Project 2", url: "www.project2.com", interaction_types: ["button1", "button2"], accounts: ["Account 3", "Account 4"])

for i in 0..2
   user_List << User.create(name: "User #{i}", email: "email#{i}@gmail.com", project_id: p1._id , account: "Account 1")
end

for i in 3..5
   user_List << User.create(name: "User #{i}", email: "email#{i}@gmail.com", project_id: p2._id, account: "Account 4")
end


for i in 1..4
	interaction_List << Interaction.create(type: "Happy", email: "email#{i}@gmail.com", project_id: p1._id, account: "Account 1", time: DateTime.new(2014,4,i,10))
end

for i in 5..7
	interaction_List << Interaction.create(type: "Sad", email: "email#{i}@gmail.com", project_id: p2._id, account: "Account 4", time: DateTime.new(2014,4,i,11))
end

puts "done"