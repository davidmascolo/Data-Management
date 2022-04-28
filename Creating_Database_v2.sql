## Homework 02
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema Transfermarkt
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema Transfermarkt
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `Transfermarkt` ;
USE `Transfermarkt` ;

-- -----------------------------------------------------
-- Table `Transfermarkt`.`leagues`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Transfermarkt`.`leagues` (
  `id` VARCHAR(25) NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `confederation` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Transfermarkt`.`clubs`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Transfermarkt`.`clubs` (
  `id` VARCHAR(20) NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `pretty_name` VARCHAR(45) NOT NULL,
  `total_market_value` DOUBLE NULL,
  `squad_size` INT NOT NULL,
  `average_age` DOUBLE NULL,
  `foreigners_number` INT NULL,
  `national_team_players` INT NOT NULL,
  `stadium_name` VARCHAR(100) NOT NULL,
  `stadium_seats` INT NOT NULL,
  `coach_name` VARCHAR(45) NOT NULL,
  `url` LONGTEXT NOT NULL,
  `leagues_id` VARCHAR(25) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_clubs_leagues1_idx` (`leagues_id` ASC) VISIBLE,
  CONSTRAINT `fk_clubs_leagues1`
    FOREIGN KEY (`leagues_id`)
    REFERENCES `Transfermarkt`.`leagues` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Transfermarkt`.`players`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Transfermarkt`.`players` (
  `id` VARCHAR(25) NOT NULL,
  `last_season` CHAR(4) NULL,
  `name` VARCHAR(45) NULL,
  `pretty_name` VARCHAR(45) NULL,
  `country_of_birth` VARCHAR(45) NULL,
  `country_of_citizenship` VARCHAR(45) NULL,
  `date_of_birth` DATE NULL,
  `position` VARCHAR(45) NULL,
  `sub_position` VARCHAR(45) NULL,
  `foot` VARCHAR(45) NULL,
  `height_in_cm` INT NULL,
  `market_value_in_gbp` DECIMAL NULL,
  `highest_market_value_in_gbp` DECIMAL NULL,
  `url` LONGTEXT NULL,
  `clubs_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_players_clubs1_idx` (`clubs_id` ASC) VISIBLE,
  CONSTRAINT `fk_players_clubs1`
    FOREIGN KEY (`clubs_id`)
    REFERENCES `Transfermarkt`.`clubs` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Transfermarkt`.`competitions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Transfermarkt`.`competitions` (
  `id` VARCHAR(5) NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `type` VARCHAR(45) NOT NULL,
  `country_id` VARCHAR(5) NOT NULL,
  `country_name` VARCHAR(45) NULL,
  `confederation` VARCHAR(45) NOT NULL,
  `url` LONGTEXT NOT NULL,
  `leagues_id` CHAR(5) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Transfermarkt`.`games`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Transfermarkt`.`games` (
  `id` VARCHAR(25) NOT NULL,
  `season` CHAR(4) NULL,
  `round` VARCHAR(45) NULL,
  `date` DATE NULL,
  `home_club_goals` INT NULL,
  `away_club_goals` INT NULL,
  `home_club_position` INT NULL,
  `away_club_position` INT NULL,
  `stadium` LONGTEXT NULL,
  `attendance` INT NULL,
  `referee` VARCHAR(45) NULL,
  `url` LONGTEXT NULL,
  `competitions_id` VARCHAR(5) NOT NULL,
  `home_club_id` VARCHAR(20) NOT NULL,
  `away_club_id` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_games_competitions1_idx` (`competitions_id` ASC) VISIBLE,
  INDEX `fk_games_clubs1_idx` (`home_club_id` ASC) VISIBLE,
  INDEX `fk_games_clubs2_idx` (`away_club_id` ASC) VISIBLE,
  CONSTRAINT `fk_games_competitions1`
    FOREIGN KEY (`competitions_id`)
    REFERENCES `Transfermarkt`.`competitions` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_games_clubs1`
    FOREIGN KEY (`home_club_id`)
    REFERENCES `Transfermarkt`.`clubs` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_games_clubs2`
    FOREIGN KEY (`away_club_id`)
    REFERENCES `Transfermarkt`.`clubs` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Transfermarkt`.`Appearances`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Transfermarkt`.`Appearances` (
  `id` VARCHAR(45) NOT NULL,
  `goals` INT NULL,
  `assists` INT NULL,
  `minutes_played` INT NULL,
  `yellow_cards` INT NULL,
  `red_cards` INT NULL,
  `players_id` VARCHAR(25) NOT NULL,
  `clubs_id` VARCHAR(20) NOT NULL,
  `competitions_id` VARCHAR(5) NOT NULL,
  `games_id` VARCHAR(25) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_Appearances_players1_idx` (`players_id` ASC) VISIBLE,
  INDEX `fk_Appearances_clubs1_idx` (`clubs_id` ASC) VISIBLE,
  INDEX `fk_Appearances_competitions1_idx` (`competitions_id` ASC) VISIBLE,
  INDEX `fk_Appearances_games1_idx` (`games_id` ASC) VISIBLE,
  CONSTRAINT `fk_Appearances_players1`
    FOREIGN KEY (`players_id`)
    REFERENCES `Transfermarkt`.`players` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Appearances_clubs1`
    FOREIGN KEY (`clubs_id`)
    REFERENCES `Transfermarkt`.`clubs` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Appearances_competitions1`
    FOREIGN KEY (`competitions_id`)
    REFERENCES `Transfermarkt`.`competitions` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Appearances_games1`
    FOREIGN KEY (`games_id`)
    REFERENCES `Transfermarkt`.`games` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
