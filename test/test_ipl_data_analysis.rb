require "smarter_csv"
require "minitest/autorun"

require_relative "../src/ipl_data_analysis.rb"

class TestIPLDataAnalyzer < Minitest::Test
	def setup
		$matches = SmarterCSV.process("data/test/matches.csv")
		SmarterCSV.process("data/test/deliveries.csv").then {|d| $deliveries = d}
	end

	def test_matches_played_per_year
		ipl = IPLDataAnalyzer.new($matches, $deliveries)
		expected = {2014=>5, 2015=>5, 2016=>5, 2017=>5}
		assert_equal expected, ipl.matches_played_per_year
	end

	def test_matches_won_by_all_teams_over_all_years
		ipl = IPLDataAnalyzer.new($matches, $deliveries)
		expected = {"Sunrisers Hyderabad"=>[0, 0, 0, 1], "Mumbai Indians"=>[0, 0, 1, 0], "Gujarat Lions"=>[0, 0, 1, 0], "Rising Pune Supergiant"=>[0, 0, 0, 1], "Royal Challengers Bangalore"=>[2, 1, 1, 1], "Delhi Daredevils"=>[0, 0, 0, 0], "Kings XI Punjab"=>[1, 0, 0, 1], "Kolkata Knight Riders"=>[1, 1, 1, 1], "Chennai Super Kings"=>[0, 2, 0, 0], "Rajasthan Royals"=>[1, 1, 0, 0]}
		assert_equal expected, ipl.matches_won_by_all_teams_over_all_years
	end

	def test_extra_run_conceded_per_team_by_year
		ipl = IPLDataAnalyzer.new($matches, $deliveries)
		expected = {
			"Sunrisers Hyderabad"=>4, 
			"Mumbai Indians"=>1, 
			"Gujarat Lions"=>1, 
			"Rising Pune Supergiant"=>2, 
			"Royal Challengers Bangalore"=>5, 
			"Delhi Daredevils"=>1, 
			"Kings XI Punjab"=>2, 
			"Kolkata Knight Riders"=>2, 
			"Chennai Super Kings"=>0, 
			"Rajasthan Royals"=>0
		}

		assert_equal expected, ipl.extra_run_conceded_per_team_by_season(2017)
	end

	def test_top_economical_bowlers_per_year
		ipl = IPLDataAnalyzer.new($matches, $deliveries)
		expected = {"S Nadeem"=>1.71, "YS Chahal"=>4.0, "MJ McClenaghan"=>4.0, "JJ Bumrah"=>4.0, "BCJ Cutting"=>4.27, "TS Mills"=>5.67, "Sandeep Sharma"=>5.67, "PJ Cummins"=>5.98, "CH Morris"=>6.56, "PP Chawla"=>6.91, "Imran Tahir"=>7.0, "P Kumar"=>7.0, "B Kumar"=>7.37, "MM Sharma"=>7.5, "B Stanlake"=>7.83, "DL Chahar"=>8.0, "TA Boult"=>8.0, "AB Dinda"=>8.15, "SP Narine"=>8.5, "S Aravind"=>9.0, "S Kaushik"=>9.0, "TG Southee"=>9.22, "DS Kulkarni"=>10.0, "Z Khan"=>10.0, "DT Christian"=>10.3, "Iqbal Abdulla"=>11.0, "BA Stokes"=>11.5, "MS Gony"=>12.78, "A Nehra"=>13.5, "A Choudhary"=>13.68, "HH Pandya"=>16.87}.to_a[0..9].to_h
		assert_equal expected, ipl.top_economical_bowlers_per_season(2017).to_h
	end

	def test_top_ten_scorers_of_the_season
		ipl = IPLDataAnalyzer.new($matches, $deliveries)
		expected = {"DA Warner"=>14, "S Dhawan"=>7, "MC Henriques"=>17, "CH Gayle"=>32, "Mandeep Singh"=>24, "PA Patel"=>19, "JC Buttler"=>26, "RG Sharma"=>2, "AM Rahane"=>48, "MA Agarwal"=>6, "SPD Smith"=>19, "JJ Roy"=>14, "BB McCullum"=>23, "SK Raina"=>2, "G Gambhir"=>24, "CA Lynn"=>27, "HM Amla"=>18, "M Vohra"=>14, "WP Saha"=>14, "SR Watson"=>19, "AP Tare"=>18, "SW Billings"=>14, "KK Nair"=>4}.sort_by {|k, v| -v}.to_a[0..9].to_h
		assert_equal expected, ipl.top_ten_scorers_of_the_season(2017)
	end
end
