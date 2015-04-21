SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
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
-- Table `FamilyBudget`.`dimSubCategory`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `FamilyBudget`.`dimSubCategory` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `FamilyBudget`.`dimSubCategory` (
  `SubCategoryKey` CHAR(36) NOT NULL,
  `CategoryKey` CHAR(36) NOT NULL,
  `AccountKey` CHAR(36) NOT NULL,
  `SubCategoryName` VARCHAR(100) NOT NULL,
  `SubCategoryPrefix` VARCHAR(10) NOT NULL,
  `IsActive` TINYINT(1) NOT NULL,
  `IsGoal` TINYINT(1) NOT NULL,
  `LastUpdatedDate` DATETIME NULL,
  PRIMARY KEY (`SubCategoryKey`),
  CONSTRAINT `fk_dimSubCategory_dimCategory1`
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
CREATE INDEX `fk_dimSubCategory_dimCategory1_idx` ON `FamilyBudget`.`dimSubCategory` (`CategoryKey` ASC);

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
DROP TABLE IF EXISTS `FamilyBudget`.`SubTypes` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `FamilyBudget`.`SubTypes` (
  `SubTypeId` TINYINT(4) NOT NULL,
  `SubTypeName` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`SubTypeId`))
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
  `YearId` SMALLINT(6) NOT NULL,
  `SubCategoryKey` CHAR(36) NOT NULL,
  `Description` VARCHAR(500) NOT NULL,
  `Amount` DECIMAL(7,2) NOT NULL,
  `TypeId` TINYINT(4) NOT NULL,
  `SubTypeId` TINYINT(4) NOT NULL,
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
  CONSTRAINT `fk_factLineItem_dimSubCategory1`
    FOREIGN KEY (`SubCategoryKey`)
    REFERENCES `FamilyBudget`.`dimSubCategory` (`SubCategoryKey`)
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
  CONSTRAINT `fk_factLineItem_SubTypes1`
    FOREIGN KEY (`SubTypeId`)
    REFERENCES `FamilyBudget`.`SubTypes` (`SubTypeId`)
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
CREATE INDEX `fk_factLineItem_dimSubCategory1_idx` ON `FamilyBudget`.`factLineItem` (`SubCategoryKey` ASC);

SHOW WARNINGS;
CREATE INDEX `fk_factLineItem_Statuses1_idx` ON `FamilyBudget`.`factLineItem` (`StatusId` ASC);

SHOW WARNINGS;
CREATE INDEX `fk_factLineItem_dimPaymentMethod1_idx` ON `FamilyBudget`.`factLineItem` (`PaymentMethodKey` ASC);

SHOW WARNINGS;
CREATE INDEX `fk_factLineItem_SubTypes1_idx` ON `FamilyBudget`.`factLineItem` (`SubTypeId` ASC);

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
	`SubCategoryName` VARCHAR(100) NOT NULL,
	`ReconciledAmount` DECIMAL(7,2) NOT NULL,
	`PendingAmount` DECIMAL(7,2) NOT NULL,
  `LatestTransactionDate` DATETIME NULL,
	PRIMARY KEY (`SubCategoryName`))
ENGINE = InnoDB;
SHOW WARNINGS;

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

INSERT INTO DaysOfWeek (DayOfWeekId, DayOfWeekName) VALUES (0, 'Sunday');
INSERT INTO DaysOfWeek (DayOfWeekId, DayOfWeekName) VALUES (1, 'Monday');
INSERT INTO DaysOfWeek (DayOfWeekId, DayOfWeekName) VALUES (2, 'Tuesday');
INSERT INTO DaysOfWeek (DayOfWeekId, DayOfWeekName) VALUES (3, 'Wednesday');
INSERT INTO DaysOfWeek (DayOfWeekId, DayOfWeekName) VALUES (4, 'Thursday');
INSERT INTO DaysOfWeek (DayOfWeekId, DayOfWeekName) VALUES (5, 'Friday');
INSERT INTO DaysOfWeek (DayOfWeekId, DayOfWeekName) VALUES (6, 'Saturday');

INSERT INTO Statuses (StatusId, StatusName) VALUES (0, 'Reconciled');
INSERT INTO Statuses (StatusId, StatusName) VALUES (1, 'Pending');
INSERT INTO Statuses (StatusId, StatusName) VALUES (2, 'Future');
INSERT INTO Statuses (StatusId, StatusName) VALUES (3, 'Goal');

INSERT INTO SubTypes (SubTypeId, SubTypeName) VALUES (0, 'Debit');
INSERT INTO SubTypes (SubTypeId, SubTypeName) VALUES (1, 'Credit');
INSERT INTO SubTypes (SubTypeId, SubTypeName) VALUES (2, 'Goal');

INSERT INTO Types (TypeId, TypeName) VALUES (0, 'Expense');
INSERT INTO Types (TypeId, TypeName) VALUES (1, 'Allocation');
INSERT INTO Types (TypeId, TypeName) VALUES (2, 'Bucket Adjustment');
INSERT INTO Types (TypeId, TypeName) VALUES (3, 'Goal');

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
