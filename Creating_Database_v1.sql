SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema Transfermarkt
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `Transfermarkt` ;
USE `Transfermarkt` ;

-- -----------------------------------------------------
-- Table `Transfermarkt`.`leagues`
-- -----------------------------------------------------
CREATE TABLE leagues (
            id VARCHAR(25),
            name VARCHAR(45) NOT NULL,
            confederation VARCHAR(45) NOT NULL
            );


-- -----------------------------------------------------
-- Table `Transfermarkt`.`clubs`
-- -----------------------------------------------------
CREATE TABLE clubs (
			id VARCHAR(40) NOT NULL,
            name VARCHAR(45) NOT NULL,
            pretty_name VARCHAR(45) NOT NULL,
			leagues_id VARCHAR(25) NOT NULL,
            total_market_value FLOAT,
            squad_size INT NOT NULL,
            average_age FLOAT,
            foreigners_number INT,
            national_team_players INT NOT NULL,
            stadium_name VARCHAR(100) NOT NULL,
            stadium_seats INT NOT NULL,
            coach_name VARCHAR(45) NOT NULL,
            url LONGTEXT NOT NULL
            );


-- -----------------------------------------------------
-- Table `Transfermarkt`.`players`
-- -----------------------------------------------------
CREATE TABLE players (
			id VARCHAR(25) NOT NULL,
            last_season CHAR(4) NOT NULL,
            clubs_id VARCHAR(20) NOT NULL,
            name VARCHAR(45) NOT NULL,
            pretty_name VARCHAR(45) NOT NULL,
            country_of_birth VARCHAR(45),
            country_of_citizenship VARCHAR(45),
            date_of_birth DATE NOT NULL,
            position VARCHAR(45) NOT NULL,
            sub_position VARCHAR(45) NOT NULL,
            foot VARCHAR(45) NOT NULL,
            height_in_cm INT NOT NULL,
            market_value_in_gbp DECIMAL,
            highest_market_value_in_gbp DECIMAL,
            url LONGTEXT NOT NULL
            );


-- -----------------------------------------------------
-- Table `Transfermarkt`.`competitions`
-- -----------------------------------------------------
CREATE TABLE competitions (
			id VARCHAR(5),
            name VARCHAR(45) NOT NULL,
            type VARCHAR(45) NOT NULL,
            country_id VARCHAR(45) NOT NULL,
            country_name VARCHAR(45),
            leagues_id VARCHAR(15),
            confederation VARCHAR(45) NOT NULL,
            url LONGTEXT NOT NULL
            );


-- -----------------------------------------------------
-- Table `Transfermarkt`.`games`
-- -----------------------------------------------------
CREATE TABLE games (
			id VARCHAR(45) NOT NULL,
            competitions_id VARCHAR(5) NOT NULL,
            season CHAR(4) NOT NULL,
            round VARCHAR(45) NOT NULL,
            date DATE NOT NULL,
            home_club_id VARCHAR(20) NOT NULL,
            away_club_id VARCHAR(20) NOT NULL,
            home_club_goals INT NOT NULL,
            away_club_goals INT NOT NULL,
            home_club_position INT,
            away_club_position INT,
            stadium LONGTEXT NOT NULL,
            attendance INT,
            referee VARCHAR(45),
            url LONGTEXT NOT NULL
            );


-- -----------------------------------------------------
-- Table `Transfermarkt`.`Appearances`
-- -----------------------------------------------------
CREATE TABLE appearances (
			players_id VARCHAR(25) NOT NULL,
            games_id VARCHAR(25) NOT NULL,
            id VARCHAR(45) NOT NULL,
            competitions_id VARCHAR(5) NOT NULL,
            clubs_id VARCHAR(20) NOT NULL,
            goals INT NOT NULL,
            assists INT NOT NULL,
            minutes_played INT NOT NULL,
            yellow_cards INT NOT NULL,
            red_cards INT NOT NULL
            );


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
