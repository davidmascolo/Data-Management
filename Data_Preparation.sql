## *************
## Data Import
## *************
## Set the database
USE transfermarkt;

## Load table LEAGUES
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/leagues.csv'
INTO TABLE leagues
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

## Load table COMPETITIONS            
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/competitions.csv'
INTO TABLE competitions
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

## Load table CLUBS            
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/clubs.csv'
INTO TABLE clubs
FIELDS TERMINATED BY ';'
IGNORE 1 ROWS;

## Load table PLAYERS            
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/players.csv'
INTO TABLE players
FIELDS TERMINATED BY ';'
IGNORE 1 ROWS;

## Because we have some games between clubs that there are not in the CLUBS table
SET FOREIGN_KEY_CHECKS=0;

## Load table GAMES
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/games.csv'
INTO TABLE games
FIELDS TERMINATED BY ';'
IGNORE 1 ROWS;

## Load table APPEARANCES
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/appearances.csv'
INTO TABLE appearances
FIELDS TERMINATED BY ';'
IGNORE 1 ROWS;

# Set again the foreign keys check
SET GLOBAL FOREIGN_KEY_CHECKS=1;


## *************
## Data Cleaning
## *************

## Games Table
## Drop column url
ALTER TABLE games 
DROP url;

## Clubs Table
## Drop column url
ALTER TABLE clubs
DROP url;
## Drop column name
ALTER TABLE clubs
DROP name;
## Rename column pretty_name
ALTER TABLE clubs
RENAME COLUMN pretty_name TO Name;

## Players Table
## Drop column url
ALTER TABLE players
DROP url;
## Drop column name
ALTER TABLE players
DROP name;
## Rename column pretty_name
ALTER TABLE players
RENAME COLUMN pretty_name TO Name;

## Competitions Table
## Drop column url
ALTER TABLE competitions
DROP url;