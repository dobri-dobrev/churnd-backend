require './bin/week_updater.rb'

def calculate_login_frequency(proj)
	account_count = 0.0
	account_average = 0.0
	accounts = Account.where(project_id: proj._id).to_a
	for acc in accounts
		account_count += 1.0
		users = User.where(project_id: proj._id, account_id: acc._id)
		user_count = 0.0
		user_average = 0.0
		for user in users
			user_count +=1.0
			login_counter = 0.0
			logins = Interaction.where(project_id: proj._id, account_id: acc._id, email: user.email, type: "login", :time.gte => (DateTime.now-7.days))
			for log in logins
				login_counter += 1.0
			end
			user.weekly_login_rate = login_counter
			user.save
			user_average += login_counter
		end
		if user_count > 0.0
			user_average = user_average/user_count
		else
			user_average = 0.0
		end
		acc.weekly_login_rate = user_average
		acc.save
		account_average += user_average
		
	end
	if account_count>0.0
		account_average = account_average/account_count
	else
		account_average = 0.0
	end
	proj.weekly_login_rate = account_average
	proj.save
	
end

if __FILE__ == $0
    puts "Start Calculating Login Use"

    Project.all.each do |proj|
    	#add_week_if_needed(proj)
    	
    	calculate_login_frequency(proj)
    end


    puts "Done calculating Login Use"
end
