require './bin/week_updater.rb'

def calculate_login_frequency(proj)
	account_count = 0.0
	account_average = 0.0
	account_data = proj.account_data
	for acc in proj.accounts
		account_count += 1.0
		users = User.where(project_id: proj._id, account: acc)
		user_count = 0.0
		user_average = 0.0
		for user in users
			user_count +=1.0
			login_counter = 0.0
			logins = Interaction.where(project_id: proj._id, account: acc, email: user.email, type: "login", :time.gte => (DateTime.now-7.days))
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
		if account_data.has_key?(acc)
			account_data[acc]['weekly_login_rate'] = user_average
		else
			account_data[acc] = {}
			account_data[acc]['weekly_login_rate'] = user_average
		end
		account_average += user_average
		
	end
	if account_average>0.0
		account_average = account_average/account_count
	else
		account_average = 0.0
	end
	proj.account_data = account_data
	proj.weekly_login_rate = account_average
	proj.save
	
end

def calculate_logins_in_range(start_date, end_date, proj, account)
	usrs = User.where(project_id: proj._id, account: account)
	total_user_average = 0.0
	for user in usrs

		logins = Interaction.where(project_id: proj._id, account: account, email: user.email, type: "login", :time.gte => start_date, :time.ste => end_date).to_a
		total_user_average += logins.length
	end
	return total_user_average/proj.account_data[account][user_count].to_f
end

if __FILE__ == $0
    puts "Start Calculating Login Use"

    Project.all.each do |proj|
    	add_week_if_needed(proj)
    	for account in proj.accounts
    		#puts calculate_logins_in_range(DateTime.now-7.days, DateTime.now, proj, account)
    	end
    	# calculate_login_frequency(proj)
    end


    puts "Done calculating Login Use"
end
