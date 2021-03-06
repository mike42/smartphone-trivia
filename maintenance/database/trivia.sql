SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';


-- -----------------------------------------------------
-- Table `trivia`.`game`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `trivia`.`game` (
  `game_id` INT NOT NULL AUTO_INCREMENT,
  `game_name` TEXT NOT NULL,
  `game_state` INT(1) NOT NULL DEFAULT 0,
  `game_code` VARCHAR(6) NOT NULL,
  PRIMARY KEY (`game_id`),
  UNIQUE INDEX `game_code` (`game_code` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `trivia`.`team`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `trivia`.`team` (
  `team_id` INT NOT NULL AUTO_INCREMENT,
  `team_code` VARCHAR(6) NOT NULL,
  `game_id` INT NOT NULL,
  `team_name` TEXT NOT NULL,
  PRIMARY KEY (`team_id`),
  INDEX `game_id` (`game_id` ASC),
  UNIQUE INDEX `team_code` (`team_code` ASC),
  CONSTRAINT `game_id`
    FOREIGN KEY (`game_id`)
    REFERENCES `trivia`.`game` (`game_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `trivia`.`round`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `trivia`.`round` (
  `round_id` INT NOT NULL AUTO_INCREMENT,
  `name` TEXT NOT NULL,
  `game_id` INT NOT NULL,
  `round_sortkey` INT NOT NULL,
  `round_state` INT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`round_id`),
  INDEX `game_id_fk2` (`game_id` ASC),
  UNIQUE INDEX `round_sort` (`game_id` ASC, `round_sortkey` ASC),
  CONSTRAINT `game_id_fk2`
    FOREIGN KEY (`game_id`)
    REFERENCES `trivia`.`game` (`game_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `trivia`.`question`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `trivia`.`question` (
  `question_id` INT NOT NULL AUTO_INCREMENT,
  `round_id` INT NOT NULL,
  `question_text` TEXT NOT NULL,
  `question_sortkey` INT NOT NULL,
  `question_state` INT(1) NOT NULL DEFAULT 0,
  `question_answer` TEXT NOT NULL,
  PRIMARY KEY (`question_id`),
  INDEX `round_id` (`round_id` ASC),
  UNIQUE INDEX `question_sort` (`round_id` ASC, `question_sortkey` ASC),
  CONSTRAINT `fk_question_round1`
    FOREIGN KEY (`round_id`)
    REFERENCES `trivia`.`round` (`round_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `trivia`.`answer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `trivia`.`answer` (
  `question_id` INT NOT NULL,
  `team_id` INT NOT NULL,
  `answer_text` TEXT NOT NULL,
  `answer_is_correct` INT(1) NOT NULL,
  `answer_time` DATETIME NOT NULL,
  PRIMARY KEY (`question_id`, `team_id`),
  INDEX `team_id` (`team_id` ASC),
  INDEX `question_id` (`question_id` ASC),
  CONSTRAINT `question_id`
    FOREIGN KEY (`question_id`)
    REFERENCES `trivia`.`question` (`question_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `team_id`
    FOREIGN KEY (`team_id`)
    REFERENCES `trivia`.`team` (`team_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `trivia`.`person`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `trivia`.`person` (
  `person_id` INT NOT NULL AUTO_INCREMENT,
  `person_name` TEXT NOT NULL,
  `game_id` INT NOT NULL,
  PRIMARY KEY (`person_id`),
  INDEX `game_id` (`game_id` ASC),
  CONSTRAINT `game_id_fk1`
    FOREIGN KEY (`game_id`)
    REFERENCES `trivia`.`game` (`game_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `trivia`.`person_table`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `trivia`.`person_table` (
  `round_id` INT NOT NULL,
  `person_id` INT NOT NULL,
  `team_id` INT NOT NULL,
  PRIMARY KEY (`round_id`, `person_id`),
  INDEX `person_id_fk1` (`person_id` ASC),
  INDEX `team_id_fk1` (`team_id` ASC),
  CONSTRAINT `round_id_fk1`
    FOREIGN KEY (`round_id`)
    REFERENCES `trivia`.`round` (`round_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `person_id_fk1`
    FOREIGN KEY (`person_id`)
    REFERENCES `trivia`.`person` (`person_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `team_id_fk1`
    FOREIGN KEY (`team_id`)
    REFERENCES `trivia`.`team` (`team_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `trivia`.`team_round`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `trivia`.`team_round` (
  `round_round_id` INT NOT NULL,
  `team_team_id` INT NOT NULL,
  `bonus_points` INT NULL,
  PRIMARY KEY (`round_round_id`, `team_team_id`),
  INDEX `fk_team_round_team1_idx` (`team_team_id` ASC),
  CONSTRAINT `fk_team_round_round1`
    FOREIGN KEY (`round_round_id`)
    REFERENCES `trivia`.`round` (`round_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_team_round_team1`
    FOREIGN KEY (`team_team_id`)
    REFERENCES `trivia`.`team` (`team_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
