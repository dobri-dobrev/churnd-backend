require './db.rb'
require 'active_support'
Mongoid.load!("mongoid.yml", :development)
puts "Start"

user_List = []
interaction_List = []
acc_data = {}
acc_data['Perkla'] = {}
acc_data['Kwoller'] = {}
acc_data['Perkla']['user_count'] = 0
acc_data['Kwoller']['user_count'] = 0

project_1 = Client.where(name: "dmd2169").to_a[0].projects.create(name: "Percolate", url: "www.project.com", interaction_types: ['login', 'logout', "button1", "button2"], accounts: ["Perkla", "Kwoller"], account_data: acc_data)

for i in 0..20
   user_List << User.create(name: "User #{i}", email: "email#{i}@gmail.com", project_id: project_1._id, account: "Perkla")
   project_1.account_data['Perkla']['user_count']+=1
end

for i in 21..40
   user_List << User.create(name: "User #{i}", email: "email#{i}@gmail.com", project_id: project_1._id, account: "Kwoller")
   project_1.account_data['Kwoller']['user_count']+=1
end


for i in 0..10
	logins = (0..15).to_a.sample
	for k in (0.. 15)
		days_ago = DateTime.now-(0..15).to_a.sample.days
		login_time = days_ago+ (k*30).minutes
		logout_time = login_time + 20.minutes
		interaction_List << Interaction.create(email: "email#{i}@gmail.com", project_id: project_1._id, account: "Perkla", time: login_time, type: "login")
		interaction_List << Interaction.create(email: "email#{i}@gmail.com", project_id: project_1._id, account: "Perkla", time: logout_time, type: "logout")
	end
	
end

for i in 11..20
	logins = (0..15).to_a.sample
	for k in (0.. 15)
		days_ago = DateTime.now-(0..15).to_a.sample.days
		login_time = days_ago+ (k*30).minutes
		logout_time = login_time + 20.minutes
		interaction_List << Interaction.create(email: "email#{i}@gmail.com", project_id: project_1._id, account: "Perkla", time: login_time, type: "login")
		interaction_List << Interaction.create(email: "email#{i}@gmail.com", project_id: project_1._id, account: "Perkla", time: logout_time, type: "logout")
	end
end

for i in 21..40
	logins = (0..15).to_a.sample
	for k in (0.. logins)
		days_ago = DateTime.now-(0..6).to_a.sample.days
		login_time = days_ago+ (k*30).minutes
		logout_time = login_time + 20.minutes
		interaction_List << Interaction.create(email: "email#{i}@gmail.com", project_id: project_1._id, account: "Kwoller", time: login_time, type: "login")
		interaction_List << Interaction.create(email: "email#{i}@gmail.com", project_id: project_1._id, account: "Kwoller", time: logout_time, type: "logout")
	end
end
project_1.save

puts "done"