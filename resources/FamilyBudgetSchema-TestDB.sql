SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema FamilyBudget
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `FamilyBudget_Test` ;
CREATE SCHEMA IF NOT EXISTS `FamilyBudget_Test` DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci ;
SHOW WARNINGS;
USE `FamilyBudget_Test` ;

-- -----------------------------------------------------
-- Table `FamilyBudget_Test`.`AuthorizedUser`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `FamilyBudget_Test`.`AuthorizedUser` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `FamilyBudget_Test`.`AuthorizedUser` (
  `Username` VARCHAR(30) NOT NULL,
  `Password` VARCHAR(32) NOT NULL,
  `IsActive` TINYINT(1) NOT NULL,
  PRIMARY KEY (`Username`))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `FamilyBudget_Test`.`Months`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `FamilyBudget_Test`.`Months` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `FamilyBudget_Test`.`Months` (
  `MonthId` TINYINT(4) NOT NULL,
  `MonthName` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`MonthId`))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `FamilyBudget_Test`.`DaysOfWeek`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `FamilyBudget_Test`.`DaysOfWeek` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `FamilyBudget_Test`.`DaysOfWeek` (
  `DayOfWeekId` TINYINT(4) NOT NULL,
  `DayOfWeekName` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`DayOfWeekId`))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `FamilyBudget_Test`.`dimCategory`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `FamilyBudget_Test`.`dimCategory` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `FamilyBudget_Test`.`dimCategory` (
  `CategoryKey` CHAR(36) NOT NULL,
  `CategoryName` VARCHAR(100) NOT NULL,
  `IsActive` TINYINT(1) NOT NULL,
  `LastUpdatedDate` DATETIME NULL,
  PRIMARY KEY (`CategoryKey`))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `FamilyBudget_Test`.`dimAccount`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `FamilyBudget_Test`.`dimAccount` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `FamilyBudget_Test`.`dimAccount` (
	`AccountKey` CHAR(36) NOT NULL,
	`AccountName` VARCHAR(100) NOT NULL,
  `IsActive` TINYINT(1) NOT NULL,
	`LastUpdatedDate` DATETIME NULL,
	PRIMARY KEY (`AccountKey`))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `FamilyBudget_Test`.`dimSubCategory`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `FamilyBudget_Test`.`dimSubCategory` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `FamilyBudget_Test`.`dimSubCategory` (
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
    REFERENCES `FamilyBudget_Test`.`dimCategory` (`CategoryKey`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_dimSubCategory_dimAccount1`
	FOREIGN KEY (`AccountKey`)
	REFERENCES `FamilyBudget_Test`.`dimAccount` (`AccountKey`)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;
CREATE INDEX `fk_dimSubCategory_dimCategory1_idx` ON `FamilyBudget_Test`.`dimSubCategory` (`CategoryKey` ASC);

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `FamilyBudget_Test`.`Statuses`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `FamilyBudget_Test`.`Statuses` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `FamilyBudget_Test`.`Statuses` (
  `StatusId` TINYINT(4) NOT NULL,
  `StatusName` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`StatusId`))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `FamilyBudget_Test`.`dimPaymentMethod`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `FamilyBudget_Test`.`dimPaymentMethod` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `FamilyBudget_Test`.`dimPaymentMethod` (
  `PaymentMethodKey` CHAR(36) NOT NULL,
  `PaymentMethodName` VARCHAR(100) NOT NULL,
  `IsActive` TINYINT(1) NOT NULL,
  `LastUpdatedDate` DATETIME NULL,
  PRIMARY KEY (`PaymentMethodKey`))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `FamilyBudget_Test`.`SubTypes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `FamilyBudget_Test`.`SubTypes` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `FamilyBudget_Test`.`SubTypes` (
  `SubTypeId` TINYINT(4) NOT NULL,
  `SubTypeName` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`SubTypeId`))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `FamilyBudget_Test`.`Types`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `FamilyBudget_Test`.`Types` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `FamilyBudget_Test`.`Types` (
  `TypeId` TINYINT(4) NOT NULL,
  `TypeName` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`TypeId`))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `FamilyBudget_Test`.`factLineItem`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `FamilyBudget_Test`.`factLineItem` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `FamilyBudget_Test`.`factLineItem` (
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
    REFERENCES `FamilyBudget_Test`.`Months` (`MonthId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_factLineItem_DaysOfWeek1`
    FOREIGN KEY (`DayOfWeekId`)
    REFERENCES `FamilyBudget_Test`.`DaysOfWeek` (`DayOfWeekId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_factLineItem_dimSubCategory1`
    FOREIGN KEY (`SubCategoryKey`)
    REFERENCES `FamilyBudget_Test`.`dimSubCategory` (`SubCategoryKey`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_factLineItem_Statuses1`
    FOREIGN KEY (`StatusId`)
    REFERENCES `FamilyBudget_Test`.`Statuses` (`StatusId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_factLineItem_dimPaymentMethod1`
    FOREIGN KEY (`PaymentMethodKey`)
    REFERENCES `FamilyBudget_Test`.`dimPaymentMethod` (`PaymentMethodKey`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_factLineItem_SubTypes1`
    FOREIGN KEY (`SubTypeId`)
    REFERENCES `FamilyBudget_Test`.`SubTypes` (`SubTypeId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_factLineItem_Types1`
    FOREIGN KEY (`TypeId`)
    REFERENCES `FamilyBudget_Test`.`Types` (`TypeId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;

CREATE INDEX `fk_factLineItem_Months_idx` ON `FamilyBudget_Test`.`factLineItem` (`MonthId` ASC);

SHOW WARNINGS;
CREATE INDEX `fk_factLineItem_DaysOfWeek1_idx` ON `FamilyBudget_Test`.`factLineItem` (`DayOfWeekId` ASC);

SHOW WARNINGS;
CREATE INDEX `fk_factLineItem_dimSubCategory1_idx` ON `FamilyBudget_Test`.`factLineItem` (`SubCategoryKey` ASC);

SHOW WARNINGS;
CREATE INDEX `fk_factLineItem_Statuses1_idx` ON `FamilyBudget_Test`.`factLineItem` (`StatusId` ASC);

SHOW WARNINGS;
CREATE INDEX `fk_factLineItem_dimPaymentMethod1_idx` ON `FamilyBudget_Test`.`factLineItem` (`PaymentMethodKey` ASC);

SHOW WARNINGS;
CREATE INDEX `fk_factLineItem_SubTypes1_idx` ON `FamilyBudget_Test`.`factLineItem` (`SubTypeId` ASC);

SHOW WARNINGS;
CREATE INDEX `fk_factLineItem_Types1_idx` ON `FamilyBudget_Test`.`factLineItem` (`TypeId` ASC);

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table  `FamilyBudget_Test`.`BudgetAllowances`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `FamilyBudget_Test`.`BudgetAllowances`;
SHOW WARNINGS;

CREATE TABLE IF NOT EXISTS `FamilyBudget_Test`.`BudgetAllowances` (
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

-- -----------------------------------------------------
-- Test Data
-- -----------------------------------------------------
INSERT INTO AuthorizedUser (Username, Password, IsActive) VALUES ('TestUser', 'Testing123!', 1);

INSERT INTO dimPaymentMethod (PaymentMethodKey, PaymentMethodName, IsActive, LastUpdatedDate) 
  VALUES ('42F42C49-C3B1-47F8-9A80-9894CD4863F5', 'Test Payment Method', 1, CURDATE());

INSERT INTO dimCategory (CategoryKey, CategoryName, IsActive, LastUpdatedDate)
  VALUES ('7C0A7D39-E2B5-4DAE-B24D-E3260DD7578F', 'Test Category', 1, CURDATE());

INSERT INTO dimAccount (AccountKey, AccountName, IsActive, LastUpdatedDate)
  VALUES ('F00D821B-6FDC-42B7-99D4-FCFC872F3C3A', 'Test Account', 1, CURDATE());

INSERT INTO dimSubCategory (SubCategoryKey, CategoryKey, AccountKey, SubCategoryName, SubCategoryPrefix, IsActive, IsGoal, LastUpdatedDate)
  VALUES ('891B1158-E037-4854-B99B-7814845E0137', '7C0A7D39-E2B5-4DAE-B24D-E3260DD7578F', 'F00D821B-6FDC-42B7-99D4-FCFC872F3C3A',
          'Test SubCategory', 'TSUB', 1, 0, CURDATE());

INSERT INTO factLineItem  (UniqueKey, MonthId, DayOfMonth, DayOfWeekId, YearId, SubCategoryKey, 
                            Description, Amount, TypeId, SubTypeId, QuarterId, PaymentMethodKey,
                            StatusId, LastUpdatedDate)
  VALUES ('CC44462D-4063-40B0-98B5-48BDF2791F4F', 1, 1, 0, 2015,
          '891B1158-E037-4854-B99B-7814845E0137', 'Test Line Item', 10.95, 0, 1, 1,
          '42F42C49-C3B1-47F8-9A80-9894CD4863F5', 0, CURDATE());

INSERT INTO BudgetAllowances (CategoryName, SubCategoryName, ReconciledAmount, PendingAmount, LatestTransactionDate)
  VALUES ('Test Category', 'Test SubCategory', 80, 34.25, CURDATE());
                           
SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
