require_relative("../src/ipl_data_analysis.rb")
require 'test/unit'

class TestIPLDataAnalyzer < Test::Unit::Testcase

    def initialize
        @ipl_data_analyzer = IPLDataAnalyzer.new("../data/test/matches.csv", "../data/test/deliveries.csv")
    end

    def test_matches_played_per_year

    end

    def test_matches_won_by_all_teams_over_all_years

    end

    def extra_run_conceded_per_team_by_year

    end

    def top_economical_bowlers_per_year

    end
end
