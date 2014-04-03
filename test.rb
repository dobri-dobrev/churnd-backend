require './db.rb'
require 'active_support'
Mongoid.load!("mongoid.yml", :development)
puts "Start"

user_List = []
interaction_List = []

project_1 = Client.where(name: "dmd2169").to_a[0].projects.create(name: "Project 1", url: "www.project.com", interaction_types: ["button1", "button2"], accounts: ["Account 1", "Account 2"], account_data: {})

for i in 0..20
   user_List << User.create(name: "User #{i}", email: "email#{i}@gmail.com", project_id: project_1._id, account: "Account 1")
end

for i in 21..40
   user_List << User.create(name: "User #{i}", email: "email#{i}@gmail.com", project_id: project_1._id, account: "Account 2")
end


for i in 0..10
	logins = (0..15).to_a.sample
	for k in (0.. 15)
		days_ago = DateTime.now-(0..6).to_a.sample.days
		login_time = days_ago+ (k*30).minutes
		logout_time = login_time + 20.minutes
		interaction_List << Interaction.create(email: "email#{i}@gmail.com", project_id: project_1._id, account: "Account 1", time: login_time, type: "login")
		interaction_List << Interaction.create(email: "email#{i}@gmail.com", project_id: project_1._id, account: "Account 1", time: logout_time, type: "logout")
	end
	
end

for i in 11..20
	logins = (0..15).to_a.sample
	for k in (0.. 15)
		days_ago = DateTime.now-(0..15).to_a.sample.days
		login_time = days_ago+ (k*30).minutes
		logout_time = login_time + 20.minutes
		interaction_List << Interaction.create(email: "email#{i}@gmail.com", project_id: project_1._id, account: "Account 1", time: login_time, type: "login")
		interaction_List << Interaction.create(email: "email#{i}@gmail.com", project_id: project_1._id, account: "Account 1", time: logout_time, type: "logout")
	end
end

for i in 21..40
	logins = (0..15).to_a.sample
	for k in (0.. logins)
		days_ago = DateTime.now-(0..6).to_a.sample.days
		login_time = days_ago+ (k*30).minutes
		logout_time = login_time + 20.minutes
		interaction_List << Interaction.create(email: "email#{i}@gmail.com", project_id: project_1._id, account: "Account 2", time: login_time, type: "login")
		interaction_List << Interaction.create(email: "email#{i}@gmail.com", project_id: project_1._id, account: "Account 2", time: logout_time, type: "logout")
	end
end

puts "done"