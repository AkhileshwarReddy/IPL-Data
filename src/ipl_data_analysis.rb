require 'smarter_csv'

class IPLDataAnalyzer
	attr_reader :matches_file, :deliveries_file, :matches_data, :deliveries_data, :seasons, :teams

	def initialize(matches_file , deliveries_file)
		begin
			@matches_data = SmarterCSV.process(matches_file)
			@deliveries_data = SmarterCSV.process(deliveries_file)
			@seasons = (@matches_data.map { |match| match[:season] }).to_set.sort
			@teams = (@matches_data.map {|match| match[:team1]}).to_set.to_a
		rescue StandardError => ex
			puts ex.message
		end
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
			total_matches_hash = Hash[@teams.product([0])]
			teams.each do |team|
				total_matches_hash[team] = (@matches_data.select {|match| match[:winner] == team}).size
			end
			return total_matches_hash
		rescue StandardError => ex
			puts ex.message
		end
	end

	def extra_run_conceded_per_team_by_year(year)
		begin
			extra_runs_per_team = Hash[@teams.product([0])]
			year_matches = @matches_data.select {|match| match[:season] == year}
			@teams.each do |team|
				extra_runs_per_team[team] = year_matches.inject(0) {|extra_runs, match| extra_runs += match[:win_by_runs]}
			end
			return extra_runs_per_team
		rescue StandardError => ex
			puts ex.message
		end
		
	end

	def  top_economical_bowlers_per_year(year)
		begin
			match_ids = @matches_data.select {|match| match[:season] == year}
			year_deliveries = Array.new
			match_ids.each do |match_id|
				year_deliveries += @deliveries_data.select {|delivery| delivery[:match_id] == match_id}
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
			return bowlers_economy
		rescue StandardError => ex
			puts ex.message
		end
	end
end

