require "smarter_csv"

require_relative "src/visualize.rb"

def get_graphs(matches, deliveries)
    v = Visualize.new(matches, deliveries)
    v.plot_matches_played_per_year()
    v.plot_matches_won_by_all_teams()
    v.plot_extra_runs_conceded_per_season(2016)
    v.plot_top_economical_bowlers_per_season(2015)
    v.plot_top_ten_scorers_of_the_season(2017)
end

$matches_data = SmarterCSV.process("./data/matches.csv")
SmarterCSV.process("./data/deliveries.csv").then {|deliveries| get_graphs($matches_data, deliveries)}
# main($matches_data, $deliveries_data)
