require './bin/week_updater.rb'


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

def calculate_feature_use_for_account(acc)
	proj = Project.where(_id: acc.project_id).to_a[0]
	project_features = proj.interaction_types
	total_counts = {}
	total_total = 0
	for p in project_features
		total_counts[p] = 0
	end
	account_interactions = Interaction.where(project_id: proj._id, account_id: acc._id).to_a
	for i in account_interactions
		total_total+= 1
		total_counts[i.type] += 1
	end
	total_results =[]
	for feature in project_features
		if total_total > 0
			total_results << total_counts[feature].fdiv(total_total)
		else
			total_results << 0
		end
	end
	acc.total_interaction_use = total_results
end


if __FILE__ == $0
    puts "Start Calculating Feature Use"

    Project.all.each do |proj|
    	#add_week_if_needed(proj)
    	calculate_feature_use(proj)
    end
    Account.all.each do|acc|
    	calculate_feature_use_for_account(acc)
    end


    puts "Done calculating Feature Use"
end
