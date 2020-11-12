-- match_id,inning,batting_team,bowling_team,over,ball,batsman,non_striker,bowler,is_super_over,wide_runs,bye_runs,legbye_runs,noball_runs,penalty_runs,batsman_runs,extra_runs,total_runs,player_dismissed,dismissal_kind,fielder

-- TODO: Create deliveries table

CREATE TABLE deliveries (
    match_id INTEGER,
    inning INTEGER NOT NULL,
    batting_team VARCHAR NOT NULL,
    bowling_team VARCHAR NOT NULL,
    "over" INTEGER NOT NULL,
    ball INTEGER NOT NULL,
    batsman VARCHAR NOT NULL,
    non_striker VARCHAR NOT NULL,
    bowler VARCHAR NOT NULL,
    is_super_over BOOLEAN,
    wide_runs INTEGER DEFAULT 0,
    bye_runs INTEGER DEFAULT 0,
    legbye_runs INTEGER DEFAULT 0,
    noball_runs INTEGER DEFAULT 0,
    penaulty_runs INTEGER DEFAULT 0,
    batsman_runs INTEGER DEFAULT 0,
    extra_runs INTEGER DEFAULT 0,
    total_runs INTEGER DEFAULT 0,
    player_dismissed VARCHAR,
    dismissal_kind VARCHAR,
    fielder VARCHAR,
    CONSTRAINT fk_match_id
        FOREIGN KEY (match_id)
            REFERENCES  matches(id)
);

-- TODO: Import deliveries data from deliveries.csv

COPY deliveries FROM '/home/akhil/.mb-bootcamp/ruby/projects/Data-Project/data/deliveries.csv'
DELIMITER ',' CSV HEADER;

-- select distinct bowling_team, count(*) from deliveries where bowling_team like 'Rising%' group by bowling_team;
-- select distinct batting_team, count(*) from deliveries where batting_team like 'Rising%' group by batting_team;

-- FIXME: Fix Rising Pune Supergiants team name

UPDATE deliveries SET
    batting_team='Rising Pune Supergiants'
    WHERE batting_team like 'Rising%';

UPDATE deliveries SET
    bowling_team='Rising Pune Supergiants'
    WHERE bowling_team like 'Rising%';
