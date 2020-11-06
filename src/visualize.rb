require 'gruff'
require_relative "./ipl_data_analysis.rb"

class Visualize
    attr_reader :ipl_data_analyzer
    def initialize(matches_data, deliveries_data)
        @ipl_data_analyzer = IPLDataAnalyzer.new(matches_data, deliveries_data)
    end

    def plot_matches_played_per_year(team)
        begin
            seasonal_data = @ipl_data_analyzer.matches_played_per_year(team)
            g = Gruff::SideBar.new
            g.group_spacing = 20
            g.title = "Matches played by #{team} per season"
            g.show_labels_for_bar_values = true
            seasonal_data.each do |key, value|
                g.data(key, value)
            end
            g.write("img/matches-played-by-#{team.downcase.gsub(' ', '-')}-per-season.png") 
        rescue StandardError => ex
            puts ex.message
        end
    end

    def plot_matches_won_by_all_teams
        begin
            teams_winning_data = @ipl_data_analyzer.matches_won_by_all_teams_over_all_years
            g = Gruff::StackedBar.new
            g.title = 'Matches won by all the teams per season'
            g.show_labels_for_bar_values = true
            teams_winning_data.each do |team,value|
                k = team.split(' ').inject("") {|a,b| a << b[0]}
                g.data(k, value)
            end
            g.write("img/matches-won-by-all-teams-in-all-seasons.png")
        rescue StandardError => ex
            puts ex.message
        end
    end

    def plot_extra_runs_conceded_per_season(year)
        begin
            data = @ipl_data_analyzer.extra_run_conceded_per_team_by_season(year).to_a
            g = Gruff::Bar.new
            g.title = "Extra runs conceded by all teams in #{year}"
            g.show_labels_for_bar_values = true
            data.each do |d|
                g.data(d[0].split(' ').inject("") {|a, b| a << b[0]}, d[1])
            end
            g.write("img/extra-runs-in-#{year}.png")
        rescue StandardError => ex
            puts ex.message
        end
    end

    def plot_top_economical_bowlers_per_season(year)
        begin
            top_bowlers = (@ipl_data_analyzer.top_economical_bowlers_per_season(year).to_a)[0..10]
            g = Gruff::Bar.new
            g.title = "Top economical bowlers in #{year}"
            g.show_labels_for_bar_values = true
            top_bowlers.each do |bowler, economy|
                g.data(bowler, economy)
            end
            g.write("img/top-economical-bowlers-#{year}.png")
        rescue => exception
            puts ex.message
        end
    end
end