-- MySQL Script generated by MySQL Workbench
-- Sun May 24 08:59:05 2015
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema widgets
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema widgets
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `widgets` COLLATE utf8mb4_bin ;
USE `widgets` ;

-- -----------------------------------------------------
-- Table `widgets`.`changelog`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `widgets`.`changelog` (
  `change_number` BIGINT(20) NOT NULL,
  `delta_set` VARCHAR(10) NOT NULL,
  `start_dt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `complete_dt` TIMESTAMP NULL DEFAULT NULL,
  `applied_by` VARCHAR(100) NOT NULL,
  `description` VARCHAR(500) NOT NULL,
  PRIMARY KEY (`change_number`, `delta_set`))
ENGINE = InnoDB
COLLATE = utf8mb4_bin;


-- -----------------------------------------------------
-- Table `widgets`.`companies`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `widgets`.`companies` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `website` VARCHAR(155) NULL DEFAULT NULL,
  `address` VARCHAR(155) NULL DEFAULT NULL,
  `city` VARCHAR(155) NULL DEFAULT NULL,
  `state` VARCHAR(155) NULL DEFAULT NULL,
  `phone` VARCHAR(20) NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
COLLATE = utf8mb4_bin;


-- -----------------------------------------------------
-- Table `widgets`.`employees`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `widgets`.`employees` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `phone` VARCHAR(45) NOT NULL,
  `company_id` INT NULL DEFAULT NULL,
  `is_admin` BINARY NULL DEFAULT 0,
  `is_locked` BINARY NULL DEFAULT 0,
  `attempts` INT NULL DEFAULT 0,
  `password` VARCHAR(255) NOT NULL,
  `plainpassword` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_users_company_idx` (`company_id` ASC),
  UNIQUE INDEX `username_UNIQUE` (`username` ASC),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC),
  UNIQUE INDEX `phone_UNIQUE` (`phone` ASC),
  CONSTRAINT `fk_users_companies`
    FOREIGN KEY (`company_id`)
    REFERENCES `widgets`.`companies` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COLLATE = utf8mb4_bin;


-- -----------------------------------------------------
-- Table `widgets`.`groups`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `widgets`.`groups` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
COLLATE = utf8mb4_bin;


-- -----------------------------------------------------
-- Table `widgets`.`customers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `widgets`.`customers` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(45) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `plainpassword` VARCHAR(255) NOT NULL,
  `email` VARCHAR(155) NOT NULL,
  `address` VARCHAR(255) NOT NULL,
  `instructions` TEXT NULL DEFAULT NULL,
  `phone` VARCHAR(45) NOT NULL,
  `verified` TINYINT(1) NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `customer_username_UNIQUE` (`username` ASC),
  UNIQUE INDEX `customer_email_UNIQUE` (`email` ASC),
  UNIQUE INDEX `address_UNIQUE` (`address` ASC),
  UNIQUE INDEX `phone_UNIQUE` (`phone` ASC))
ENGINE = InnoDB
COLLATE = utf8mb4_bin;


-- -----------------------------------------------------
-- Table `widgets`.`orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `widgets`.`orders` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `fulfilled` INT UNSIGNED NULL DEFAULT 0,
  `unfulfilled` INT UNSIGNED NULL,
  `is_shipped` TINYINT(1) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
COLLATE = utf8mb4_bin;


-- -----------------------------------------------------
-- Table `widgets`.`companyToGroups`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `widgets`.`companyToGroups` (
  `groups_id` INT UNSIGNED NOT NULL,
  `companies_id` INT UNSIGNED NOT NULL,
  INDEX `fk_companyToGroups_groups1_idx` (`groups_id` ASC),
  INDEX `fk_companyToGroups_companies1_idx` (`companies_id` ASC),
  UNIQUE INDEX `uniqueCompaniesToGroups` (`groups_id` ASC, `companies_id` ASC),
  CONSTRAINT `fk_companyToGroups_groups1`
    FOREIGN KEY (`groups_id`)
    REFERENCES `widgets`.`groups` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_companyToGroups_companies1`
    FOREIGN KEY (`companies_id`)
    REFERENCES `widgets`.`companies` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `widgets`.`customersToOrders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `widgets`.`customersToOrders` (
  `orders_id` INT UNSIGNED NOT NULL,
  `customers_id` INT UNSIGNED NOT NULL,
  INDEX `fk_customersToOrders_orders1_idx` (`orders_id` ASC),
  INDEX `fk_customersToOrders_customers1_idx` (`customers_id` ASC),
  UNIQUE INDEX `uniqueCustomerToOrder` (`orders_id` ASC, `customers_id` ASC),
  CONSTRAINT `fk_customersToOrders_orders1`
    FOREIGN KEY (`orders_id`)
    REFERENCES `widgets`.`orders` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_customersToOrders_customers1`
    FOREIGN KEY (`customers_id`)
    REFERENCES `widgets`.`customers` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `widgets`.`groupsToOrders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `widgets`.`groupsToOrders` (
  `groups_id` INT UNSIGNED NOT NULL,
  `orders_id` INT UNSIGNED NOT NULL,
  INDEX `fk_groupsToOrders_groups1_idx` (`groups_id` ASC),
  INDEX `fk_groupsToOrders_orders1_idx` (`orders_id` ASC),
  UNIQUE INDEX `uniqueGroupToOrder` (`orders_id` ASC, `groups_id` ASC),
  CONSTRAINT `fk_groupsToOrders_groups1`
    FOREIGN KEY (`groups_id`)
    REFERENCES `widgets`.`groups` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_groupsToOrders_orders1`
    FOREIGN KEY (`orders_id`)
    REFERENCES `widgets`.`orders` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `widgets`.`employeesToGroups`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `widgets`.`employeesToGroups` (
  `groups_id` INT UNSIGNED NOT NULL,
  `employees_id` INT UNSIGNED NOT NULL,
  INDEX `fk_employeesToGroups_groups1_idx` (`groups_id` ASC),
  INDEX `fk_employeesToGroups_employees1_idx` (`employees_id` ASC),
  UNIQUE INDEX `uniqueEmployeesToGroups` (`employees_id` ASC, `groups_id` ASC),
  CONSTRAINT `fk_employeesToGroups_groups1`
    FOREIGN KEY (`groups_id`)
    REFERENCES `widgets`.`groups` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_employeesToGroups_employees1`
    FOREIGN KEY (`employees_id`)
    REFERENCES `widgets`.`employees` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
