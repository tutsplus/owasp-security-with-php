SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE TABLE IF NOT EXISTS `widgets`.`groupsToOrders` (
  `groups_id` INT UNSIGNED NOT NULL,
  `orders_id` INT UNSIGNED NOT NULL,
  INDEX `fk_groupsToOrders_groups1_idx` (`groups_id` ASC),
  INDEX `fk_groupsToOrders_orders1_idx` (`orders_id` ASC),
  UNIQUE INDEX `uniqueGroupToOrder` (`orders_id` ASC, `groups_id` ASC),
  CONSTRAINT `fk_groupsToOrders_groups1`
    FOREIGN KEY (`groups_id`)
    REFERENCES `widgets`.`groups` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_groupsToOrders_orders1`
    FOREIGN KEY (`orders_id`)
    REFERENCES `widgets`.`orders` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
COLLATE = utf8mb4_bin;

GRANT SELECT, INSERT, UPDATE, DELETE ON widgets.groupsToOrders TO 'widgetCorporate'@'%' IDENTIFIED BY 'somepassword'; 
GRANT SELECT, INSERT, UPDATE, DELETE ON widgets.groupsToOrders TO 'widgetCorporate'@'localhost' IDENTIFIED BY 'somepassword'; 
GRANT SELECT, INSERT, UPDATE, DELETE ON widgets.groupsToOrders TO 'widgetCorporate'@'127.0.0.1' IDENTIFIED BY 'somepassword';

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

--//@UNDO
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

REVOKE SELECT, INSERT, UPDATE, DELETE ON widgets.groupsToOrders TO 'widgetCorporate'@'%';
REVOKE SELECT, INSERT, UPDATE, DELETE ON widgets.groupsToOrders TO 'widgetCorporate'@'localhost';
REVOKE SELECT, INSERT, UPDATE, DELETE ON widgets.groupsToOrders TO 'widgetCorporate'@'127.0.0.1';

DROP TABLE IF EXISTS `widgets`.`groupsToOrders`;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
--//    
