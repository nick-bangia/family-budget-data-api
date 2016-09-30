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
  `Password` VARCHAR(36) NOT NULL,
  `IsActive` TINYINT(1) NOT NULL,
  PRIMARY KEY (`Username`))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `FamilyBudget`.`AccessToken`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `FamilyBudget`.`AccessToken`;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `FamilyBudget`.`AccessToken` (
	`AuthorizedUser` VARCHAR(100) NOT NULL,
	`AccessToken` VARCHAR(36) NOT NULL,
	`AccessExpires`  DATETIME NOT NULL,
    `RefreshToken` VARCHAR(36) NOT NULL,
    `RefreshExpires` DATETIME NOT NULL,
	PRIMARY KEY (`AuthorizedUser`, `AccessToken`))
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
  `IsAllocatable` TINYINT(1) NOT NULL,
  `LastUpdatedDate` DATETIME NULL,
  PRIMARY KEY (`SubcategoryKey`),
  CONSTRAINT `fk_dimSubcategory_dimCategory1`
    FOREIGN KEY (`CategoryKey`)
    REFERENCES `FamilyBudget`.`dimCategory` (`CategoryKey`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_dimSubcategory_dimAccount1`
	FOREIGN KEY (`AccountKey`)
	REFERENCES `FamilyBudget`.`dimAccount` (`AccountKey`)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;
CREATE INDEX `fk_dimSubcategory_dimCategory1_idx` ON `FamilyBudget`.`dimSubcategory` (`CategoryKey` ASC);

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `FamilyBudget`.`dimGoal`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `FamilyBudget`.`dimGoal` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `FamilyBudget`.`dimGoal` (
  `GoalKey` CHAR(36) NOT NULL,
  `GoalAmount` DECIMAL(7,2) NOT NULL,
  `EstimatedCompletionDate` DATETIME NULL,
  `LastUpdatedDate` DATETIME NULL,
  PRIMARY KEY (`GoalKey`),
  CONSTRAINT `fk_dimGoal_dimSubcategory1`
    FOREIGN KEY (`GoalKey`)
	  REFERENCES `FamilyBudget`.`dimSubcategory` (`SubcategoryKey`)
	  ON DELETE NO ACTION
	  ON UPDATE NO ACTION)
ENGINE = InnoDB;

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
  `Year` SMALLINT(6) NOT NULL,
  `SubcategoryKey` CHAR(36) NOT NULL,
  `Description` VARCHAR(500) NOT NULL,
  `Amount` DECIMAL(7,2) NOT NULL,
  `TypeId` TINYINT(4) NOT NULL,
  `SubtypeId` TINYINT(4) NOT NULL,
  `Quarter` TINYINT(4) NOT NULL,
  `PaymentMethodKey` CHAR(36) NOT NULL,
  `StatusId` TINYINT(4) NOT NULL,
  `IsTaxDeductible` TINYINT(1) NOT NULL,
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
    FOREIGN KEY (`SubtypeId`)
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
	`AccountName` VARCHAR(100) NOT NULL,
  `CategoryName` VARCHAR(100) NOT NULL,
	`SubcategoryName` VARCHAR(100) NOT NULL,
	`ReconciledAmount` DECIMAL(7,2) NOT NULL,
	`PendingAmount` DECIMAL(7,2) NOT NULL,
	`LatestTransactionDate` DATETIME NULL,
	PRIMARY KEY (`SubcategoryName`))
ENGINE = InnoDB;
SHOW WARNINGS;

-- -----------------------------------------------------
-- View  `FamilyBudget`.`ActiveLineItems_Pending`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `FamilyBudget`.`ActiveLineItems_Pending`;
SHOW WARNINGS;

CREATE VIEW `FamilyBudget`.`ActiveLineItems_Pending` AS
    select 
      `fli`.`UniqueKey` AS `UniqueKey`,
      `fli`.`MonthId` AS `MonthId`,
      `m`.`MonthName` AS `MonthName`,
      `fli`.`DayOfMonth` AS `DayOfMonth`,
      `fli`.`DayOfWeekId` AS `DayOfWeekId`,
      `dow`.`DayOfWeekName` AS `DayOfWeekName`,
      `fli`.`Year` AS `Year`,
      `c`.`CategoryKey` AS `CategoryKey`,
      `c`.`CategoryName` AS `CategoryName`,
      `fli`.`SubcategoryKey` AS `SubcategoryKey`,
      `sc`.`SubcategoryName` AS `SubcategoryName`,
      `sc`.`SubcategoryPrefix` AS `SubcategoryPrefix`,
      `fli`.`Description` AS `Description`,
      `fli`.`Amount` AS `Amount`,
      `fli`.`TypeId` AS `TypeId`,
      `fli`.`SubtypeId` AS `SubtypeId`,
      `fli`.`Quarter` AS `Quarter`,
      `fli`.`PaymentMethodKey` AS `PaymentMethodKey`,
      `pm`.`PaymentMethodName` AS `PaymentMethodName`,
      `a`.`AccountName` AS `AccountName`,
      `g`.`GoalAmount` AS `GoalAmount`,
      `fli`.`StatusId` AS `StatusId`,
      `fli`.`IsTaxDeductible` AS `IsTaxDeductible`,
      `fli`.`LastUpdatedDate` AS `LastUpdatedDate`
    from
      (`factLineItem` `fli`
      join `dimSubcategory` `sc` ON (`fli`.`SubcategoryKey` = `sc`.`SubcategoryKey`)
      join `dimAccount` `a` ON (`sc`.`AccountKey` = `a`.`AccountKey`)
      join `dimCategory` `c` ON (`sc`.`CategoryKey` = `c`.`CategoryKey`)
      left outer join `dimGoal` `g` ON (`sc`.`SubcategoryKey` = `g`.`GoalKey`)
      join `Months` `m` ON (`fli`.`MonthId` = `m`.`MonthId`)
      join `DaysOfWeek` `dow` ON (`fli`.`DayOfWeekId` = `dow`.`DayOfWeekId`)
      join `dimPaymentMethod` `pm` ON (`fli`.`PaymentMethodKey` = `pm`.`PaymentMethodKey`))
    where
      ((`fli`.`StatusId` = 1)
      and (`sc`.`IsActive` = 1));
SHOW WARNINGS;

-- -----------------------------------------------------
-- View  `FamilyBudget`.`ActiveLineItems_ReconciledPriorMonths_Condensed`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `FamilyBudget`.`ActiveLineItems_ReconciledPriorMonths_Condensed`;
SHOW WARNINGS;

CREATE VIEW `FamilyBudget`.`ActiveLineItems_ReconciledPriorMonths_Condensed` AS
    select 
      'CONDENSED_KEYS' AS `UniqueKey`,
      `fli`.`MonthId`,
      `m`.`MonthName`,
      (case `fli`.`MonthId`
        when 1 then 31
        when 2 then 28
        when 3 then 31
        when 4 then 30
        when 5 then 31
        when 6 then 30
        when 7 then 31
        when 8 then 31
        when 9 then 30
        when 10 then 31
        when 11 then 30
        when 12 then 31
      end) AS `DayOfMonth`,
      (case `fli`.`MonthId`
        when 1 then dayofweek(str_to_date(concat('1-31-', `fli`.`Year`), '%m-%d-%Y'))
        when 2 then dayofweek(str_to_date(concat('2-28-', `fli`.`Year`), '%m-%d-%Y'))
        when 3 then dayofweek(str_to_date(concat('3-31-', `fli`.`Year`), '%m-%d-%Y'))
        when 4 then dayofweek(str_to_date(concat('4-30-', `fli`.`Year`),'%m-%d-%Y'))
        when 5 then dayofweek(str_to_date(concat('5-31-', `fli`.`Year`),'%m-%d-%Y'))
        when 6 then dayofweek(str_to_date(concat('6-30-', `fli`.`Year`),'%m-%d-%Y'))
        when 7 then dayofweek(str_to_date(concat('7-31-', `fli`.`Year`),'%m-%d-%Y'))
        when 8 then dayofweek(str_to_date(concat('8-31-', `fli`.`Year`),'%m-%d-%Y'))
        when 9 then dayofweek(str_to_date(concat('9-30-', `fli`.`Year`),'%m-%d-%Y'))
        when 10 then dayofweek(str_to_date(concat('10-31-', `fli`.`Year`),'%m-%d-%Y'))
        when 11 then dayofweek(str_to_date(concat('11-30-', `fli`.`Year`),'%m-%d-%Y'))
        when 12 then dayofweek(str_to_date(concat('12-31-', `fli`.`Year`),'%m-%d-%Y'))
      end) AS `DayOfWeekId`,
      (case `fli`.`MonthId`
        when 1 then dayname(str_to_date(concat('1-31-', `fli`.`Year`), '%m-%d-%Y'))
        when 2 then dayname(str_to_date(concat('2-28-', `fli`.`Year`), '%m-%d-%Y'))
        when 3 then dayname(str_to_date(concat('3-31-', `fli`.`Year`), '%m-%d-%Y'))
        when 4 then dayname(str_to_date(concat('4-30-', `fli`.`Year`),'%m-%d-%Y'))
        when 5 then dayname(str_to_date(concat('5-31-', `fli`.`Year`),'%m-%d-%Y'))
        when 6 then dayname(str_to_date(concat('6-30-', `fli`.`Year`),'%m-%d-%Y'))
        when 7 then dayname(str_to_date(concat('7-31-', `fli`.`Year`),'%m-%d-%Y'))
        when 8 then dayname(str_to_date(concat('8-31-', `fli`.`Year`),'%m-%d-%Y'))
        when 9 then dayname(str_to_date(concat('9-30-', `fli`.`Year`),'%m-%d-%Y'))
        when 10 then dayname(str_to_date(concat('10-31-', `fli`.`Year`),'%m-%d-%Y'))
        when 11 then dayname(str_to_date(concat('11-30-', `fli`.`Year`),'%m-%d-%Y'))
        when 12 then dayname(str_to_date(concat('12-31-', `fli`.`Year`),'%m-%d-%Y'))
      end) AS `DayOfWeekName`,
      `fli`.`Year` AS `Year`,
      `c`.`CategoryKey` AS `CategoryKey`,
      `c`.`CategoryName` AS `CategoryName`,
      `fli`.`SubcategoryKey` AS `SubcategoryKey`,
      `sc`.`SubcategoryName` AS `SubcategoryName`,
      `sc`.`SubcategoryPrefix` AS `SubcategoryPrefix`,
      'CONDENSED ENTRIES' AS `Description`,
      sum(`fli`.`Amount`) AS `Amount`,
      `fli`.`TypeId`,
      `fli`.`SubtypeId`,
      `fli`.`Quarter` AS `Quarter`,
      'CONDENSED_KEYS' AS `PaymentMethodKey`,
      'CONDENSED ENTRIES' AS `PaymentMethodName`,
      `a`.`AccountName` AS `AccountName`,
      `g`.`GoalAmount` AS `GoalAmount`,
      0 AS `StatusId`,
      `fli`.`IsTaxDeductible` AS `IsTaxDeductible`,
      max(`fli`.`LastUpdatedDate`) AS `LastUpdatedDate`
    from
      (`factLineItem` `fli`
      join `dimSubcategory` `sc` ON (`fli`.`SubcategoryKey` = `sc`.`SubcategoryKey`)
      join `dimCategory` `c` ON (`sc`.`CategoryKey` = `c`.`CategoryKey`)
      join `dimAccount` `a` ON (`sc`.`AccountKey` = `a`.`AccountKey`)
      left outer join `dimGoal` `g` ON (`sc`.`SubcategoryKey` = `g`.`GoalKey`)
      join `Months` `m` ON (`fli`.`MonthId` = `m`.`MonthId`))
    where
      ((`fli`.`StatusId` = 0)
      and (concat(`fli`.`MonthId`, `fli`.`Year`) <> concat(month(NOW()), year(NOW())))
      and (`sc`.`IsActive` = 1))
    group by 
      `fli`.`SubcategoryKey`,
      `sc`.`SubcategoryName`,
      `a`.`AccountName`,
      `c`.`CategoryKey`,
      `c`.`CategoryName`,
      `fli`.`Year`,
      `fli`.`Quarter`,
      `fli`.`MonthId`,
      `fli`.`TypeId`,
      `fli`.`SubtypeId`,
      `fli`.`IsTaxDeductible`;

-- -----------------------------------------------------
-- View  `FamilyBudget`.`ActiveLineItems_ReconciledCurrentMonth`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `FamilyBudget`.`ActiveLineItems_ReconciledCurrentMonth`;
SHOW WARNINGS;

CREATE VIEW `FamilyBudget`.`ActiveLineItems_ReconciledCurrentMonth` AS
    select 
      `fli`.`UniqueKey` AS `UniqueKey`,
      `fli`.`MonthId` AS `MonthId`,
      `m`.`MonthName` AS `MonthName`,
      `fli`.`DayOfMonth` AS `DayOfMonth`,
      `fli`.`DayOfWeekId` AS `DayOfWeekId`,
      `dow`.`DayOfWeekName` AS `DayOfWeekName`,
      `fli`.`Year` AS `Year`,
      `c`.`CategoryKey` AS `CategoryKey`,
      `c`.`CategoryName` AS `CategoryName`,
      `fli`.`SubcategoryKey` AS `SubcategoryKey`,
      `sc`.`SubcategoryName` AS `SubcategoryName`,
      `sc`.`SubcategoryPrefix` AS `SubcategoryPrefix`,
      `fli`.`Description` AS `Description`,
      `fli`.`Amount` AS `Amount`,
      `fli`.`TypeId` AS `TypeId`,
      `fli`.`SubtypeId` AS `SubtypeId`,
      `fli`.`Quarter` AS `Quarter`,
      `fli`.`PaymentMethodKey` AS `PaymentMethodKey`,
      `pm`.`PaymentMethodName` AS `PaymentMethodName`,
      `a`.`AccountName` AS `AccountName`,
      `g`.`GoalAmount` AS `GoalAmount`,
      `fli`.`StatusId` AS `StatusId`,
      `IsTaxDeductible` AS `IsTaxDeductible`,
      `fli`.`LastUpdatedDate` AS `LastUpdatedDate`
    from
        (`factLineItem` `fli`
        join `dimSubcategory` `sc` ON (`fli`.`SubcategoryKey` = `sc`.`SubcategoryKey`)
        join `dimAccount` `a` ON (`sc`.`AccountKey` = `a`.`AccountKey`)
        join `dimCategory` `c` ON (`sc`.`CategoryKey` = `c`.`CategoryKey`)
        left outer join `dimGoal` `g` ON (`sc`.`SubcategoryKey` = `g`.`GoalKey`)
        join `Months` `m` ON (`fli`.`MonthId` = `m`.`MonthId`)
        join `DaysOfWeek` `dow` ON (`fli`.`DayOfWeekId` = `dow`.`DayOfWeekId`)
        join `dimPaymentMethod` `pm` ON (`fli`.`PaymentMethodKey` = `pm`.`PaymentMethodKey`))
    where
        ((`fli`.`StatusId` = 0)
        and (concat(`fli`.`MonthId`, `fli`.`Year`) = concat(month(NOW()), year(NOW())))
        and (`sc`.`IsActive` = 1));

-- -----------------------------------------------------
-- View  `FamilyBudget`.`GoalSummary`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `FamilyBudget`.`GoalSummary`;
SHOW WARNINGS;

CREATE VIEW `FamilyBudget`.`GoalSummary` AS
	SELECT
		`a`.`AccountName` AS `AccountName`,
		`c`.`CategoryKey` AS `CategoryKey`,
      	`c`.`CategoryName` AS `CategoryName`,
      	`sc`.`SubcategoryKey` AS `SubcategoryKey`,
      	`sc`.`SubcategoryName` AS `SubcategoryName`,
		SUM(`fli`.`Amount`) AS `TotalAmount`,
		AVG(`g`.`GoalAmount`) AS `GoalAmount`,
		MAX(`fli`.`LastUpdatedDate`) AS `LastUpdatedDate`
	FROM
		`factLineItem` `fli`
		join `dimSubcategory` `sc` ON (`fli`.`SubcategoryKey` = `sc`.`SubcategoryKey`)
		join `dimAccount` `a` ON (`sc`.`AccountKey` = `a`.`AccountKey`)
		join `dimCategory` `c` ON (`sc`.`CategoryKey` = `c`.`CategoryKey`)
		join `dimGoal` `g` ON (`sc`.`SubcategoryKey` = `g`.`GoalKey`)
	GROUP BY
		`a`.`AccountName`,
		`c`.`CategoryKey`,
		`c`.`CategoryName`,
		`sc`.`SubcategoryKey`,
		`sc`.`SubcategoryName`;

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

INSERT INTO Subtypes (SubtypeId, SubtypeName) VALUES (0, 'Debit');
INSERT INTO Subtypes (SubtypeId, SubtypeName) VALUES (1, 'Credit');

INSERT INTO Types (TypeId, TypeName) VALUES (0, 'Expense');
INSERT INTO Types (TypeId, TypeName) VALUES (1, 'Allocation');
INSERT INTO Types (TypeId, TypeName) VALUES (2, 'Journal Entry');
INSERT INTO Types (TypeId, TypeName) VALUES (3, 'Income');

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
