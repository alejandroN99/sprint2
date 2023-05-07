-- MySQL Script generated by MySQL Workbench
-- Thu Apr 27 12:47:44 2023
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema spotify
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema spotify
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `spotify` DEFAULT CHARACTER SET utf8 ;
USE `spotify` ;

-- -----------------------------------------------------
-- Table `spotify`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`user` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `birthday` DATE NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `password` VARCHAR(45) NOT NULL,
  `sex` ENUM('M', 'F') NOT NULL,
  `country` VARCHAR(45) NOT NULL,
  `postal_code` INT NOT NULL,
  `type_user` ENUM('free', 'premium') NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`payment_details`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`payment_details` (
  `id` INT NOT NULL,
  `num_card` INT NOT NULL,
  `month_year_expiration` DATETIME NOT NULL,
  `name_paypal` VARCHAR(45) NOT NULL,
  `user_details` INT NOT NULL,
  PRIMARY KEY (`id`, `user_details`),
  INDEX `user_details_idx` (`user_details` ASC) VISIBLE,
  CONSTRAINT `user_details`
    FOREIGN KEY (`user_details`)
    REFERENCES `spotify`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`subscription`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`subscription` (
  `id` INT NOT NULL,
  `start_date` DATE NOT NULL,
  `date_renovation` DATE NOT NULL,
  `way_to_pay` ENUM('credito', 'paypal') NOT NULL,
  `user_sub_id` INT NOT NULL,
  `detail_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `user_sub_id_idx` (`user_sub_id` ASC) VISIBLE,
  INDEX `detail_id_idx` (`detail_id` ASC) VISIBLE,
  CONSTRAINT `user_sub_id`
    FOREIGN KEY (`user_sub_id`)
    REFERENCES `spotify`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `detail_id`
    FOREIGN KEY (`detail_id`)
    REFERENCES `spotify`.`payment_details` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`payment_records`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`payment_records` (
  `order_id` INT NOT NULL,
  `date` DATE NOT NULL,
  `total_price` INT NOT NULL,
  PRIMARY KEY (`order_id`),
  CONSTRAINT `order_id`
    FOREIGN KEY (`order_id`)
    REFERENCES `spotify`.`subscription` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`playlist`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`playlist` (
  `id` INT NOT NULL,
  `title` VARCHAR(45) NOT NULL,
  `num_songs` INT NOT NULL,
  `start_date` DATE NOT NULL,
  `status` ENUM('active', 'delete') NOT NULL,
  `date_delete` DATE NOT NULL,
  `user_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `user_id_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `spotify`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`artist`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`artist` (
  `id` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `image` BLOB NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`album`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`album` (
  `id` INT NOT NULL,
  `title` VARCHAR(45) NOT NULL,
  `year_publication` DATE NOT NULL,
  `image` BLOB NULL,
  `artist_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `artist_id_idx` (`artist_id` ASC) VISIBLE,
  CONSTRAINT `artist_id`
    FOREIGN KEY (`artist_id`)
    REFERENCES `spotify`.`artist` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`song`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`song` (
  `id` INT NOT NULL,
  `title` VARCHAR(45) NOT NULL,
  `duration` FLOAT NOT NULL,
  `num_reproductions` INT NOT NULL,
  `album_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `album_id_idx` (`album_id` ASC) VISIBLE,
  CONSTRAINT `album_id`
    FOREIGN KEY (`album_id`)
    REFERENCES `spotify`.`album` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`shared_list`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`shared_list` (
  `id` INT NOT NULL,
  `data_share` DATE NOT NULL,
  `user_id` INT NOT NULL,
  `playlist_id` INT NOT NULL,
  `song_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `user_id_idx` (`user_id` ASC) VISIBLE,
  INDEX `playlist_id_idx` (`playlist_id` ASC) VISIBLE,
  INDEX `song_id_idx` (`song_id` ASC) VISIBLE,
  CONSTRAINT `user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `spotify`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `playlist_id`
    FOREIGN KEY (`playlist_id`)
    REFERENCES `spotify`.`playlist` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `song_id`
    FOREIGN KEY (`song_id`)
    REFERENCES `spotify`.`song` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`user_follow_artist`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`user_follow_artist` (
  `user_id` INT NOT NULL,
  `artist_id` INT NOT NULL,
  PRIMARY KEY (`user_id`, `artist_id`),
  INDEX `artist_id_idx` (`artist_id` ASC) VISIBLE,
  CONSTRAINT `user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `spotify`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `artist_id`
    FOREIGN KEY (`artist_id`)
    REFERENCES `spotify`.`artist` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`user_favorite_album`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`user_favorite_album` (
  `user_id` INT NOT NULL,
  `album_id` INT NOT NULL,
  PRIMARY KEY (`user_id`, `album_id`),
  INDEX `album_id_idx` (`album_id` ASC) VISIBLE,
  CONSTRAINT `user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `spotify`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `album_id`
    FOREIGN KEY (`album_id`)
    REFERENCES `spotify`.`album` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`user_favorite_songs`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`user_favorite_songs` (
  `user_id` INT NOT NULL,
  `song_id` INT NOT NULL,
  PRIMARY KEY (`user_id`, `song_id`),
  INDEX `song_id_idx` (`song_id` ASC) VISIBLE,
  CONSTRAINT `user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `spotify`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `song_id`
    FOREIGN KEY (`song_id`)
    REFERENCES `spotify`.`song` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`artist_relationchip`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`artist_relationchip` (
  `id` INT NOT NULL,
  `type_music` VARCHAR(45) NOT NULL,
  `artist_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `artist_id_idx` (`artist_id` ASC) VISIBLE,
  CONSTRAINT `artist_id`
    FOREIGN KEY (`artist_id`)
    REFERENCES `spotify`.`artist` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;