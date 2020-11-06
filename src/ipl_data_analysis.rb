class IPLDataAnalyzer
	attr_accessor :matches_file, :deliveries_file, :matches_data, :deliveries_data, :seasons, :teams

	def initialize(matches , deliveries)
		begin
			@matches_data = matches
			@deliveries_data = deliveries
			set_seasons_and_teams()
		rescue StandardError => ex
			puts ex.message
		end
	end

	def set_seasons_and_teams
		@seasons = (@matches_data.map { |match| match[:season] }).to_set.sort
		@teams = (@matches_data.map {|match| match[:team1]}).to_set.to_a
	end

	def matches_played_per_year(team)
		begin
			year_wise_matches = Hash[@seasons.product([0])]
			@matches_data.each do |match|
				if match[:team1] == team or match[:team2] == team
					year_wise_matches[match[:season]] += 1
				end
			end
			return year_wise_matches
		rescue StandardError => ex
			puts ex.message			
		end
	end

	def matches_won_by_all_teams_over_all_years
		# @matches_data.each do |match|
		# 	total_matches_hash[match[:winner]] += 1 if match[:winner] != nil
		# end
		begin
			total_matches_hash = {}
			teams.each do |team|
				total_matches_hash[team] = []
				@seasons.each do |season|
					total_matches_hash[team].push((@matches_data.select {|match| match[:winner] == team and match[:season] == season }).size)
				end
			end
			return total_matches_hash
		rescue StandardError => ex
			puts ex.message
		end
	end

	def extra_run_conceded_per_team_by_season(year)
		begin
			extra_runs_per_team = {}
			year_matches = @matches_data.select {|match| match[:season] == year}
			@teams.each do |team|
				extra_runs_per_team[team] = (year_matches.select {|match| match[:winner] == team}).inject(0) {|extra_runs, match| extra_runs += match[:win_by_runs]}
			end
			return extra_runs_per_team
		rescue StandardError => ex
			puts ex.message
		end
		
	end

	def  top_economical_bowlers_per_season(year)
		begin
			matches = @matches_data.select {|match| match[:season] == year}
			year_deliveries = Array.new
			matches.each do |match|
				year_deliveries += @deliveries_data.select {|delivery| delivery[:match_id] == match[:id]}
			end

			# Bowlers economy rate = runs conceded/overs

			bowlers = (year_deliveries.map {|delivery| delivery[:bowler]}).to_set.to_a
			bowlers_economy = Hash[bowlers.product([0])]
			bowlers.each do |bowler|
				bowler_deliveries = year_deliveries.select {|delivery| delivery[:bowler] == bowler}
				runs = bowler_deliveries.inject(0) {|score, delivery| score += delivery[:total_runs]}
				overs = (bowler_deliveries.size/6.0).round(1)
				bowlers_economy[bowler] = (runs/overs).round(1)
			end
			return bowlers_economy.sort_by {|k, v| v}
		rescue StandardError => ex
			puts ex.message
		end
	end
end

