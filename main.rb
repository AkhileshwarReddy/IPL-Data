require "smarter_csv"

require_relative "src/visualize.rb"

matches_data = SmarterCSV.process("./data/matches.csv")
deliveries_data = SmarterCSV.process("./data/deliveries.csv")
v = Visualize.new(matches_data, deliveries_data)
v.plot_matches_played_per_year
v.plot_matches_won_by_all_teams
v.plot_extra_runs_conceded_per_season(2016)
v.plot_top_economical_bowlers_per_season(2015)
v.plot_top_ten_scorers_of_the_season(2017)
