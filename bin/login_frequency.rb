require './db.rb'
require 'active_support/all'
Mongoid.load!("mongoid.yml", :development)

def calculate_login_frequency(proj)
	for acc in proj.accounts
		users = User.where(project_id: proj._id, account: acc)
		for user in users
			counter = 0
			logins = Interaction.where(project_id: proj._id, account: acc, email: user.email, type: "login")
			for log in logins
				counter += 1
			end
			#persist counts 
			puts user.name + " "+ counter.to_s
		end
	end
	
end

puts "Start"

# projects = []

# Project.all.each do |proj|
# 	projects << proj
# end

# for p in projects
# 	calculate_login_frequency(p)
# end

pr = Project.where(name: "Project 1").to_a[0]
calculate_login_frequency(pr)


#needs to create account data objects for accounts if they do not exist anymore!!!


# for i in 0..5
#    user_List << User.create(name: "User #{i}", email: "email#{i}@gmail.com", project_id: "Project #{i}", account_name: "Account #{i}")
# end

puts "done"