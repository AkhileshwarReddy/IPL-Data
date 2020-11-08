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
		@seasons = (@matches_data.map { |match| match[:season] }).uniq.sort
		@teams = (@matches_data.map {|match| match[:team1]}).uniq
	end

	def matches_played_per_year
		begin
			year_wise_matches = Hash[@seasons.product([0])]
			@matches_data.each do |match|
				year_wise_matches[match[:season]] += 1
			end
			return year_wise_matches
		rescue StandardError => ex
			puts matches_played_per_year, ex.message			
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
			puts matches_won_by_all_teams_over_all_years, ex.message
		end
	end

	def extra_run_conceded_per_team_by_season(year)
		begin
			extra_runs_per_team = Hash[@teams.product([0])]
			year_matches = (@matches_data.select {|match| match[:season] == year}).map {|match| match[:id]}
			s_idx = @deliveries_data.index{|d| d[:match_id] == year_matches[0]}
			l_idx = @deliveries_data.rindex{|d| d[:match_id] == year_matches[-1]}
			@teams.each do |team|
				extra_runs_per_team[team] = @deliveries_data[s_idx..l_idx].select {|delivery| delivery[:batting_team] == team}.inject(0) {|extra_runs, delivery| extra_runs += delivery[:extra_runs]}
			end
			return extra_runs_per_team
		rescue StandardError => ex
			puts "extra_run_conceded_per_team_by_season", ex.message
		end
		
	end

	def  top_economical_bowlers_per_season(year)
		begin
			year_deliveries = get_deliveries_of_the_season(year)

			# Bowlers economy rate = runs conceded/overs

			bowlers = (year_deliveries.map {|delivery| delivery[:bowler]}).uniq
			bowlers_economy = Hash[bowlers.product([0])]
			bowlers.each do |bowler|
				bowler_deliveries = year_deliveries.select {|delivery| delivery[:bowler] == bowler and delivery[:is_super_over] == 0 and delivery[:bye_runs] == 0 and delivery[:legbye_runs] == 0}
				if bowler_deliveries.size == 0
					bowlers_economy[bowler] = 0.0
					next
				end
				runs = bowler_deliveries.inject(0) {|score, delivery| score += delivery[:total_runs]}
				overs = (bowler_deliveries.size/6.0).round(2)
				bowlers_economy[bowler] = (runs/overs).round(2)
			end
			return bowlers_economy.sort_by {|k, v| v}.to_a[0..9]
		rescue StandardError => ex
			puts top_economical_bowlers_per_season, ex.message
		end
	end

	def top_ten_scorers_of_the_season(year)
		begin
			year_deliveries = get_deliveries_of_the_season(year)
			batsmen = year_deliveries.map {|delivery| delivery[:batsman]}.uniq
			bs = Hash[batsmen.product([0])]
			batsmen.each do |batsman|
				bs[batsman] = year_deliveries.select {|d| d[:batsman] == batsman}.inject(0) {|s, d| s += d[:total_runs] - d[:extra_runs]}
			end
			return bs.sort_by {|k, v| -v}.to_a[0..9].to_h
		rescue StandardError => ex
			puts top_ten_scorers_of_the_season, ex.message
		end
	end

	def get_deliveries_of_the_season(year)
		matches = @matches_data.select {|match| match[:season] == year}.map {|match| match[:id]}
		s_idx = @deliveries_data.index {|delivery| delivery[:match_id] == matches[0]}
		l_idx = @deliveries_data.rindex {|delivery| delivery[:match_id] == matches[-1]}
		return @deliveries_data[s_idx..l_idx]
	end
end

