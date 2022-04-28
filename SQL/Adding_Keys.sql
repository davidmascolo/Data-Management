-- -----------------------------------
-- Set keys and constraints on tables
-- -----------------------------------

# Table leagues
ALTER TABLE leagues
ADD PRIMARY KEY (id);

# Table competitions
ALTER TABLE competitions
ADD PRIMARY KEY (id);

# Table clubs
ALTER TABLE clubs
ADD PRIMARY KEY (id),
ADD FOREIGN KEY (leagues_id) REFERENCES leagues(id);

# Table players
ALTER TABLE players
ADD PRIMARY KEY (id),
ADD FOREIGN KEY (clubs_id) REFERENCES clubs(id);

# Table games
ALTER TABLE games
ADD PRIMARY KEY (id),
ADD FOREIGN KEY (competitions_id) REFERENCES competitions(id),
ADD FOREIGN KEY (home_club_id) REFERENCES clubs(id),
ADD FOREIGN KEY (away_club_id) REFERENCES clubs(id);

# Table appearances
ALTER TABLE appearances
ADD PRIMARY KEY (id),
ADD FOREIGN KEY (players_id) REFERENCES players(id),
ADD FOREIGN KEY (games_id) REFERENCES games(id),
ADD FOREIGN KEY (competitions_id) REFERENCES competitions(id),
ADD FOREIGN KEY (clubs_id) REFERENCES clubs(id);

-- ----------------------------------------------------------
-- FAST VERSIONS
-- ----------------------------------------------------------
