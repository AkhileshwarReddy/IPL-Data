
-- TODO: Create matches table

CREATE TABLE matches (
    id INTEGER PRIMARY KEY,
    season INTEGER NOT NULL,
    city VARCHAR,
    date DATE NOT NULL,
    team1 VARCHAR NOT NULL,
    team2 VARCHAR NOT NULL,
    toss_winner VARCHAR NOT NULL,
    toss_decision VARCHAR NOT NULL,
    result VARCHAR NOT NULL,
    dl_applied INTEGER DEFAULT 0,
    winner VARCHAR,
    win_by_runs INTEGER DEFAULT 0,
    win_by_wickets INTEGER DEFAULT 0,
    player_of_match VARCHAR,
    venue VARCHAR NOT NULL,
    umpire1 VARCHAR,
    umpire2 VARCHAR,
    umpire3 VARCHAR
);

-- TODO: Import matches data from matches.csv

COPY matches FROM '/home/akhil/.mb-bootcamp/ruby/projects/Data-Project/data/matches.csv' 
DELIMITER ',' CSV HEADER;

-- FIXME: Fix Rising Pune Supergiants team name

UPDATE matches SET 
    team2='Rising Pune Supergiants'
    WHERE team2 like 'Rising%';

UPDATE matches SET 
    team2='Rising Pune Supergiants'
    WHERE team2 like 'Rising%';
