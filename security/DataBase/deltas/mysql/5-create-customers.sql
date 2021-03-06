SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE TABLE IF NOT EXISTS `widgets`.`customers` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(45) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `plainpassword` VARCHAR(255) NOT NULL,
  `email` VARCHAR(155) NOT NULL,
  `address` VARCHAR(155) NOT NULL,
  `instructions` TEXT NULL DEFAULT NULL,
  `phone` VARCHAR(45) NOT NULL,
  `verified` TINYINT(1) NULL DEFAULT 0,
  `city` VARCHAR(155) NULL,
  `state` VARCHAR(155) NULL,
  `countrycode` VARCHAR(3) NULL DEFAULT 'USA',
  `zip` VARCHAR(12) NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `customer_username_UNIQUE` (`username` ASC),
  UNIQUE INDEX `customer_email_UNIQUE` (`email` ASC),
  UNIQUE INDEX `address_UNIQUE` (`address` ASC),
  UNIQUE INDEX `phone_UNIQUE` (`phone` ASC),
  INDEX `customers_zip` (`zip` ASC),
  INDEX `customers_countrycode` (`countrycode` ASC))
ENGINE = InnoDB
COLLATE = utf8mb4_bin;

GRANT SELECT, INSERT, UPDATE, DELETE ON widgets.customers TO 'widgetCustomer'@'%' IDENTIFIED BY 'somepassword';
GRANT SELECT, INSERT, UPDATE, DELETE ON widgets.customers TO 'widgetCustomer'@'localhost' IDENTIFIED BY 'somepassword';
GRANT SELECT, INSERT, UPDATE, DELETE ON widgets.customers TO 'widgetCustomer'@'127.0.0.1' IDENTIFIED BY 'somepassword';

GRANT SELECT ON widgets.customers TO 'widgetCorporate'@'%' IDENTIFIED BY 'somepassword';
GRANT SELECT ON widgets.customers TO 'widgetCorporate'@'localhost' IDENTIFIED BY 'somepassword';
GRANT SELECT ON widgets.customers TO 'widgetCorporate'@'127.0.0.1' IDENTIFIED BY 'somepassword';

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


--//@UNDO
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

REVOKE SELECT, INSERT, UPDATE, DELETE ON widgets.customers TO 'widgetCustomer'@'%';
REVOKE SELECT, INSERT, UPDATE, DELETE ON widgets.customers TO 'widgetCustomer'@'localhost';
REVOKE SELECT, INSERT, UPDATE, DELETE ON widgets.customers TO 'widgetCustomer'@'127.0.0.1';

REVOKE SELECT ON widgets.customers TO 'widgetCorporate'@'%' IDENTIFIED BY 'somepassword';
REVOKE SELECT ON widgets.customers TO 'widgetCorporate'@'localhost' IDENTIFIED BY 'somepassword';
REVOKE SELECT ON widgets.customers TO 'widgetCorporate'@'127.0.0.1' IDENTIFIED BY 'somepassword';

DROP TABLE IF EXISTS `widgets`.`customers`;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
--//

