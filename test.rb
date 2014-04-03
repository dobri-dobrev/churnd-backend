require './db.rb'
Mongoid.load!("test_mongoid.yml", :development)
puts "Start"

user_List = []

for i in 0..5
   user_List << User.create(name: "User #{i}", email: "email#{i}@gmail.com", project_id: "Project #{i}", account_name: "Account #{i}")
end

puts "done"