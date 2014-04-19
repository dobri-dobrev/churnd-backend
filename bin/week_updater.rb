require './db.rb'
require 'active_support/all'
Mongoid.load!("mongoid.yml", :development)

def add_week_if_needed(proj)
	for acc in proj.accounts
		if proj.account_data[acc]['last_week_ends'] < DateTime.now
			proj.account_data[acc]['by_week'] << {}
			puts "added week"
			proj.account_data[acc]['last_week_ends']  = DateTime.now
			
		end
	end
	proj.save

end