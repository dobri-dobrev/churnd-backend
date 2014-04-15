require './db.rb'
require 'active_support/all'
require 'pony'
Mongoid.load!("mongoid.yml", :development)


Pony.options = {
	  :via => :smtp,
	  :via_options => {
	    :address => 'smtp.sendgrid.net',
	    :port => '587',
	    :domain => 'heroku.com',
	    :user_name => ENV['SENDGRID_USERNAME'],
	    :password => ENV['SENDGRID_PASSWORD'],
	    :authentication => :plain,
	    :enable_starttls_auto => true
	  }
	}
for email in Email.where(sent: false)
	Pony.mail(
		:to => email.to,
		:from => email.from,
		:subject => email.subject,
		:body => email.body
		)
	email.sent = true
	email.sent_at = DateTime.now
	email.save
end