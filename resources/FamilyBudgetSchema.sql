SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- ----authorizeduser-------------------------------------------------
-- Schema FamilyBudget
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `FamilyBudget` ;
CREATE SCHEMA IF NOT EXISTS `FamilyBudget` DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci ;
SHOW WARNINGS;
USE `FamilyBudget` ;

-- -----------------------------------------------------
-- Table `FamilyBudget`.`AuthorizedUser`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `FamilyBudget`.`AuthorizedUser` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `FamilyBudget`.`AuthorizedUser` (
  `Username` VARCHAR(30) NOT NULL,
  `Password` VARCHAR(32) NOT NULL,
  `IsActive` TINYINT(1) NOT NULL,
  PRIMARY KEY (`Username`))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `FamilyBudget`.`Months`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `FamilyBudget`.`Months` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `FamilyBudget`.`Months` (
  `MonthId` TINYINT(4) NOT NULL,
  `MonthName` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`MonthId`))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `FamilyBudget`.`DaysOfWeek`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `FamilyBudget`.`DaysOfWeek` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `FamilyBudget`.`DaysOfWeek` (
  `DayOfWeekId` TINYINT(4) NOT NULL,
  `DayOfWeekName` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`DayOfWeekId`))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `FamilyBudget`.`dimCategory`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `FamilyBudget`.`dimCategory` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `FamilyBudget`.`dimCategory` (
  `CategoryKey` CHAR(36) NOT NULL,
  `CategoryName` VARCHAR(100) NOT NULL,
  `IsActive` TINYINT(1) NOT NULL,
  `LastUpdatedDate` DATETIME NULL,
  PRIMARY KEY (`CategoryKey`))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `FamilyBudget`.`dimAccount`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `FamilyBudget`.`dimAccount` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `FamilyBudget`.`dimAccount` (
	`AccountKey` CHAR(36) NOT NULL,
	`AccountName` VARCHAR(100) NOT NULL,
  `IsActive` TINYINT(1) NOT NULL,
	`LastUpdatedDate` DATETIME NULL,
	PRIMARY KEY (`AccountKey`))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `FamilyBudget`.`dimSubcategory`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `FamilyBudget`.`dimSubcategory` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `FamilyBudget`.`dimSubcategory` (
  `SubcategoryKey` CHAR(36) NOT NULL,
  `CategoryKey` CHAR(36) NOT NULL,
  `AccountKey` CHAR(36) NOT NULL,
  `SubcategoryName` VARCHAR(100) NOT NULL,
  `SubcategoryPrefix` VARCHAR(10) NOT NULL,
  `IsActive` TINYINT(1) NOT NULL,
  `IsGoal` TINYINT(1) NOT NULL,
  `LastUpdatedDate` DATETIME NULL,
  PRIMARY KEY (`SubcategoryKey`),
  CONSTRAINT `fk_dimSubcategory_dimCategory1`
    FOREIGN KEY (`CategoryKey`)
    REFERENCES `FamilyBudget`.`dimCategory` (`CategoryKey`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_dimSubCategory_dimAccount1`
	FOREIGN KEY (`AccountKey`)
	REFERENCES `FamilyBudget`.`dimAccount` (`AccountKey`)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;
CREATE INDEX `fk_dimSubcategory_dimCategory1_idx` ON `FamilyBudget`.`dimSubcategory` (`CategoryKey` ASC);

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `FamilyBudget`.`Statuses`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `FamilyBudget`.`Statuses` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `FamilyBudget`.`Statuses` (
  `StatusId` TINYINT(4) NOT NULL,
  `StatusName` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`StatusId`))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `FamilyBudget`.`dimPaymentMethod`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `FamilyBudget`.`dimPaymentMethod` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `FamilyBudget`.`dimPaymentMethod` (
  `PaymentMethodKey` CHAR(36) NOT NULL,
  `PaymentMethodName` VARCHAR(100) NOT NULL,
  `IsActive` TINYINT(1) NOT NULL,
  `LastUpdatedDate` DATETIME NULL,
  PRIMARY KEY (`PaymentMethodKey`))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `FamilyBudget`.`SubTypes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `FamilyBudget`.`Subtypes` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `FamilyBudget`.`Subtypes` (
  `SubtypeId` TINYINT(4) NOT NULL,
  `SubtypeName` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`SubtypeId`))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `FamilyBudget`.`Types`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `FamilyBudget`.`Types` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `FamilyBudget`.`Types` (
  `TypeId` TINYINT(4) NOT NULL,
  `TypeName` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`TypeId`))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `FamilyBudget`.`factLineItem`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `FamilyBudget`.`factLineItem` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `FamilyBudget`.`factLineItem` (
  `UniqueKey` CHAR(36) NOT NULL,
  `MonthId` TINYINT(4) NOT NULL,
  `DayOfMonth` TINYINT(4) NOT NULL,
  `DayOfWeekId` TINYINT(4) NOT NULL,
  `Year` SMALLINT(6) NOT NULL,
  `SubcategoryKey` CHAR(36) NOT NULL,
  `Description` VARCHAR(500) NOT NULL,
  `Amount` DECIMAL(7,2) NOT NULL,
  `TypeId` TINYINT(4) NOT NULL,
  `SubtypeId` TINYINT(4) NOT NULL,
  `QuarterId` TINYINT(4) NOT NULL,
  `PaymentMethodKey` CHAR(36) NOT NULL,
  `StatusId` TINYINT(4) NOT NULL,
  `LastUpdatedDate` DATETIME NULL,
  PRIMARY KEY (`UniqueKey`),
  CONSTRAINT `fk_factLineItem_Months`
    FOREIGN KEY (`MonthId`)
    REFERENCES `FamilyBudget`.`Months` (`MonthId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_factLineItem_DaysOfWeek1`
    FOREIGN KEY (`DayOfWeekId`)
    REFERENCES `FamilyBudget`.`DaysOfWeek` (`DayOfWeekId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_factLineItem_dimSubcategory1`
    FOREIGN KEY (`SubcategoryKey`)
    REFERENCES `FamilyBudget`.`dimSubcategory` (`SubcategoryKey`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_factLineItem_Statuses1`
    FOREIGN KEY (`StatusId`)
    REFERENCES `FamilyBudget`.`Statuses` (`StatusId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_factLineItem_dimPaymentMethod1`
    FOREIGN KEY (`PaymentMethodKey`)
    REFERENCES `FamilyBudget`.`dimPaymentMethod` (`PaymentMethodKey`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_factLineItem_Subtypes1`
    FOREIGN KEY (`SubTypeId`)
    REFERENCES `FamilyBudget`.`Subtypes` (`SubtypeId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_factLineItem_Types1`
    FOREIGN KEY (`TypeId`)
    REFERENCES `FamilyBudget`.`Types` (`TypeId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;

CREATE INDEX `fk_factLineItem_Months_idx` ON `FamilyBudget`.`factLineItem` (`MonthId` ASC);

SHOW WARNINGS;
CREATE INDEX `fk_factLineItem_DaysOfWeek1_idx` ON `FamilyBudget`.`factLineItem` (`DayOfWeekId` ASC);

SHOW WARNINGS;
CREATE INDEX `fk_factLineItem_dimSubcategory1_idx` ON `FamilyBudget`.`factLineItem` (`SubcategoryKey` ASC);

SHOW WARNINGS;
CREATE INDEX `fk_factLineItem_Statuses1_idx` ON `FamilyBudget`.`factLineItem` (`StatusId` ASC);

SHOW WARNINGS;
CREATE INDEX `fk_factLineItem_dimPaymentMethod1_idx` ON `FamilyBudget`.`factLineItem` (`PaymentMethodKey` ASC);

SHOW WARNINGS;
CREATE INDEX `fk_factLineItem_Subtypes1_idx` ON `FamilyBudget`.`factLineItem` (`SubtypeId` ASC);

SHOW WARNINGS;
CREATE INDEX `fk_factLineItem_Types1_idx` ON `FamilyBudget`.`factLineItem` (`TypeId` ASC);

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table  `FamilyBudget`.`BudgetAllowances`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `FamilyBudget`.`BudgetAllowances`;
SHOW WARNINGS;

CREATE TABLE IF NOT EXISTS `FamilyBudget`.`BudgetAllowances` (
	`CategoryName` VARCHAR(100) NOT NULL,
	`SubcategoryName` VARCHAR(100) NOT NULL,
	`ReconciledAmount` DECIMAL(7,2) NOT NULL,
	`PendingAmount` DECIMAL(7,2) NOT NULL,
	`LatestTransactionDate` DATETIME NULL,
	PRIMARY KEY (`SubcategoryName`))
ENGINE = InnoDB;
SHOW WARNINGS;

-- -----------------------------------------------------
-- View  `FamilyBudget`.`ActiveLineItems_PendingFutureGoal`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `FamilyBudget`.`ActiveLineItems_PendingFutureGoal`;
SHOW WARNINGS;

CREATE VIEW `FamilyBudget`.`ActiveLineItems_PendingFutureGoal` AS
    select 
        `fli`.`UniqueKey` AS `UniqueKey`,
        `fli`.`MonthId` AS `MonthId`,
        `fli`.`DayOfMonth` AS `DayOfMonth`,
        `fli`.`DayOfWeekId` AS `DayOfWeekId`,
        `fli`.`Year` AS `Year`,
        `fli`.`SubcategoryKey` AS `SubcategoryKey`,
        `fli`.`Description` AS `Description`,
        `fli`.`Amount` AS `Amount`,
        `fli`.`TypeId` AS `TypeId`,
        `fli`.`SubtypeId` AS `SubtypeId`,
        `fli`.`QuarterId` AS `QuarterId`,
        `fli`.`PaymentMethodKey` AS `PaymentMethodKey`,
        `fli`.`StatusId` AS `StatusId`,
        `fli`.`LastUpdatedDate` AS `LastUpdatedDate`
    from
        (`factLineItem` `fli`
        join `dimSubcategory` `sc` ON ((`fli`.`SubcategoryKey` = `sc`.`SubcategoryKey`)))
    where
        ((`fli`.`StatusId` in (1 , 2, 3))
        and (`sc`.`IsActive` = 1));
SHOW WARNINGS;

-- -----------------------------------------------------
-- View  `FamilyBudget`.`ActiveLineItems_ReconciledPriorQuarters_Condensed`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `FamilyBudget`.`ActiveLineItems_PendingFutureGoal`;
SHOW WARNINGS;

CREATE VIEW `FamilyBudget`.`ActiveLineItems_ReconciledPriorQuarters_Condensed` AS
    select 
        'CONDENSED_ENTRY' AS `UniqueKey`,
        (case `fli`.`QuarterId`
            when 1 then 3
            when 2 then 6
            when 3 then 9
            when 4 then 12
        end) AS `MonthId`,
        (case `fli`.`QuarterId`
            when 1 then 31
            when 2 then 30
            when 3 then 31
            when 4 then 31
        end) AS `DayOfMonth`,
        (case `fli`.`QuarterId`
            when 1 then dayofweek(str_to_date(concat('3-31-', `fli`.`Year`), '%m-%d-%Y'))
            when 2 then dayofweek(str_to_date(concat('6-30-', `fli`.`Year`), '%m-%d-%Y'))
            when 3 then dayofweek(str_to_date(concat('9-31-', `fli`.`Year`), '%m-%d-%Y'))
            when 4 then dayofweek(str_to_date(concat('12-31-', `fli`.`Year`),'%m-%d-%Y'))
        end) AS `DayOfWeek`,
        `fli`.`Year` AS `Year`,
        `fli`.`SubcategoryKey` AS `SubcategoryKey`,
        'CONDENSED ENTRIES' AS `Description`,
        sum(`fli`.`Amount`) AS `Amount`,
        4 AS `TypeId`,
        3 AS `SubtypeId`,
        `fli`.`QuarterId` AS `QuarterId`,
        'CONDENSED_ENTRY' AS `PaymentMethodKey`,
        0 AS `StatusId`,
        max(`fli`.`LastUpdatedDate`) AS `LastUpdatedDate`
    from
        (`factLineItem` `fli`
        join `dimSubcategory` `sc` ON ((`fli`.`SubcategoryKey` = `sc`.`SubcategoryKey`)))
    where
        ((`fli`.`TypeId` <> 3)
        and (`fli`.`StatusId` = 0)
        and (concat(`fli`.`QuarterId`, `fli`.`Year`) <> concat(quarter(NOW()), year(NOW())))
        and (`sc`.`IsActive` = 1))
    group by 
      `fli`.`SubcategoryKey`,
      `fli`.`Year`,
      `fli`.`QuarterId`;

-- -----------------------------------------------------
-- View  `FamilyBudget`.`ActiveLineItems_ReconciledCurrentQuarter`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `FamilyBudget`.`ActiveLineItems_ReconciledCurrentQuarter`;
SHOW WARNINGS;

CREATE VIEW `FamilyBudget`.`ActiveLineItems_ReconciledCurrentQuarter` AS
    select 
        `fli`.`UniqueKey` AS `UniqueKey`,
        `fli`.`MonthId` AS `MonthId`,
        `fli`.`DayOfMonth` AS `DayOfMonth`,
        `fli`.`DayOfWeekId` AS `DayOfWeekId`,
        `fli`.`Year` AS `Year`,
        `fli`.`SubcategoryKey` AS `SubcategoryKey`,
        `fli`.`Description` AS `Description`,
        `fli`.`Amount` AS `Amount`,
        `fli`.`TypeId` AS `TypeId`,
        `fli`.`SubtypeId` AS `SubtypeId`,
        `fli`.`QuarterId` AS `QuarterId`,
        `fli`.`PaymentMethodKey` AS `PaymentMethodKey`,
        `fli`.`StatusId` AS `StatusId`,
        `fli`.`LastUpdatedDate` AS `LastUpdatedDate`
    from
        (`factLineItem` `fli`
        join `dimSubcategory` `sc` ON ((`fli`.`SubcategoryKey` = `sc`.`SubcategoryKey`)))
    where
        ((`fli`.`TypeId` <> 3)
        and (`fli`.`StatusId` = 0)
        and (concat(`fli`.`QuarterId`, `fli`.`Year`) = concat(quarter(now ()), year(now ())))
        and (`sc`.`IsActive` = 1));

-- -----------------------------------------------------
-- Initial data for months, days of weeks, status, subtype, and type
-- -----------------------------------------------------
INSERT INTO Months (MonthId, MonthName) VALUES (1, 'January');
INSERT INTO Months (MonthId, MonthName) VALUES (2, 'February');
INSERT INTO Months (MonthId, MonthName) VALUES (3, 'March');
INSERT INTO Months (MonthId, MonthName) VALUES (4, 'April');
INSERT INTO Months (MonthId, MonthName) VALUES (5, 'May');
INSERT INTO Months (MonthId, MonthName) VALUES (6, 'June');
INSERT INTO Months (MonthId, MonthName) VALUES (7, 'July');
INSERT INTO Months (MonthId, MonthName) VALUES (8, 'August');
INSERT INTO Months (MonthId, MonthName) VALUES (9, 'September');
INSERT INTO Months (MonthId, MonthName) VALUES (10, 'October');
INSERT INTO Months (MonthId, MonthName) VALUES (11, 'November');
INSERT INTO Months (MonthId, MonthName) VALUES (12, 'December');

INSERT INTO DaysOfWeek (DayOfWeekId, DayOfWeekName) VALUES (1, 'Sunday');
INSERT INTO DaysOfWeek (DayOfWeekId, DayOfWeekName) VALUES (2, 'Monday');
INSERT INTO DaysOfWeek (DayOfWeekId, DayOfWeekName) VALUES (3, 'Tuesday');
INSERT INTO DaysOfWeek (DayOfWeekId, DayOfWeekName) VALUES (4, 'Wednesday');
INSERT INTO DaysOfWeek (DayOfWeekId, DayOfWeekName) VALUES (5, 'Thursday');
INSERT INTO DaysOfWeek (DayOfWeekId, DayOfWeekName) VALUES (6, 'Friday');
INSERT INTO DaysOfWeek (DayOfWeekId, DayOfWeekName) VALUES (7, 'Saturday');

INSERT INTO Statuses (StatusId, StatusName) VALUES (0, 'Reconciled');
INSERT INTO Statuses (StatusId, StatusName) VALUES (1, 'Pending');
INSERT INTO Statuses (StatusId, StatusName) VALUES (2, 'Future');
INSERT INTO Statuses (StatusId, StatusName) VALUES (3, 'Goal');

INSERT INTO Subtypes (SubtypeId, SubtypeName) VALUES (0, 'Debit');
INSERT INTO Subtypes (SubtypeId, SubtypeName) VALUES (1, 'Credit');
INSERT INTO Subtypes (SubtypeId, SubtypeName) VALUES (2, 'Goal');
INSERT INTO Subtypes (SubtypeId, SubtypeName) VALUES (3, 'Mixed');

INSERT INTO Types (TypeId, TypeName) VALUES (0, 'Expense');
INSERT INTO Types (TypeId, TypeName) VALUES (1, 'Allocation');
INSERT INTO Types (TypeId, TypeName) VALUES (2, 'Bucket Adjustment');
INSERT INTO Types (TypeId, TypeName) VALUES (3, 'Goal');
INSERT INTO Types (TypeId, TypeName) VALUES (4, 'Mixed');

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
