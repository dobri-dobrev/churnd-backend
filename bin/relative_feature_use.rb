require './db.rb'
require 'active_support/all'
Mongoid.load!("mongoid.yml", :development)


def calculate_feature_use(proj)
	project_features = proj.interaction_types
	daily_counts = {}
	weekly_counts = {}
	total_counts = {}
	daily_total = 0
	weekly_total = 0
	total_total = 0
	for p in project_features
		daily_counts[p] = 0
		weekly_counts[p] = 0
		total_counts[p] = 0
	end
	project_interactions = Interaction.where(project_id: proj._id)
	for i in project_interactions
		if i.time.today?
			daily_total +=1
			daily_counts[i.type] += 1
		end
		if i.time + 7.days> DateTime.now
			weekly_total +=1
			weekly_counts[i.type] +=1
		end
		total_total+= 1
		total_counts[i.type] += 1
	end
	daily_results = []
	weekly_results = []
	total_results = []
	for feature in project_features
		if daily_total > 0
			daily_results << daily_counts[feature].fdiv(daily_total)
		else
			daily_results << 0
		end

		if weekly_total > 0
			weekly_results << weekly_counts[feature].fdiv(weekly_total)
		else
			weekly_results << 0
		end

		if total_total > 0
			total_results << total_counts[feature].fdiv(total_total)
		else
			total_results << 0
		end
		
	end
	proj.daily_interaction_type_use = daily_results
	proj.weekly_interaction_type_use = weekly_results
	proj.total_interaction_type_use = total_results
	proj.save
end

if __FILE__ == $0
    puts "Start Calculating Feature Use"

    Project.all.each do |proj|
    	calculate_feature_use(proj)
    end


    puts "Done calculating Feature Use"
end
