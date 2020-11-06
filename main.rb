require_relative "./src/ipl_data_analysis.rb"
require 'gruff'

class Visualize
    attr_reader :ipl_data_analyzer
    def initialize(matches_data, deliveries_data)
        @ipl_data_analyzer = IPLDataAnalyzer.new(matches_data, deliveries_data)
    end

    def plot_matches_played_per_year(team)
        begin
            seasonal_data = @ipl_data_analyzer.matches_played_per_year(team)
            g = Gruff::Bar.new
            g.title = "Matches played by #{team} per season"
            g.spacing_factor = 0.1
            g.group_spacing = 20
            seasonal_data.each do |key, value|
                g.data(key, value)
            end
            g.write("matches-played-by-#{team}-per-season.png") 
        rescue StandardError => ex
            puts ex.message
        end
    end

    def plot_matches_won_by_all_teams
        teams_winning_data = @ipl_data_analyzer.matches_won_by_all_teams_over_all_years.to_a
        g = Gruff::StackedBar.new
        g.title = 'Matches won by all the teams per season'
        teams_winning_data.each do |key,value|
            g.data(key, value)
        end
        g.write("matches-won-by-all-teams-in-all-seasons.png")
    end

    def plot_extra_runs_conceded_per_season(year)
        data = @ipl_data_analyzer.extra_run_conceded_per_team_by_season(year)
        g = Gruff::Bar.new
        g.title = "Extra runs conceded by all teams in #{year}"
        data.each do |key, value|
            g.data(key, value)
        end
        g.write("extra-runs-in-#{year}.png")
    end

    def plot_top_economical_bowlers_per_season(year)
        top_bowlers = @ipl_data_analyzer.top_economical_bowlers_per_season(year)
        g = Gruff::Bar.new
        g.title = "Top economical bowlers in #{year}"
        top_bowlers.each do |bowler, economy|
            g.data(bowler, economy)
        end
        g.write('top-economical-bowlers-#{year}.png')
    end
end


matches_data = SmarterCSV.process("./data/matches.csv")
deliveries_data = SmarterCSV.process("./data/deliveries.csv")
sleep(5)
v = Visualize.new(matches_data, deliveries_data)
v.plot_matches_played_per_year("Mumbai Indians")
v.plot_matches_won_by_all_teams()
v.plot_extra_runs_conceded_per_season(2016)
v.plot_top_economical_bowlers_per_season(2015)