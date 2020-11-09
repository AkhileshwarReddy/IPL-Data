require 'gruff'
require_relative "./ipl_data_analysis.rb"

class Visualize
    attr_reader :ipl_data_analyzer
    def initialize(matches_data, deliveries_data)
        @ipl_data_analyzer = IPLDataAnalyzer.new(matches_data, deliveries_data)
    end

    def plot_matches_played_per_year
        begin
            seasonal_data = @ipl_data_analyzer.matches_played_per_year
            g = get_basic_graph(Gruff::Bar)
            g.title = "Matches played by season"
            labels = {}
            values = []
            g.hide_legend = true
            seasonal_data.to_a.each_with_index do |season, index|
                labels[index] = season[0]
                values << season[1] 
            end
            g.data("", values)
            g.labels = labels
            g.write("img/matches-played-per-season.png") 
        rescue StandardError => ex
            puts plot_matches_played_per_year, ex.message
        end
    end

    def plot_matches_won_by_all_teams
        begin
            teams_winning_data = @ipl_data_analyzer.matches_won_by_all_teams_over_all_years
            g = get_basic_graph(Gruff::StackedBar)
            g.title = 'Matches won by all the teams per season'
            teams_winning_data.each do |team,value|
                k = team.split(' ').inject("") {|a,b| a << b[0]}
                g.data(k, value)
            end
            labels = {}
            @ipl_data_analyzer.seasons.each_with_index do |season, index|
                labels[index] = season
            end
            g.labels = labels
            g.write("img/matches-won-by-all-teams-in-all-seasons.png")
        rescue StandardError => ex
            puts plot_matches_won_by_all_teams, ex.message
        end
    end

    def plot_extra_runs_conceded_per_season(year)
        begin
            data = @ipl_data_analyzer.extra_run_conceded_per_team_by_season(year).to_a
            g = get_basic_graph(Gruff::Bar)
            g.title = "Extra runs conceded by all teams in #{year}"
            g.hide_legend = true
            labels = {}
            values = []
            data.each_with_index do |d, index|
                labels[index] = d[0].split(' ').inject("") {|a, b| a << b[0]}
                values << d[1]
            end
            g.data("", values)
            g.labels = labels
            g.write("img/extra-runs-in-#{year}.png")
        rescue StandardError => ex
            puts plot_extra_runs_conceded_per_season, ex.message
        end
    end

    def plot_top_economical_bowlers_per_season(year)
        begin
            top_bowlers = (@ipl_data_analyzer.top_economical_bowlers_per_season(year).to_a)[0..9]
            g = get_basic_graph(Gruff::SideBar)
            g.title = "Top economical bowlers in #{year}"
            g.hide_legend = true
            labels = {}
            values = []
            top_bowlers.each_with_index do |top_bowler, index|
                labels[index] = top_bowler[0]
                values << top_bowler[1]
            end
            g.labels = labels
            g.data("Economic bolwer", values)
            g.write("img/top-economical-bowlers-#{year}.png")
        rescue StandardError => ex
            puts plot_top_economical_bowlers_per_season, ex.message
        end
    end

    def plot_top_ten_scorers_of_the_season(year)
        begin
            top_scorers = @ipl_data_analyzer.top_ten_scorers_of_the_season(year).to_a
            g = get_basic_graph(Gruff::SideBar)
            g.title = "Top 10 scorers of #{year}"
            g.maximum_value = 1000
            g.hide_legend = true
            labels = {}
            top_scorers.each_with_index do |top_score, index|
                labels[index] = top_score[0]
            end
            g.data("top 10", top_scorers.map {|top_scorer| top_scorer[1]}.to_a)
            g.labels= labels
            g.write("img/top-ten-scorers-#{year}.png")
        rescue StandardError=> ex
            puts plot_top_ten_scorers_of_the_season, ex.message
        end
    end

    def get_basic_graph(type)
        begin
            g = type.new
            g.show_labels_for_bar_values = true
            g.minimum_value = 0
            g.title_font_size = 14
            g.legend_font_size = 12
            # g.hide_line_markers = true
            g.marker_font_size = 10
            # g.hide_legend = true
            return g
        rescue StandardError => ex
            puts ex.message
        end
    end
end