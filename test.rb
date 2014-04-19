require './db.rb'
require 'active_support'
Mongoid.load!("mongoid.yml", :development)
puts "Start"

user_List = []
interaction_List = []


project_1 = Client.where(name: "dmd2169").to_a[0].projects.create(name: "Percolate", url: "www.project.com", interaction_types: ['login', 'logout', "button1", "button2"])
perkla = Account.create(name: "Perkla", project_id: project_1._id, user_count: 0)
kwoller = Account.create(name: "Kwoller", project_id: project_1._id, user_count: 0)

for i in 0..20
   user_List << User.create(name: "User #{i}", email: "email#{i}@gmail.com", project_id: project_1._id, account_id: perkla._id )
   perkla.user_count += 1
end

for i in 21..40
   user_List << User.create(name: "User #{i}", email: "email#{i}@gmail.com", project_id: project_1._id, account_id: kwoller._id)
   kwoller.user_count += 1
end


for i in 0..10
	logins = (0..15).to_a.sample
	for k in (0.. logins)
		days_ago = DateTime.now-(0..12).to_a.sample.days
		login_time = days_ago+ (k*30).minutes
		logout_time = login_time + 20.minutes+ (1..20).to_a.sample.minutes
		interaction_List << Interaction.create(email: "email#{i}@gmail.com", project_id: project_1._id, account_id: perkla._id, time: login_time, type: "login")
		interaction_List << Interaction.create(email: "email#{i}@gmail.com", project_id: project_1._id, account_id: perkla._id, time: login_time+ 2.minutes, type: "button1")
		interaction_List << Interaction.create(email: "email#{i}@gmail.com", project_id: project_1._id, account_id: perkla._id, time: login_time + 3.minutes, type: "button1")
		interaction_List << Interaction.create(email: "email#{i}@gmail.com", project_id: project_1._id, account_id: perkla._id, time: login_time + 4.minutes, type: "button2")
		interaction_List << Interaction.create(email: "email#{i}@gmail.com", project_id: project_1._id, account_id: perkla._id, time: logout_time, type: "logout")
	end
	
end

for i in 11..20
	logins = (0..15).to_a.sample
	for k in (0.. logins)
		days_ago = DateTime.now-(0..12).to_a.sample.days
		login_time = days_ago+ (k*30).minutes
		logout_time = login_time + 20.minutes+ (1..20).to_a.sample.minutes
		interaction_List << Interaction.create(email: "email#{i}@gmail.com", project_id: project_1._id, account_id: perkla._id, time: login_time, type: "login")
		interaction_List << Interaction.create(email: "email#{i}@gmail.com", project_id: project_1._id, account_id: perkla._id, time: login_time+ 2.minutes, type: "button1")
		interaction_List << Interaction.create(email: "email#{i}@gmail.com", project_id: project_1._id, account_id: perkla._id, time: login_time + 3.minutes, type: "button1")
		interaction_List << Interaction.create(email: "email#{i}@gmail.com", project_id: project_1._id, account_id: perkla._id, time: login_time + 4.minutes, type: "button2")
		interaction_List << Interaction.create(email: "email#{i}@gmail.com", project_id: project_1._id, account_id: perkla._id, time: logout_time, type: "logout")
	end
end

for i in 21..40
	logins = (0..15).to_a.sample
	for k in (0.. logins)
		days_ago = DateTime.now-(0..6).to_a.sample.days
		login_time = days_ago + (k*30).minutes
		logout_time = login_time + 20.minutes+ (1..20).to_a.sample.minutes
		interaction_List << Interaction.create(email: "email#{i}@gmail.com", project_id: project_1._id, account_id: kwoller._id, time: login_time, type: "login")
		interaction_List << Interaction.create(email: "email#{i}@gmail.com", project_id: project_1._id, account_id: kwoller._id, time: logout_time, type: "logout")
	end
end
project_1.save
kwoller.save
perkla.save

puts "done"