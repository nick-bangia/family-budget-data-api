SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema FamilyBudget_Test
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
  `Password` VARCHAR(36) NOT NULL,
  `IsActive` TINYINT(1) NOT NULL,
  PRIMARY KEY (`Username`))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `FamilyBudget_Test`.`AccessToken`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `FamilyBudget_Test`.`AccessToken`;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `FamilyBudget_Test`.`AccessToken` (
	`AuthorizedUser` VARCHAR(100) NOT NULL,
	`Token`	   VARCHAR(36) NOT NULL,
	`Expires`  DATETIME NOT NULL,
	PRIMARY KEY (`AuthorizedUser`, `Token`))
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
-- Table `FamilyBudget_Test`.`dimSubcategory`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `FamilyBudget_Test`.`dimSubcategory` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `FamilyBudget_Test`.`dimSubcategory` (
  `SubcategoryKey` CHAR(36) NOT NULL,
  `CategoryKey` CHAR(36) NOT NULL,
  `AccountKey` CHAR(36) NOT NULL,
  `SubcategoryName` VARCHAR(100) NOT NULL,
  `SubcategoryPrefix` VARCHAR(10) NOT NULL,
  `IsActive` TINYINT(1) NOT NULL,
  `IsGoal` TINYINT(1) NOT NULL,
  `IsAllocatable` TINYINT(1) NOT NULL,
  `LastUpdatedDate` DATETIME NULL,
  PRIMARY KEY (`SubcategoryKey`),
  CONSTRAINT `fk_dimSubcategory_dimCategory1`
    FOREIGN KEY (`CategoryKey`)
    REFERENCES `FamilyBudget_Test`.`dimCategory` (`CategoryKey`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_dimSubcategory_dimAccount1`
	FOREIGN KEY (`AccountKey`)
	REFERENCES `FamilyBudget_Test`.`dimAccount` (`AccountKey`)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;
CREATE INDEX `fk_dimSubcategory_dimCategory1_idx` ON `FamilyBudget_Test`.`dimSubcategory` (`CategoryKey` ASC);

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
DROP TABLE IF EXISTS `FamilyBudget_Test`.`Subtypes` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `FamilyBudget_Test`.`Subtypes` (
  `SubtypeId` TINYINT(4) NOT NULL,
  `SubtypeName` VARCHAR(50) NOT NULL,
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
    REFERENCES `FamilyBudget_Test`.`Months` (`MonthId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_factLineItem_DaysOfWeek1`
    FOREIGN KEY (`DayOfWeekId`)
    REFERENCES `FamilyBudget_Test`.`DaysOfWeek` (`DayOfWeekId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_factLineItem_dimSubcategory1`
    FOREIGN KEY (`SubcategoryKey`)
    REFERENCES `FamilyBudget_Test`.`dimSubcategory` (`SubcategoryKey`)
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
  CONSTRAINT `fk_factLineItem_Subtypes1`
    FOREIGN KEY (`SubtypeId`)
    REFERENCES `FamilyBudget_Test`.`Subtypes` (`SubtypeId`)
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
CREATE INDEX `fk_factLineItem_dimSubcategory1_idx` ON `FamilyBudget_Test`.`factLineItem` (`SubcategoryKey` ASC);

SHOW WARNINGS;
CREATE INDEX `fk_factLineItem_Statuses1_idx` ON `FamilyBudget_Test`.`factLineItem` (`StatusId` ASC);

SHOW WARNINGS;
CREATE INDEX `fk_factLineItem_dimPaymentMethod1_idx` ON `FamilyBudget_Test`.`factLineItem` (`PaymentMethodKey` ASC);

SHOW WARNINGS;
CREATE INDEX `fk_factLineItem_Subtypes1_idx` ON `FamilyBudget_Test`.`factLineItem` (`SubtypeId` ASC);

SHOW WARNINGS;
CREATE INDEX `fk_factLineItem_Types1_idx` ON `FamilyBudget_Test`.`factLineItem` (`TypeId` ASC);

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table  `FamilyBudget_Test`.`BudgetAllowances`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `FamilyBudget_Test`.`BudgetAllowances`;
SHOW WARNINGS;

CREATE TABLE IF NOT EXISTS `FamilyBudget_Test`.`BudgetAllowances` (
	`AccountName` VARCHAR(100) NOT NULL,
  `CategoryName` VARCHAR(100) NOT NULL,
	`SubcategoryName` VARCHAR(100) NOT NULL,
	`ReconciledAmount` DECIMAL(7,2) NOT NULL,
	`PendingAmount` DECIMAL(7,2) NOT NULL,
	`LatestTransactionDate` DATETIME NULL,
	PRIMARY KEY (`SubcategoryName`)
)
ENGINE = InnoDB;
SHOW WARNINGS;

-- -----------------------------------------------------
-- View  `FamilyBudget_Test`.`ActiveLineItems_PendingGoal`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `FamilyBudget_Test`.`ActiveLineItems_PendingGoal`;
SHOW WARNINGS;

CREATE VIEW `FamilyBudget_Test`.`ActiveLineItems_PendingGoal` AS
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
      `fli`.`StatusId` AS `StatusId`,
      `sc`.`IsGoal` AS `IsGoal`,
      `fli`.`IsTaxDeductible` AS `IsTaxDeductible`,
      `fli`.`LastUpdatedDate` AS `LastUpdatedDate`
    from
      (`factLineItem` `fli`
      join `dimSubcategory` `sc` ON (`fli`.`SubcategoryKey` = `sc`.`SubcategoryKey`)
      join `dimAccount` `a` ON (`sc`.`AccountKey` = `a`.`AccountKey`)
      join `dimCategory` `c` ON (`sc`.`CategoryKey` = `c`.`CategoryKey`)
      join `Months` `m` ON (`fli`.`MonthId` = `m`.`MonthId`)
      join `DaysOfWeek` `dow` ON (`fli`.`DayOfWeekId` = `dow`.`DayOfWeekId`)
      join `dimPaymentMethod` `pm` ON (`fli`.`PaymentMethodKey` = `pm`.`PaymentMethodKey`))
    where
      ((`fli`.`StatusId` in (1, 3))
      and (`sc`.`IsActive` = 1));
SHOW WARNINGS;

-- -----------------------------------------------------
-- View  `FamilyBudget_Test`.`ActiveLineItems_ReconciledPriorMonths_Condensed`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `FamilyBudget_Test`.`ActiveLineItems_ReconciledPriorMonths_Condensed`;
SHOW WARNINGS;

CREATE VIEW `FamilyBudget_Test`.`ActiveLineItems_ReconciledPriorMonths_Condensed` AS
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
      (case `fli`.`Quarter`
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
      0 AS `StatusId`,
      `sc`.`IsGoal` AS `IsGoal`,
      `fli`.`IsTaxDeductible` AS `IsTaxDeductible`,
      max(`fli`.`LastUpdatedDate`) AS `LastUpdatedDate`
    from
      (`factLineItem` `fli`
      join `dimSubcategory` `sc` ON ((`fli`.`SubcategoryKey` = `sc`.`SubcategoryKey`))
      join `dimCategory` `c` ON ((`sc`.`CategoryKey` = `c`.`CategoryKey`))
      join `dimAccount` `a` ON ((`sc`.`AccountKey` = `a`.`AccountKey`)))
      join `Months` `m` ON (`fli`.`MonthId` = `m`.`MonthId`)
    where
      ((`fli`.`TypeId` <> 3)
      and (`fli`.`StatusId` = 0)
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
-- View  `FamilyBudget_Test`.`ActiveLineItems_ReconciledCurrentMonth`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `FamilyBudget_Test`.`ActiveLineItems_ReconciledCurrentMonth`;
SHOW WARNINGS;

CREATE VIEW `FamilyBudget_Test`.`ActiveLineItems_ReconciledCurrentMonth` AS
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
      `fli`.`StatusId` AS `StatusId`,
      `sc`.`IsGoal` AS `IsGoal`,
      `fli`.`IsTaxDeductible` AS `IsTaxDeductible`,
      `fli`.`LastUpdatedDate` AS `LastUpdatedDate`
    from
        (`factLineItem` `fli`
        join `dimSubcategory` `sc` ON (`fli`.`SubcategoryKey` = `sc`.`SubcategoryKey`)
        join `dimAccount` `a` ON (`sc`.`AccountKey` = `a`.`AccountKey`)
        join `dimCategory` `c` ON (`sc`.`CategoryKey` = `c`.`CategoryKey`)
        join `Months` `m` ON (`fli`.`MonthId` = `m`.`MonthId`)
        join `DaysOfWeek` `dow` ON (`fli`.`DayOfWeekId` = `dow`.`DayOfWeekId`)
        join `dimPaymentMethod` `pm` ON (`fli`.`PaymentMethodKey` = `pm`.`PaymentMethodKey`))
    where
        ((`fli`.`TypeId` <> 3)
        and (`fli`.`StatusId` = 0)
        and (concat(`fli`.`MonthId`, `fli`.`Year`) = concat(month(NOW()), year(NOW())))
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
INSERT INTO Statuses (StatusId, StatusName) VALUES (3, 'Goal');

INSERT INTO Subtypes (SubtypeId, SubtypeName) VALUES (0, 'Debit');
INSERT INTO Subtypes (SubtypeId, SubtypeName) VALUES (1, 'Credit');
INSERT INTO Subtypes (SubtypeId, SubtypeName) VALUES (2, 'Goal');

INSERT INTO Types (TypeId, TypeName) VALUES (0, 'Expense');
INSERT INTO Types (TypeId, TypeName) VALUES (1, 'Allocation');
INSERT INTO Types (TypeId, TypeName) VALUES (2, 'Bucket Adjustment');
INSERT INTO Types (TypeId, TypeName) VALUES (3, 'Goal');

-- -----------------------------------------------------
-- Test Data
-- -----------------------------------------------------
INSERT INTO AuthorizedUser (Username, Password, IsActive) VALUES ('TestUser', 'Testing123!', 1);

INSERT INTO AccessToken (AuthorizedUser, Token, Expires) VALUES ('Static', '80FD82BD-45C0-4945-87B9-B2DDC4705E11', '2099-12-31 23:59:59');

INSERT INTO `dimpaymentmethod` 
VALUES ('2F7552F5-E69E-48B2-9FE6-B125BDE851E4','Test PM 1',1,'2015-04-21 12:43:53'),
       ('97824A38-B1DD-4885-B24B-A46E459A5AB0','Test PM 2',1,'2015-04-21 12:43:53'),
       ('A3C285C0-A027-418A-8810-3177A96054A3','Test PM 3',1,'2015-04-21 12:43:53'),
       ('D6A03F18-D7E9-4C09-9490-EA8AB4F29D5E','Test PM 4',1,'2015-04-21 12:43:53'),
       ('878BA1FC-4DC5-4219-A581-3A81A16EAAAE','Test PM 5',1,'2015-04-21 12:43:53'),
       ('0E021ACA-D3EB-40EC-8254-AA14185F4428','Test PM 6',0,'2015-04-21 12:43:53'),
       ('1117AFEB-3933-46C1-A6F1-7033DE501727','Test PM 7',1,'2015-04-21 12:43:53'),
       ('014F798B-EA55-49CA-A77F-FFB8A86D6827','Test PM 8',1,'2015-04-21 12:43:53'),
       ('66798E19-15F0-4AD8-800B-2CC5255F8C6F','Test PM 9',1,'2015-04-21 12:43:53'),
       ('6580A957-EC90-4987-B763-56F1072FD295','Test PM 10',1,'2015-04-21 12:43:53');

INSERT INTO `dimcategory` 
  VALUES ('94362FED-9C13-4894-A995-1002FF012E91','Test C 1',0,NOW()),
         ('809E0230-DDCE-4E5E-97DF-7C472D775537','Test C 2',0,NOW()),
         ('2B7F5E4C-3516-4496-B7EC-DA2F7B294AB0','Test C 3',0,NOW()),
         ('E3766774-A79E-4B36-A463-07F8B14A5547','Test C 4',0,NOW()),
         ('08EFE7F5-134F-413E-AE59-363B57AA89AE','Test C 5',0,NOW()),
         ('C52C39C5-96D9-49B2-8335-385DDFB836C1','Test C 6',0,NOW()),
         ('C436B374-3764-4CD0-A5DF-6A028BAF03E1','Test C 7',0,NOW()),
         ('A749EB2F-CBF3-4C07-A2DC-E61F6094A9D4','Test C 8',0,NOW()),
         ('24FF3283-8DA0-43D9-A18F-C2D7C2B865A0','Test C 9',0,NOW()),
         ('D66DDDF1-22B1-4747-924C-6916C0E16932','Test C 10',0,NOW());

INSERT INTO `dimaccount` 
  VALUES ('6AF4155F-289F-40BA-94D4-1A6E14F3990A','Checking',1,NOW()),
         ('BB7A1AEA-3B00-4C5D-B457-E53EC818D82E','Savings',1,NOW()),
         ('C5F1F81B-6FE6-41A5-8830-A5B6A19AB514','Checking 2',1,NOW());

INSERT INTO `dimsubcategory` 
VALUES ('4CC232A5-D705-48A0-A495-C0DCCC68FC59','08EFE7F5-134F-413E-AE59-363B57AA89AE','6AF4155F-289F-40BA-94D4-1A6E14F3990A','Test SC 1','TSC1',1,0,1,NOW()),
			 ('6FA0C20F-2E60-4463-9467-F768A90F29D1','D66DDDF1-22B1-4747-924C-6916C0E16932','BB7A1AEA-3B00-4C5D-B457-E53EC818D82E','Test SC 2','TSC2',1,0,0,NOW()),
			 ('B1F4EBEE-ABBD-4501-A11F-3FFA4FEAFF8C','2B7F5E4C-3516-4496-B7EC-DA2F7B294AB0','C5F1F81B-6FE6-41A5-8830-A5B6A19AB514','Test SC 3','TSC3',1,0,1,NOW()),
			 ('C62DE4AF-3A37-4B84-9883-FFF41F847700','809E0230-DDCE-4E5E-97DF-7C472D775537','6AF4155F-289F-40BA-94D4-1A6E14F3990A','Test SC 4','TSC4',1,0,0,NOW()),
			 ('EA079363-9B14-4C23-AF48-49FF0284A930','D66DDDF1-22B1-4747-924C-6916C0E16932','BB7A1AEA-3B00-4C5D-B457-E53EC818D82E','Test SC 5','TSC5',1,0,1,NOW()),
			 ('384E325E-ABE3-4490-9532-56B90E9A1A48','2B7F5E4C-3516-4496-B7EC-DA2F7B294AB0','C5F1F81B-6FE6-41A5-8830-A5B6A19AB514','Test SC 6','TSC6',1,0,0,NOW()),
			 ('302D08BD-D007-4B1F-96F0-111FCB1683BE','C436B374-3764-4CD0-A5DF-6A028BAF03E1','6AF4155F-289F-40BA-94D4-1A6E14F3990A','Test SC 7','TSC7',1,0,1,NOW()),
			 ('C58CABB1-8443-4BDF-898F-312DDFB74C6E','809E0230-DDCE-4E5E-97DF-7C472D775537','BB7A1AEA-3B00-4C5D-B457-E53EC818D82E','Test SC 8','TSC8',1,0,0,NOW()),
			 ('D88C9DA1-3788-404C-B3A0-72B371CC171F','D66DDDF1-22B1-4747-924C-6916C0E16932','C5F1F81B-6FE6-41A5-8830-A5B6A19AB514','Test SC 9','TSC9',1,0,1,NOW()),
			 ('8125DB24-54E0-4B28-80BB-858D6111D64D','08EFE7F5-134F-413E-AE59-363B57AA89AE','6AF4155F-289F-40BA-94D4-1A6E14F3990A','Test SC 10','TSC10',1,0,0,NOW()),
			 ('94615CEE-9857-4897-8C5A-64C788BCF29F','2B7F5E4C-3516-4496-B7EC-DA2F7B294AB0','BB7A1AEA-3B00-4C5D-B457-E53EC818D82E','Test SC 11','TSC11',1,0,1,NOW()),
			 ('6AC0FC1B-72C3-4595-B594-4117755A8307','2B7F5E4C-3516-4496-B7EC-DA2F7B294AB0','C5F1F81B-6FE6-41A5-8830-A5B6A19AB514','Test SC 12','TSC12',1,0,0,NOW()),
			 ('0BC45B85-D6ED-4A62-BD5E-A99A5A598432','24FF3283-8DA0-43D9-A18F-C2D7C2B865A0','6AF4155F-289F-40BA-94D4-1A6E14F3990A','Test SC 13','TSC13',1,0,1,NOW()),
			 ('81690BD3-8C3F-47D1-B874-433DB1482EF6','2B7F5E4C-3516-4496-B7EC-DA2F7B294AB0','BB7A1AEA-3B00-4C5D-B457-E53EC818D82E','Test SC 14','TSC14',1,0,0,NOW()),
			 ('FFE5A167-FBCE-452C-A5E0-7AA8BDDA41B0','94362FED-9C13-4894-A995-1002FF012E91','C5F1F81B-6FE6-41A5-8830-A5B6A19AB514','Test SC 15','TSC15',1,0,1,NOW()),
			 ('97E08362-5E98-4156-B3F1-80AFB8FCB9C5','809E0230-DDCE-4E5E-97DF-7C472D775537','6AF4155F-289F-40BA-94D4-1A6E14F3990A','Test SC 16','TSC16',1,0,0,NOW()),
			 ('39BA6ADF-6526-4D8A-A502-72468A9733F3','A749EB2F-CBF3-4C07-A2DC-E61F6094A9D4','BB7A1AEA-3B00-4C5D-B457-E53EC818D82E','Test SC 17','TSC17',1,0,0,NOW()),
			 ('5363AD11-B0EC-4ABF-85D2-26487A7963E7','2B7F5E4C-3516-4496-B7EC-DA2F7B294AB0','C5F1F81B-6FE6-41A5-8830-A5B6A19AB514','Test SC 18','TSC18',1,0,1,NOW()),
			 ('0EAB9B99-4BC4-4B54-8E08-024A8A4BCAD6','C436B374-3764-4CD0-A5DF-6A028BAF03E1','6AF4155F-289F-40BA-94D4-1A6E14F3990A','Test SC 19','TSC19',1,0,0,NOW()),
			 ('EF2DC499-64DE-4821-9CAD-DC5B4A3575A2','08EFE7F5-134F-413E-AE59-363B57AA89AE','BB7A1AEA-3B00-4C5D-B457-E53EC818D82E','Test SC 20','TSC20',1,0,1,NOW()),
			 ('3E51C340-43CE-4726-9CBD-76600E1B7DF1','24FF3283-8DA0-43D9-A18F-C2D7C2B865A0','C5F1F81B-6FE6-41A5-8830-A5B6A19AB514','Test SC 21','TSC21',1,0,0,NOW()),
			 ('A886199A-3203-4DA7-9042-DB5518D199E6','24FF3283-8DA0-43D9-A18F-C2D7C2B865A0','6AF4155F-289F-40BA-94D4-1A6E14F3990A','Test SC 22','TSC22',1,0,1,NOW()),
			 ('4F21EE9D-316F-40C2-8379-71F8D429FA11','2B7F5E4C-3516-4496-B7EC-DA2F7B294AB0','BB7A1AEA-3B00-4C5D-B457-E53EC818D82E','Test SC 23','TSC23',1,0,0,NOW()),
			 ('CA9625CF-8A39-4754-888B-E653203FA725','E3766774-A79E-4B36-A463-07F8B14A5547','C5F1F81B-6FE6-41A5-8830-A5B6A19AB514','Test SC 24','TSC24',1,1,1,NOW()),
			 ('90DC03F2-B110-4B0C-B879-3EA157555DDF','2B7F5E4C-3516-4496-B7EC-DA2F7B294AB0','6AF4155F-289F-40BA-94D4-1A6E14F3990A','Test SC 25','TSC25',1,0,0,NOW()),
			 ('43C269B0-6676-4B82-83CC-4BEB607AE442','809E0230-DDCE-4E5E-97DF-7C472D775537','BB7A1AEA-3B00-4C5D-B457-E53EC818D82E','Test SC 26','TSC26',1,0,1,NOW()),
			 ('FDE3F005-D3D4-4A10-B79E-112A011013CF','809E0230-DDCE-4E5E-97DF-7C472D775537','C5F1F81B-6FE6-41A5-8830-A5B6A19AB514','Test SC 27','TSC27',1,0,0,NOW()),
			 ('71D83AC4-0F57-4936-BB59-38C50E692E3F','08EFE7F5-134F-413E-AE59-363B57AA89AE','6AF4155F-289F-40BA-94D4-1A6E14F3990A','Test SC 28','TSC28',1,0,1,NOW()),
			 ('38BB2D2D-307D-4C5C-AB7C-93D34ABABD1D','08EFE7F5-134F-413E-AE59-363B57AA89AE','BB7A1AEA-3B00-4C5D-B457-E53EC818D82E','Test SC 29','TSC29',0,0,0,NOW()),
			 ('4ABE4F16-DA07-45EA-9345-1CA35CC37FA5','08EFE7F5-134F-413E-AE59-363B57AA89AE','C5F1F81B-6FE6-41A5-8830-A5B6A19AB514','Test SC 30','TSC30',1,0,1,NOW()),
			 ('BCB2E098-7FA5-432E-8E7A-B7EA4C510002','A749EB2F-CBF3-4C07-A2DC-E61F6094A9D4','6AF4155F-289F-40BA-94D4-1A6E14F3990A','Test SC 31','TSC31',1,0,0,NOW()),
			 ('E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','24FF3283-8DA0-43D9-A18F-C2D7C2B865A0','BB7A1AEA-3B00-4C5D-B457-E53EC818D82E','Test SC 32','TSC32',1,0,1,NOW()),
			 ('BBE64D1D-F8A1-46DE-8880-B700FA99D48C','24FF3283-8DA0-43D9-A18F-C2D7C2B865A0','C5F1F81B-6FE6-41A5-8830-A5B6A19AB514','Test SC 33','TSC33',1,0,0,NOW()),
			 ('8B5E5DC1-FC90-404E-A260-1F5155044E0F','D66DDDF1-22B1-4747-924C-6916C0E16932','6AF4155F-289F-40BA-94D4-1A6E14F3990A','Test SC 34','TSC34',1,0,1,NOW()),
			 ('74801902-27FC-47F6-B6DE-B6D956FCDF34','A749EB2F-CBF3-4C07-A2DC-E61F6094A9D4','BB7A1AEA-3B00-4C5D-B457-E53EC818D82E','Test SC 35','TSC35',1,0,0,NOW()),
			 ('5AA0B1F1-64AE-43C2-9F31-3B1248728799','E3766774-A79E-4B36-A463-07F8B14A5547','C5F1F81B-6FE6-41A5-8830-A5B6A19AB514','Test SC 36','TSC36',0,1,1,NOW()),
			 ('7B7A6AB7-3D74-421B-BD50-96C7A7AE02A8','C436B374-3764-4CD0-A5DF-6A028BAF03E1','6AF4155F-289F-40BA-94D4-1A6E14F3990A','Test SC 37','TSC37',1,0,0,NOW()),
			 ('1E6B1C48-31C9-4C7F-9C03-75BD81124A1D','2B7F5E4C-3516-4496-B7EC-DA2F7B294AB0','BB7A1AEA-3B00-4C5D-B457-E53EC818D82E','Test SC 38','TSC38',1,0,1,NOW()),
			 ('82B2A266-5181-45D7-8610-2F9213A397ED','809E0230-DDCE-4E5E-97DF-7C472D775537','C5F1F81B-6FE6-41A5-8830-A5B6A19AB514','Test SC 39','TSC39',1,0,0,NOW()),
			 ('9B26784E-67A3-4BBA-9DCE-D06E33ED84D3','D66DDDF1-22B1-4747-924C-6916C0E16932','6AF4155F-289F-40BA-94D4-1A6E14F3990A','Test SC 40','TSC40',1,0,1,NOW()),
			 ('20616ABA-8911-4523-ABA1-0E4E86EBCAF9','2B7F5E4C-3516-4496-B7EC-DA2F7B294AB0','BB7A1AEA-3B00-4C5D-B457-E53EC818D82E','Test SC 41','TSC41',1,0,0,NOW()),
			 ('C4CD23AC-5B64-4234-9515-9CC7EC92E577','24FF3283-8DA0-43D9-A18F-C2D7C2B865A0','C5F1F81B-6FE6-41A5-8830-A5B6A19AB514','Test SC 42','TSC42',1,0,1,NOW()),
			 ('2638253D-B50C-427F-B587-7703EB29BBBA','C436B374-3764-4CD0-A5DF-6A028BAF03E1','6AF4155F-289F-40BA-94D4-1A6E14F3990A','Test SC 43','TSC43',1,0,0,NOW());


INSERT INTO `factlineitem` 
VALUES ('D5C0BD73-DA78-46D1-9D7D-63C6D1204C1E',1,22,5,2015,'B1F4EBEE-ABBD-4501-A11F-3FFA4FEAFF8C','Test Line Item 1',-234.11,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('0DD7F0ED-04B4-48F5-9D5B-A2890CA8251D',1,5,2,2015,'BCB2E098-7FA5-432E-8E7A-B7EA4C510002','Test Line Item 2',-125.52,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,0,NOW()),
			 ('5510E0E1-8FF9-40C7-9500-59C6DFE83719',4,5,1,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 3',-294.68,0,0,2,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('C283B1FB-7A43-450B-A600-C01667E0572F',1,14,4,2015,'D88C9DA1-3788-404C-B3A0-72B371CC171F','Test Line Item 4',-170.82,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('4AD510BF-5A2F-4795-827F-178697ACC128',4,5,1,2015,'2638253D-B50C-427F-B587-7703EB29BBBA','Test Line Item 5',-79.9,0,0,2,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('1A395983-FF85-4C0E-A72B-DB08819D9C7C',2,3,3,2015,'FFE5A167-FBCE-452C-A5E0-7AA8BDDA41B0','Test Line Item 6',-536.98,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('FE32DE79-00B5-40FC-B1A4-392DEBCD7CB2',2,1,1,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 7',-178.43,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('00F35CFC-1404-413F-A705-DC18C5D7D9AD',1,6,3,2015,'5363AD11-B0EC-4ABF-85D2-26487A7963E7','Test Line Item 8',-311.61,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('64E0AED3-BC2D-4B18-8E8C-63C131F02747',3,14,7,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 9',-319.38,0,0,1,'D6A03F18-D7E9-4C09-9490-EA8AB4F29D5E',0,0,NOW()),
			 ('85C034FA-D5CC-43E6-AB45-69973C89DAC3',1,31,7,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 10',-139.04,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,1,NOW()),
			 ('B88804ED-88BB-4E88-B4A3-DD02BACFE540',1,5,2,2015,'BCB2E098-7FA5-432E-8E7A-B7EA4C510002','Test Line Item 11',-10.65,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,0,NOW()),
			 ('C5561399-D107-4158-9135-78F7E3A08005',1,1,5,2015,'A886199A-3203-4DA7-9042-DB5518D199E6','Test Line Item 12',1371.26,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('8A606A4A-198E-4198-A0C5-ECDADBE8077A',2,26,5,2015,'8B5E5DC1-FC90-404E-A260-1F5155044E0F','Test Line Item 13',-212.92,0,0,1,'D6A03F18-D7E9-4C09-9490-EA8AB4F29D5E',0,0,NOW()),
			 ('E7EAC77B-D70B-418E-A160-E40F43DEEE7B',3,3,3,2015,'94615CEE-9857-4897-8C5A-64C788BCF29F','Test Line Item 14',-14829.93,0,0,1,'6580A957-EC90-4987-B763-56F1072FD295',0,0,NOW()),
			 ('D760DCB0-B72B-4EF9-8E4D-94E129417ED3',1,28,4,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 15',-29.22,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,0,NOW()),
			 ('BA89803A-01E8-41E6-9E67-AF49CD293BFF',3,1,1,2015,'81690BD3-8C3F-47D1-B874-433DB1482EF6','Test Line Item 16',894,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('0AE7F749-AE03-485F-A4CC-04565CB43684',1,1,5,2015,'8125DB24-54E0-4B28-80BB-858D6111D64D','Test Line Item 17',88.89,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('19DD8194-DEA8-4F39-8C73-0DEFE8E422D6',1,1,5,2015,'5363AD11-B0EC-4ABF-85D2-26487A7963E7','Test Line Item 18',106.46,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('57FCEA11-075B-4993-8385-1E623E79F1D6',2,7,7,2015,'8B5E5DC1-FC90-404E-A260-1F5155044E0F','Test Line Item 19',-21.24,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('AAB7842A-3292-4380-A966-1C5B2E4AE346',3,8,1,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 20',-21.19,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('3C5619B1-2F31-41C6-904C-1B737B04CBF6',3,13,6,2015,'A886199A-3203-4DA7-9042-DB5518D199E6','Test Line Item 21',-162.72,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('EA964DFE-496A-4065-9496-1B16272259B1',2,23,2,2015,'A886199A-3203-4DA7-9042-DB5518D199E6','Test Line Item 22',-1.33,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('9D62ABB5-D1E8-4280-A017-FCC239F0C5E8',1,1,5,2015,'90DC03F2-B110-4B0C-B879-3EA157555DDF','Test Line Item 23',-164,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('47FE67C9-5311-41B4-9517-BFFE1F7B2778',4,3,6,2015,'4F21EE9D-316F-40C2-8379-71F8D429FA11','Test Line Item 24',-50.46,0,0,2,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('887CF834-62CB-4A86-8673-E6B8071AF35F',3,15,1,2015,'A886199A-3203-4DA7-9042-DB5518D199E6','Test Line Item 25',-65.26,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('EA88863F-EF17-4BDF-B5C2-674E971D3DAD',1,10,7,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 26',-179.97,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,0,NOW()),
			 ('B12B4307-AD9E-496B-92F0-58C28DA872AA',1,1,5,2015,'4CC232A5-D705-48A0-A495-C0DCCC68FC59','Test Line Item 27',-212.92,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,0,NOW()),
			 ('FA9BEC57-17CD-44C7-AD15-9CA165CCA016',1,23,6,2015,'C4CD23AC-5B64-4234-9515-9CC7EC92E577','Test Line Item 28',-62.81,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,0,NOW()),
			 ('899D3635-567E-4AFB-B641-8BAF903828B0',1,30,6,2015,'20616ABA-8911-4523-ABA1-0E4E86EBCAF9','Test Line Item 29',-946.32,0,0,1,'A3C285C0-A027-418A-8810-3177A96054A3',0,0,NOW()),
			 ('20BE431A-AD8D-4103-AAAA-DE0F17231553',2,13,6,2015,'71D83AC4-0F57-4936-BB59-38C50E692E3F','Test Line Item 30',-1596.9,0,0,1,'6580A957-EC90-4987-B763-56F1072FD295',0,0,NOW()),
			 ('554FDE21-75FE-48E8-A433-D8AC0C52DB2C',3,3,3,2015,'38BB2D2D-307D-4C5C-AB7C-93D34ABABD1D','Test Line Item 31',53.23,2,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('FA008353-4350-489E-A8B3-BA7022E51657',1,3,7,2015,'74801902-27FC-47F6-B6DE-B6D956FCDF34','Test Line Item 32',-574.4,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('859B41CE-B051-450B-8040-E6781A6CCFE8',3,31,3,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 33',464.06,2,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('8D020ED3-F778-4AEB-A5F7-EE3168B3B8EF',4,8,4,2015,'BBE64D1D-F8A1-46DE-8880-B700FA99D48C','Test Line Item 34',483.65,0,1,2,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('CF1325E6-FEF0-43BB-BF6B-5422E86E8090',3,8,1,2015,'5AA0B1F1-64AE-43C2-9F31-3B1248728799','Test Line Item 35',-237.62,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('BAA43E20-FCEF-4EB8-A29F-C0F02D4198DC',3,21,7,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 36',-162.19,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('BDF33B45-481D-4BAC-A614-E127638548E9',2,14,7,2015,'8B5E5DC1-FC90-404E-A260-1F5155044E0F','Test Line Item 37',-53.23,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('83ED3619-3135-47B4-B471-5B6703D3B577',3,25,4,2015,'39BA6ADF-6526-4D8A-A502-72468A9733F3','Test Line Item 38',-218.46,2,0,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('FE22ED71-07A4-4383-AC33-5E6513995FC7',4,3,6,2015,'4F21EE9D-316F-40C2-8379-71F8D429FA11','Test Line Item 39',-58.23,0,0,2,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('24E53421-71C2-4811-B589-EAF4388F1F31',3,31,3,2015,'39BA6ADF-6526-4D8A-A502-72468A9733F3','Test Line Item 40',-464.06,2,0,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('51862451-BC1E-4E6C-BAB6-60666579698C',1,16,6,2015,'BCB2E098-7FA5-432E-8E7A-B7EA4C510002','Test Line Item 41',-226.49,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('B76262C9-D5F1-4007-9716-623A828376F6',4,3,6,2015,'39BA6ADF-6526-4D8A-A502-72468A9733F3','Test Line Item 42',-93.15,0,0,2,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('2E60E5D4-4170-4B17-B5F8-9893C2ED9FA9',1,9,6,2015,'BCB2E098-7FA5-432E-8E7A-B7EA4C510002','Test Line Item 43',-582.55,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('DC492B85-2BB6-4FD0-813D-E05C1D787721',4,19,1,2015,'A886199A-3203-4DA7-9042-DB5518D199E6','Test Line Item 44',-11.98,0,0,2,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('E8752AD9-A68B-4A9B-AC5E-BA316B514727',2,2,2,2015,'384E325E-ABE3-4490-9532-56B90E9A1A48','Test Line Item 45',-676.02,0,0,1,'6580A957-EC90-4987-B763-56F1072FD295',0,0,NOW()),
			 ('D88901FF-2BDC-4335-95F6-B21E03E9A7EE',3,15,1,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 46',-106.83,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('B376290E-9AF2-415F-86FD-A2D6FE2E8EE1',2,28,7,2015,'5AA0B1F1-64AE-43C2-9F31-3B1248728799','Test Line Item 47',47.91,2,1,1,'2F7552F5-E69E-48B2-9FE6-B125BDE851E4',0,0,NOW()),
			 ('2C82F1B2-2308-4B01-B8E6-B00995549402',4,1,4,2015,'90DC03F2-B110-4B0C-B879-3EA157555DDF','Test Line Item 48',691.99,1,1,2,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('7C754D9A-0F93-4C92-B469-185032986E6B',1,12,2,2015,'8B5E5DC1-FC90-404E-A260-1F5155044E0F','Test Line Item 49',-414.13,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('5CF8213C-01AE-49BD-8A0E-274AF8893B49',2,15,1,2015,'39BA6ADF-6526-4D8A-A502-72468A9733F3','Test Line Item 50',-406.09,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('09A56E1D-E5A9-4AA2-8099-628FDE499A69',2,28,7,2015,'0BC45B85-D6ED-4A62-BD5E-A99A5A598432','Test Line Item 51',-7.77,2,0,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('79B03182-6240-4C1A-A584-2C005741F719',2,16,2,2015,'4F21EE9D-316F-40C2-8379-71F8D429FA11','Test Line Item 52',-116.04,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('678F6231-AFFD-4916-A4A3-8C4ADACF4CE1',1,11,1,2015,'BCB2E098-7FA5-432E-8E7A-B7EA4C510002','Test Line Item 53',-1197.67,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('47209328-C953-4E75-A5B6-711D7E45675B',4,17,6,2015,'8B5E5DC1-FC90-404E-A260-1F5155044E0F','Test Line Item 54',-26.56,0,0,2,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('166D9CB1-722C-40A3-A40E-6BBBBB171F39',4,11,7,2015,'A886199A-3203-4DA7-9042-DB5518D199E6','Test Line Item 55',-95.6,0,0,2,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('B8D735F7-7B28-42D0-91B8-3C1B589E12FF',4,1,4,2015,'8125DB24-54E0-4B28-80BB-858D6111D64D','Test Line Item 56',88.89,1,1,2,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('F522E2E8-241E-4130-BB32-A1A8587E36CD',3,31,3,2015,'74801902-27FC-47F6-B6DE-B6D956FCDF34','Test Line Item 57',21427.63,2,1,1,'2F7552F5-E69E-48B2-9FE6-B125BDE851E4',0,0,NOW()),
			 ('5E455988-DDB0-480B-8C38-4844C3625952',2,14,7,2015,'A886199A-3203-4DA7-9042-DB5518D199E6','Test Line Item 58',-191.47,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('5DF4D5C8-DD75-404B-A74C-FB2B88327770',2,21,7,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 59',-91.77,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('AD9ACE2F-8A1A-4391-AD4D-1280084E5F17',3,21,7,2015,'A886199A-3203-4DA7-9042-DB5518D199E6','Test Line Item 60',-53.6,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('A8281F6E-37A3-46D9-B29A-E20BE36D9527',4,1,4,2015,'302D08BD-D007-4B1F-96F0-111FCB1683BE','Test Line Item 61',0,1,0,2,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('B9C78209-B6D8-468B-8AE9-0223E6B70DCD',1,3,7,2015,'A886199A-3203-4DA7-9042-DB5518D199E6','Test Line Item 62',-78.51,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,0,NOW()),
			 ('17943C7E-4D98-4A7A-AAAD-096988093671',1,24,7,2015,'97E08362-5E98-4156-B3F1-80AFB8FCB9C5','Test Line Item 63',-638.76,0,0,1,'D6A03F18-D7E9-4C09-9490-EA8AB4F29D5E',0,0,NOW()),
			 ('3133AEB8-D8CB-4C7C-AA7A-7E9253EFC06D',3,1,1,2015,'4F21EE9D-316F-40C2-8379-71F8D429FA11','Test Line Item 64',461.88,2,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('C626E7DD-C88D-4EBC-BF56-39295F2CFC34',1,1,5,2015,'7B7A6AB7-3D74-421B-BD50-96C7A7AE02A8','Test Line Item 65',443.3,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('AF46A4D8-92FC-42EE-A9A6-588215E14F05',1,15,5,2015,'D88C9DA1-3788-404C-B3A0-72B371CC171F','Test Line Item 66',-254.33,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,0,NOW()),
			 ('52607B2B-B77F-4532-8237-ADA40D8BF30B',4,16,5,2015,'A886199A-3203-4DA7-9042-DB5518D199E6','Test Line Item 67',-211.96,0,0,2,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('11D2C839-3875-4974-9EEA-C7332CA1FF7B',2,16,2,2015,'20616ABA-8911-4523-ABA1-0E4E86EBCAF9','Test Line Item 68',-814.74,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('0BB05E2B-35ED-49FB-8DB4-A66A280FD7E4',4,1,4,2015,'BCB2E098-7FA5-432E-8E7A-B7EA4C510002','Test Line Item 69',7984.5,1,1,2,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('D8AC651C-22F8-439B-AA70-90103D35C3FF',1,1,5,2015,'2638253D-B50C-427F-B587-7703EB29BBBA','Test Line Item 70',19.59,2,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('519E4E7C-41AA-4610-8E67-2D78E86FEB27',3,1,1,2015,'9B26784E-67A3-4BBA-9DCE-D06E33ED84D3','Test Line Item 71',0,1,0,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('020B671B-722D-40BC-9064-0DF0389C06BC',2,16,2,2015,'39BA6ADF-6526-4D8A-A502-72468A9733F3','Test Line Item 72',-233.09,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('F4DA6630-FF6E-4878-B11B-6BFE3F29B566',1,5,2,2015,'BCB2E098-7FA5-432E-8E7A-B7EA4C510002','Test Line Item 73',-505.68,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('093AB0DB-E5D2-4CE5-8E53-C2502E285D5F',1,1,5,2015,'4CC232A5-D705-48A0-A495-C0DCCC68FC59','Test Line Item 74',212.92,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('B6ECFC9A-0151-4BB1-BD04-EC1AEDD62489',4,1,4,2015,'3E51C340-43CE-4726-9CBD-76600E1B7DF1','Test Line Item 75',266.15,1,1,2,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('6416715F-39CE-414D-B0A3-0B4674E7CD5D',1,8,5,2015,'43C269B0-6676-4B82-83CC-4BEB607AE442','Test Line Item 76',-850.67,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('2A6FFF9D-F9F0-4167-9F47-3E4090C81E07',1,18,1,2015,'BCB2E098-7FA5-432E-8E7A-B7EA4C510002','Test Line Item 77',-445.96,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('940BE207-68E1-4A69-9E06-F422D971A4A1',1,1,5,2015,'94615CEE-9857-4897-8C5A-64C788BCF29F','Test Line Item 78',14829.93,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('D19CFB6D-8814-45C4-9E7D-8BFB1E18D14B',1,1,5,2015,'82B2A266-5181-45D7-8610-2F9213A397ED','Test Line Item 79',420.46,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('98789287-C687-4720-9FED-7B62D4A8E1DA',2,15,1,2015,'BBE64D1D-F8A1-46DE-8880-B700FA99D48C','Test Line Item 80',-87.3,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('297E10D5-9B7C-47CA-A54F-424868E201CF',2,28,7,2015,'BCB2E098-7FA5-432E-8E7A-B7EA4C510002','Test Line Item 81',27.95,0,1,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('8C2ECBB4-21B0-4DBF-9D6C-A7C12907FED8',3,31,3,2015,'39BA6ADF-6526-4D8A-A502-72468A9733F3','Test Line Item 82',-115.99,2,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('261953B9-EC11-4081-BD95-6A1EB74F410C',3,1,1,2015,'A886199A-3203-4DA7-9042-DB5518D199E6','Test Line Item 83',-79.74,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('F7BBC14F-146D-45E4-ABF9-8B1FB2823FE6',3,1,1,2015,'BCB2E098-7FA5-432E-8E7A-B7EA4C510002','Test Line Item 84',9931.33,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('D5253EEC-3728-49AB-A713-E4E4BAB77547',3,1,1,2015,'EA079363-9B14-4C23-AF48-49FF0284A930','Test Line Item 85',0,1,0,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('D4B535DD-D3FC-4B8A-884A-4336F99661FA',2,1,1,2015,'4ABE4F16-DA07-45EA-9345-1CA35CC37FA5','Test Line Item 86',851.68,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('DCFE9902-228C-47DC-9355-56555D86FE2E',3,3,3,2015,'38BB2D2D-307D-4C5C-AB7C-93D34ABABD1D','Test Line Item 87',-2262.27,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('08A34182-7600-4F7A-B05C-70808EF9D307',1,1,5,2015,'A886199A-3203-4DA7-9042-DB5518D199E6','Test Line Item 88',-188.86,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,0,NOW()),
			 ('E803F4B2-7073-48DB-8973-3B15242D9EBC',3,1,1,2015,'43C269B0-6676-4B82-83CC-4BEB607AE442','Test Line Item 89',266.15,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('405D3E45-944F-454F-9A90-1A4EF2BED75B',2,8,1,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 90',-227.93,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('58860FC0-5979-4552-B827-74A14DBC1E83',3,25,4,2015,'4F21EE9D-316F-40C2-8379-71F8D429FA11','Test Line Item 91',218.46,2,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('C1FBEE41-1201-43CA-A451-3F1B2870B64B',3,1,1,2015,'4CC232A5-D705-48A0-A495-C0DCCC68FC59','Test Line Item 92',212.92,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('2CDDF19D-351F-43B8-8F93-2C7CB8C6F30B',1,1,5,2015,'2638253D-B50C-427F-B587-7703EB29BBBA','Test Line Item 93',798.45,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('DD76F30F-59F7-42A1-90F1-62A05FFA61CD',1,10,7,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 94',-212.92,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,0,NOW()),
			 ('B357F4A1-C9CD-4DAA-932F-D5385B97B36C',3,31,3,2015,'39BA6ADF-6526-4D8A-A502-72468A9733F3','Test Line Item 95',2266.43,2,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('C5B15DC0-CA84-48CD-94F4-4FEC7E38645B',4,9,5,2015,'82B2A266-5181-45D7-8610-2F9213A397ED','Test Line Item 96',-420.46,0,0,2,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('5B72E6E8-F70B-4F24-B47F-7F953E11944B',3,1,1,2015,'8B5E5DC1-FC90-404E-A260-1F5155044E0F','Test Line Item 97',-226.28,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('D98CE1C3-B567-454E-AD73-90BE4DFE057E',1,1,5,2015,'4ABE4F16-DA07-45EA-9345-1CA35CC37FA5','Test Line Item 98',-319.38,0,0,1,'D6A03F18-D7E9-4C09-9490-EA8AB4F29D5E',0,0,NOW()),
			 ('88B5AB35-786E-4CD9-B246-93B90432BE2F',2,28,7,2015,'BCB2E098-7FA5-432E-8E7A-B7EA4C510002','Test Line Item 99',58.71,0,1,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('F795008D-0CB4-44CE-9E43-56414D3CE270',2,12,5,2015,'5AA0B1F1-64AE-43C2-9F31-3B1248728799','Test Line Item 100',292.76,2,1,1,'2F7552F5-E69E-48B2-9FE6-B125BDE851E4',0,0,NOW()),
			 ('AD723CDE-AC8D-4509-B547-43ADEE10E00C',2,1,1,2015,'A886199A-3203-4DA7-9042-DB5518D199E6','Test Line Item 101',-431.06,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('40E461F4-010B-4FF5-8CD2-CA48A136821A',1,16,6,2015,'9B26784E-67A3-4BBA-9DCE-D06E33ED84D3','Test Line Item 102',-45.19,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('100F98B3-7458-4A7C-A0EC-53A75E72178C',4,1,4,2015,'BCB2E098-7FA5-432E-8E7A-B7EA4C510002','Test Line Item 103',260.83,2,1,2,'2F7552F5-E69E-48B2-9FE6-B125BDE851E4',0,0,NOW()),
			 ('235EC539-FEBC-418F-937C-B8B06C39CC50',2,1,1,2015,'4CC232A5-D705-48A0-A495-C0DCCC68FC59','Test Line Item 104',212.92,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('54EF7BCF-CF0E-4F29-8D35-FEAAB8F5CA62',2,28,7,2015,'BCB2E098-7FA5-432E-8E7A-B7EA4C510002','Test Line Item 105',-348.87,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('B3E17F81-E8B9-4BD9-A249-721849554790',2,1,1,2015,'2638253D-B50C-427F-B587-7703EB29BBBA','Test Line Item 106',798.45,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('75E9D16F-28B6-494D-BD46-0DABC9C588FE',3,1,1,2015,'4ABE4F16-DA07-45EA-9345-1CA35CC37FA5','Test Line Item 107',851.68,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('0FA3D1C8-236D-493E-9E1D-AD9FE9A94C69',3,13,6,2015,'A886199A-3203-4DA7-9042-DB5518D199E6','Test Line Item 108',-22.36,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('68DE7852-05B9-41A1-A0DA-E0B7F1563438',4,10,6,2015,'7B7A6AB7-3D74-421B-BD50-96C7A7AE02A8','Test Line Item 109',-443.3,0,0,2,'A3C285C0-A027-418A-8810-3177A96054A3',0,0,NOW()),
			 ('134B72FB-B1A2-4923-808F-7B0E6297C624',1,22,5,2015,'A886199A-3203-4DA7-9042-DB5518D199E6','Test Line Item 110',-174.06,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,0,NOW()),
			 ('E9B5BFF3-3526-4023-87A6-4B4890C3C3C5',1,8,5,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 111',-76.97,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,0,NOW()),
			 ('8166BF94-D7D6-44C3-9101-12B3B9DAC21F',2,1,1,2015,'384E325E-ABE3-4490-9532-56B90E9A1A48','Test Line Item 112',676.02,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('D45A4FC3-A495-498C-8EF3-1776D56C88C2',2,15,1,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 113',-50.04,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('501D50F7-9439-42D7-ADE9-00C8C22DD233',1,27,3,2015,'4ABE4F16-DA07-45EA-9345-1CA35CC37FA5','Test Line Item 114',-109.65,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,0,NOW()),
			 ('2AD73078-9711-4724-BD28-839EF6A0610D',1,1,5,2015,'BBE64D1D-F8A1-46DE-8880-B700FA99D48C','Test Line Item 115',798.45,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('6FFBCF5F-B888-4DC1-A45F-3EE0EBF37AB1',3,8,1,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 116',-175.5,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('E14A48C7-4701-4C2B-A997-AD50A2B510DD',1,4,1,2015,'2638253D-B50C-427F-B587-7703EB29BBBA','Test Line Item 117',-181.46,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,0,NOW()),
			 ('CA2967CF-CF6B-48D9-8A56-6103E252CB54',1,1,5,2015,'0EAB9B99-4BC4-4B54-8E08-024A8A4BCAD6','Test Line Item 118',1755.9,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('CF5AFB3E-BAC2-469C-A1CE-A50C6CA63858',1,12,2,2015,'81690BD3-8C3F-47D1-B874-433DB1482EF6','Test Line Item 119',-1027.07,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,1,NOW()),
			 ('14124E5C-074A-4F2E-9B61-386F2F901282',1,1,5,2015,'C4CD23AC-5B64-4234-9515-9CC7EC92E577','Test Line Item 120',-31.94,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,0,NOW()),
			 ('884205E5-99E7-478C-93FF-34030B4B6EEC',2,1,1,2015,'71D83AC4-0F57-4936-BB59-38C50E692E3F','Test Line Item 121',1596.9,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('A8B36D82-F5E9-4F37-9692-C025F3ACC551',4,1,4,2015,'A886199A-3203-4DA7-9042-DB5518D199E6','Test Line Item 122',1996.12,1,1,2,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('200988A1-1927-40EB-A9EA-3EC63075CF76',4,19,1,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 123',-98.21,0,0,2,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('547B6D3D-3406-45FC-A9C7-56AE3EEB7EE2',3,25,4,2015,'A886199A-3203-4DA7-9042-DB5518D199E6','Test Line Item 124',-106.73,2,0,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('F00FCC7E-3B01-434B-AE55-001179649E78',2,21,7,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 125',-212.92,0,0,1,'D6A03F18-D7E9-4C09-9490-EA8AB4F29D5E',0,0,NOW()),
			 ('786A0F59-9FD9-4885-9F96-759E08F608CF',3,9,2,2015,'82B2A266-5181-45D7-8610-2F9213A397ED','Test Line Item 126',-420.46,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('BBAE7681-5E73-42DC-8357-987E455188C4',2,2,2,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 127',-265.35,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('139EFEE2-8D9A-4F80-A5B9-8896AEFDDB49',3,1,1,2015,'7B7A6AB7-3D74-421B-BD50-96C7A7AE02A8','Test Line Item 128',438.56,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('54891EAF-6351-4A23-9F05-4CA58448E26C',3,1,1,2015,'C4CD23AC-5B64-4234-9515-9CC7EC92E577','Test Line Item 129',-239.53,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('C9D9FA5F-C135-4F68-B06D-546B0E8924A7',4,1,4,2015,'EA079363-9B14-4C23-AF48-49FF0284A930','Test Line Item 130',1064.6,1,1,2,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('D8E0DCFF-0657-42F6-8C0F-5D86D4AABE9C',1,1,5,2015,'D88C9DA1-3788-404C-B3A0-72B371CC171F','Test Line Item 131',69.36,2,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('26F66E0E-81A5-43DF-9075-A4A2FE503BCB',4,15,4,2015,'71D83AC4-0F57-4936-BB59-38C50E692E3F','Test Line Item 132',-1596.9,0,0,2,'6580A957-EC90-4987-B763-56F1072FD295',0,0,NOW()),
			 ('8A4224E2-209C-421E-AE70-42110F7A9442',3,20,6,2015,'C4CD23AC-5B64-4234-9515-9CC7EC92E577','Test Line Item 133',-319.38,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('6B2D8433-06D3-4AFB-B1F0-2316A8BB2B7E',4,8,4,2015,'BBE64D1D-F8A1-46DE-8880-B700FA99D48C','Test Line Item 134',-483.65,0,0,2,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('FD9D4694-9563-4A9C-B62C-CB99537B0FD4',2,1,1,2015,'C4CD23AC-5B64-4234-9515-9CC7EC92E577','Test Line Item 135',-319.38,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('22103AA6-E770-4662-9EAD-298CF20CED1F',2,26,5,2015,'A886199A-3203-4DA7-9042-DB5518D199E6','Test Line Item 136',-37.26,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('ECEEB497-8279-4AF7-8569-FAF7AAD9027C',4,1,4,2015,'FDE3F005-D3D4-4A10-B79E-112A011013CF','Test Line Item 137',106.46,1,1,2,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('D68912AF-614D-488F-AF92-847C58887894',4,9,5,2015,'74801902-27FC-47F6-B6DE-B6D956FCDF34','Test Line Item 138',691.99,2,1,2,'2F7552F5-E69E-48B2-9FE6-B125BDE851E4',0,0,NOW()),
			 ('DB6B58C1-95E5-4E66-9B6E-30A61479AC27',3,31,3,2015,'74801902-27FC-47F6-B6DE-B6D956FCDF34','Test Line Item 139',-53715.5,2,0,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('FDAA17CB-F763-4725-926B-41A53FC4F0F3',4,1,4,2015,'C58CABB1-8443-4BDF-898F-312DDFB74C6E','Test Line Item 140',186.3,1,1,2,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('CB4CA326-3738-4E7F-90E7-D0B8D1B3C765',4,3,6,2015,'8B5E5DC1-FC90-404E-A260-1F5155044E0F','Test Line Item 141',-21.24,0,0,2,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('97FA908D-8D65-4B9D-8271-B8F6605715C0',3,2,2,2015,'A886199A-3203-4DA7-9042-DB5518D199E6','Test Line Item 142',-86.92,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('C23CDE85-5D2A-4454-9D9F-9311DAE93506',4,19,1,2015,'2638253D-B50C-427F-B587-7703EB29BBBA','Test Line Item 143',-178.37,0,0,2,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('0441F86B-50F2-4916-AB94-70717AC81D2D',4,12,1,2015,'BBE64D1D-F8A1-46DE-8880-B700FA99D48C','Test Line Item 144',-93.21,0,0,2,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('227293A4-C2E7-407C-9A24-CD294622A481',2,1,1,2015,'3E51C340-43CE-4726-9CBD-76600E1B7DF1','Test Line Item 145',266.15,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('97D69771-9A43-4767-9D2F-AC8ACD6BC0E2',3,26,5,2015,'4F21EE9D-316F-40C2-8379-71F8D429FA11','Test Line Item 146',532.3,2,1,1,'2F7552F5-E69E-48B2-9FE6-B125BDE851E4',0,0,NOW()),
			 ('C63AA61E-36CD-4FF6-8F84-9435AD6A80F7',4,12,1,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 147',-418.12,0,0,2,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('2E00C7F3-490B-410F-9CF1-03380341F173',4,19,1,2015,'A886199A-3203-4DA7-9042-DB5518D199E6','Test Line Item 148',-15.97,0,0,2,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,1,NOW()),
			 ('1702C991-DEEA-4FF5-84DD-4F4027611743',1,1,5,2015,'20616ABA-8911-4523-ABA1-0E4E86EBCAF9','Test Line Item 149',638.76,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('9F4A78B2-2599-417C-9DCE-266B7E6EBEA5',3,30,2,2015,'3E51C340-43CE-4726-9CBD-76600E1B7DF1','Test Line Item 150',-53.23,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('6509D9AD-1904-4FA3-8AB4-9514184F62D0',2,1,1,2015,'82B2A266-5181-45D7-8610-2F9213A397ED','Test Line Item 151',420.46,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('F209401F-19C4-44AC-81A1-628FB662BBF6',3,1,1,2015,'97E08362-5E98-4156-B3F1-80AFB8FCB9C5','Test Line Item 152',0,1,0,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('538302BC-1207-413A-9BF3-E6DCC49DFA3C',1,16,6,2015,'BCB2E098-7FA5-432E-8E7A-B7EA4C510002','Test Line Item 153',-532.3,0,0,1,'D6A03F18-D7E9-4C09-9490-EA8AB4F29D5E',0,0,NOW()),
			 ('9FD7A6D4-986E-492B-AC6D-C2E7389221F8',2,1,1,2015,'D88C9DA1-3788-404C-B3A0-72B371CC171F','Test Line Item 154',532.3,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('D24C9096-9A64-4A65-809B-92A87A690701',1,15,5,2015,'BBE64D1D-F8A1-46DE-8880-B700FA99D48C','Test Line Item 155',-106.46,0,0,1,'D6A03F18-D7E9-4C09-9490-EA8AB4F29D5E',0,0,NOW()),
			 ('53E6EC66-CAA5-4404-A298-5AD9F14798A5',1,22,5,2015,'9B26784E-67A3-4BBA-9DCE-D06E33ED84D3','Test Line Item 156',-10.43,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,0,NOW()),
			 ('8B04431B-61D9-4D0E-84EA-54F2A6D70609',2,1,1,2015,'0BC45B85-D6ED-4A62-BD5E-A99A5A598432','Test Line Item 157',638.76,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('267E31F6-60C2-4BB9-91AF-9D4A4D16B7FB',1,12,2,2015,'7B7A6AB7-3D74-421B-BD50-96C7A7AE02A8','Test Line Item 158',-443.3,0,0,1,'A3C285C0-A027-418A-8810-3177A96054A3',0,0,NOW()),
			 ('60713F6B-2109-471A-A7C7-B09A36BD27B1',4,3,6,2015,'A886199A-3203-4DA7-9042-DB5518D199E6','Test Line Item 159',-168.63,0,0,2,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('B2B775CD-7A82-41E2-9973-35EAF8250FBA',3,27,6,2015,'A886199A-3203-4DA7-9042-DB5518D199E6','Test Line Item 160',-434.41,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('E2DF8A31-724B-49D8-9317-F1B188119EF3',4,5,1,2015,'A886199A-3203-4DA7-9042-DB5518D199E6','Test Line Item 161',-64.46,0,0,2,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('2B0886DD-DAD1-4AEB-9719-F89B74987D98',1,9,6,2015,'A886199A-3203-4DA7-9042-DB5518D199E6','Test Line Item 162',-312.57,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('7A879B6C-5063-4E81-9C83-5EE231020CE3',3,25,4,2015,'BCB2E098-7FA5-432E-8E7A-B7EA4C510002','Test Line Item 163',-778.54,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('0676D1D0-ABE3-40AA-8F4A-7AE86DC9F0A5',1,18,1,2015,'BCB2E098-7FA5-432E-8E7A-B7EA4C510002','Test Line Item 164',-26.61,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('7C8645D6-8885-4959-816F-7396B1821A57',2,14,7,2015,'A886199A-3203-4DA7-9042-DB5518D199E6','Test Line Item 165',-21.45,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('34102159-8821-465A-B153-2409101BA616',4,4,7,2015,'A886199A-3203-4DA7-9042-DB5518D199E6','Test Line Item 166',-166.34,0,0,2,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('38D000E9-A4FE-45F5-B178-66927E5F8FE0',1,31,7,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 167',-53.12,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,0,NOW()),
			 ('E905198E-2888-46C2-8914-6A23C14BDD62',2,1,1,2015,'20616ABA-8911-4523-ABA1-0E4E86EBCAF9','Test Line Item 168',638.76,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('34FE1D40-6CA1-4AAC-9512-707D2517D4BA',3,15,1,2015,'39BA6ADF-6526-4D8A-A502-72468A9733F3','Test Line Item 169',-115.88,2,0,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('078264F2-C7A7-4EE2-B3FE-993FA8440E6F',3,1,1,2015,'90DC03F2-B110-4B0C-B879-3EA157555DDF','Test Line Item 170',691.99,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('2E9233DF-0AAC-45BB-AE1B-BD9E6C5EF588',1,20,3,2015,'A886199A-3203-4DA7-9042-DB5518D199E6','Test Line Item 171',-96.08,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,0,NOW()),
			 ('86B20312-68A3-40C2-B1CD-9B126CE2D829',1,24,7,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 172',-34.55,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,0,NOW()),
			 ('D3BA279E-5066-4358-B937-C938EA59BFA7',1,14,4,2015,'4F21EE9D-316F-40C2-8379-71F8D429FA11','Test Line Item 173',-26.03,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,0,NOW()),
			 ('41639297-ED99-48E0-8EBC-39B28A7D69FE',2,7,7,2015,'C4CD23AC-5B64-4234-9515-9CC7EC92E577','Test Line Item 174',-239.53,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('50A49747-1887-488B-ABF8-D7258BDFB7B6',1,1,5,2015,'20616ABA-8911-4523-ABA1-0E4E86EBCAF9','Test Line Item 175',728.61,2,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('D36329FD-C7BB-4A51-839E-424755820B3A',1,1,5,2015,'1E6B1C48-31C9-4C7F-9C03-75BD81124A1D','Test Line Item 176',150.96,2,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('F3332656-D848-4765-AA36-FF13464B5904',3,17,3,2015,'A886199A-3203-4DA7-9042-DB5518D199E6','Test Line Item 177',-42.58,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('FEB5E011-33ED-4B8F-9A8F-53EF0CD5FB94',1,18,1,2015,'BCB2E098-7FA5-432E-8E7A-B7EA4C510002','Test Line Item 178',-95.44,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('D3D5309A-7078-4858-AD1C-CDC2C9586263',1,16,6,2015,'BCB2E098-7FA5-432E-8E7A-B7EA4C510002','Test Line Item 179',-506.48,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('B9A741E2-76CA-4654-914E-1B7701FF031B',3,10,3,2015,'90DC03F2-B110-4B0C-B879-3EA157555DDF','Test Line Item 180',-420.25,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('56796110-BF36-43DB-B9E7-BC3366CFF96E',4,1,4,2015,'BBE64D1D-F8A1-46DE-8880-B700FA99D48C','Test Line Item 181',106.46,1,1,2,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('239D9869-FA53-4EEC-8886-6DE076E0E8E4',1,1,5,2015,'74801902-27FC-47F6-B6DE-B6D956FCDF34','Test Line Item 182',1342.57,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('04C2BF4B-87C7-44C9-847F-FF3338534B24',1,1,5,2015,'4ABE4F16-DA07-45EA-9345-1CA35CC37FA5','Test Line Item 183',547.63,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('30368896-6B4E-479A-99C8-2D9B346BEFE4',4,1,4,2015,'EF2DC499-64DE-4821-9CAD-DC5B4A3575A2','Test Line Item 184',53.23,1,1,2,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('BFCC0CD8-D68B-4033-B8F6-C25CF38D5233',2,21,7,2015,'6FA0C20F-2E60-4463-9467-F768A90F29D1','Test Line Item 185',-75.37,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('0BCE5EC1-EAEC-40DB-A7EE-0BBB8CC7C553',1,2,6,2015,'94615CEE-9857-4897-8C5A-64C788BCF29F','Test Line Item 186',-14829.93,0,0,1,'6580A957-EC90-4987-B763-56F1072FD295',0,0,NOW()),
			 ('8EBDCE48-DB4C-47C1-9ED0-5C14C6B88036',4,6,2,2015,'6AC0FC1B-72C3-4595-B594-4117755A8307','Test Line Item 187',-20287.81,0,0,2,'6580A957-EC90-4987-B763-56F1072FD295',0,0,NOW()),
			 ('F907598E-DDDD-45BA-9789-DF477C61423F',2,28,7,2015,'BCB2E098-7FA5-432E-8E7A-B7EA4C510002','Test Line Item 188',558.91,0,1,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('38987949-7B56-409B-B82C-D39CBACC7270',2,11,4,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 189',-41.36,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('5A8AC8B8-307D-4EF4-899F-2D66BEEF2A38',3,31,3,2015,'39BA6ADF-6526-4D8A-A502-72468A9733F3','Test Line Item 190',0.11,2,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('3EAB5689-1FD9-4CD2-A9B1-6792D6FD1B84',3,28,7,2015,'A886199A-3203-4DA7-9042-DB5518D199E6','Test Line Item 191',-31.94,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('5B5C6A90-37A5-42E9-99DD-77969AEAE33C',2,4,4,2015,'4ABE4F16-DA07-45EA-9345-1CA35CC37FA5','Test Line Item 192',-851.68,0,0,1,'D6A03F18-D7E9-4C09-9490-EA8AB4F29D5E',0,0,NOW()),
			 ('875CFFCA-E4FF-4FF6-9926-0EDDE1C37EF7',3,28,7,2015,'A886199A-3203-4DA7-9042-DB5518D199E6','Test Line Item 193',-15.17,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('93A46D46-2BDA-4790-BB6C-480080A4DA55',2,1,1,2015,'94615CEE-9857-4897-8C5A-64C788BCF29F','Test Line Item 194',14829.93,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('9F7159D8-4989-4C77-B52C-988E24EDE95D',1,1,5,2015,'71D83AC4-0F57-4936-BB59-38C50E692E3F','Test Line Item 195',1596.9,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('80A2B71C-A10D-4EF0-BB6D-270F77B4ADBF',3,27,6,2015,'A886199A-3203-4DA7-9042-DB5518D199E6','Test Line Item 196',-53.12,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('EC27A5D4-7A1C-41EF-BDE3-45B878D8ED83',4,3,6,2015,'0EAB9B99-4BC4-4B54-8E08-024A8A4BCAD6','Test Line Item 197',-1755.9,0,0,2,'6580A957-EC90-4987-B763-56F1072FD295',0,0,NOW()),
			 ('ACDD095E-A652-4977-8F9A-7BAF29E9CED6',2,9,2,2015,'2638253D-B50C-427F-B587-7703EB29BBBA','Test Line Item 198',-164.8,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('60BF4847-5F16-4437-835C-3140142CCCB0',4,14,3,2015,'4F21EE9D-316F-40C2-8379-71F8D429FA11','Test Line Item 199',38.91,2,1,2,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('8A4EFD71-DC46-4AA8-B381-AE825D344E3B',1,1,5,2015,'384E325E-ABE3-4490-9532-56B90E9A1A48','Test Line Item 200',676.02,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('19A9C7E4-36D3-4363-9412-7C1C9FBB64D3',1,6,3,2015,'2638253D-B50C-427F-B587-7703EB29BBBA','Test Line Item 201',-150.53,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,0,NOW()),
			 ('EBE874AA-68C2-4C4E-9842-2CCA8AA0962B',3,1,1,2015,'302D08BD-D007-4B1F-96F0-111FCB1683BE','Test Line Item 202',532.3,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('68632A1E-7F57-42AC-84FF-755B7C282DD7',4,17,6,2015,'20616ABA-8911-4523-ABA1-0E4E86EBCAF9','Test Line Item 203',-532.14,0,0,2,'A3C285C0-A027-418A-8810-3177A96054A3',0,0,NOW()),
			 ('B39F0F2D-1BB1-4F46-82BF-70ECDE75F553',4,1,4,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 204',2129.2,1,1,2,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('31A9465A-0059-4BD6-9B91-C30831640DC9',4,1,4,2015,'7B7A6AB7-3D74-421B-BD50-96C7A7AE02A8','Test Line Item 205',443.3,1,1,2,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('4881B5F8-FEDE-4718-A40D-F87F5714820B',2,9,2,2015,'82B2A266-5181-45D7-8610-2F9213A397ED','Test Line Item 206',-420.46,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('F50F683E-3CD2-4BE2-AC6D-440FBD8E04A6',3,23,2,2015,'4F21EE9D-316F-40C2-8379-71F8D429FA11','Test Line Item 207',-750.76,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('661B4408-60F9-4D5C-A3A5-5D8DD604C231',3,2,2,2015,'5AA0B1F1-64AE-43C2-9F31-3B1248728799','Test Line Item 208',-591.86,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('15C9E312-6D12-4B98-A472-CCB3BCBF8C85',2,12,5,2015,'5AA0B1F1-64AE-43C2-9F31-3B1248728799','Test Line Item 209',266.15,2,1,1,'2F7552F5-E69E-48B2-9FE6-B125BDE851E4',0,0,NOW()),
			 ('E37F82DC-75D0-4627-BD04-07426999C6E5',1,20,3,2015,'D88C9DA1-3788-404C-B3A0-72B371CC171F','Test Line Item 210',-165.01,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,0,NOW()),
			 ('3A2AD31B-F6AC-4D18-B756-4C6CB36696FB',1,7,4,2015,'4ABE4F16-DA07-45EA-9345-1CA35CC37FA5','Test Line Item 211',-57.91,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,1,NOW()),
			 ('29D570C9-CE9C-4D15-A0B1-B51777AA9FC0',3,1,1,2015,'39BA6ADF-6526-4D8A-A502-72468A9733F3','Test Line Item 212',639.19,2,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('2CBE8AE3-AE63-4F82-87E1-0E0BB0BA016D',2,24,3,2015,'C4CD23AC-5B64-4234-9515-9CC7EC92E577','Test Line Item 213',-319.38,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('1754C157-8D50-45C6-A952-7452834BA30F',3,8,1,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 214',-64.2,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('4867A7A2-F80D-4528-9C60-45E803459274',4,6,2,2015,'384E325E-ABE3-4490-9532-56B90E9A1A48','Test Line Item 215',-676.02,0,0,2,'6580A957-EC90-4987-B763-56F1072FD295',0,0,NOW()),
			 ('03004FDD-0CA7-4F2C-8BE4-252EDE375653',1,22,5,2015,'3E51C340-43CE-4726-9CBD-76600E1B7DF1','Test Line Item 216',-53.23,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,0,NOW()),
			 ('754AEAC0-BDEB-4EF7-A1D0-365129283985',1,30,6,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 217',-33.43,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,0,NOW()),
			 ('DD2FEB0A-EEDE-457A-911C-A622244EDD53',3,1,1,2015,'BBE64D1D-F8A1-46DE-8880-B700FA99D48C','Test Line Item 218',532.3,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('65B5E5A0-1E1D-4DBD-B69B-AFABA3C1370B',3,17,3,2015,'A886199A-3203-4DA7-9042-DB5518D199E6','Test Line Item 219',-43.91,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('9ABAEC27-6067-486D-83A1-8EC8EC3E0EEA',1,16,6,2015,'BCB2E098-7FA5-432E-8E7A-B7EA4C510002','Test Line Item 220',-119.39,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('AFADB987-EAF5-46C6-8DA2-F74ED0256DD0',1,5,2,2015,'BCB2E098-7FA5-432E-8E7A-B7EA4C510002','Test Line Item 221',-505.68,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('CA8B06C3-E96D-4749-AFEB-77277E56BD99',3,14,7,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 222',-53.23,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('90020871-75D2-45ED-B110-CA5E2B47D188',3,31,3,2015,'5AA0B1F1-64AE-43C2-9F31-3B1248728799','Test Line Item 223',-0.11,2,0,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('BEFAA696-B05A-4E14-A4CC-F70B52A77882',4,1,4,2015,'97E08362-5E98-4156-B3F1-80AFB8FCB9C5','Test Line Item 224',0,1,0,2,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('1ABE02CD-0F0E-4177-9585-D68E140BC1F5',2,1,1,2015,'0EAB9B99-4BC4-4B54-8E08-024A8A4BCAD6','Test Line Item 225',-1755.9,0,0,1,'6580A957-EC90-4987-B763-56F1072FD295',0,0,NOW()),
			 ('64685AA1-3A21-47C0-BF9D-1EE2ABC35F68',4,3,6,2015,'5363AD11-B0EC-4ABF-85D2-26487A7963E7','Test Line Item 226',-311.61,0,0,2,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,0,NOW()),
			 ('2D74C8AF-F4BA-441D-A753-D2E7D1B2AAFB',3,22,1,2015,'BBE64D1D-F8A1-46DE-8880-B700FA99D48C','Test Line Item 227',-127.54,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('A10D6A55-A2A6-4908-A87F-46E8760AB6BD',3,1,1,2015,'6FA0C20F-2E60-4463-9467-F768A90F29D1','Test Line Item 228',255.24,2,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('FD8F2D8A-2757-49F6-B67D-4391504E1732',1,20,3,2015,'BCB2E098-7FA5-432E-8E7A-B7EA4C510002','Test Line Item 229',-7.03,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('D024BAD1-FABD-4076-8BFF-F537B8949249',2,4,4,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 230',-50.99,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('ECEDB539-F90E-4D11-8ABE-104333806247',3,3,3,2015,'0EAB9B99-4BC4-4B54-8E08-024A8A4BCAD6','Test Line Item 231',-1755.9,0,0,1,'6580A957-EC90-4987-B763-56F1072FD295',0,0,NOW()),
			 ('BEA6093B-3A7D-4A8B-A63C-B10AB8762346',3,28,7,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 232',-21.29,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('40DC6CBA-15EF-4C94-ADD7-899921C3158F',2,1,1,2015,'BBE64D1D-F8A1-46DE-8880-B700FA99D48C','Test Line Item 233',798.45,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('2B5F3E54-8FBF-45B8-9469-426E9395CB81',3,6,6,2015,'D88C9DA1-3788-404C-B3A0-72B371CC171F','Test Line Item 234',-199.03,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('7EB11C23-5C75-4410-AC75-72B48CE46450',3,31,3,2015,'A886199A-3203-4DA7-9042-DB5518D199E6','Test Line Item 235',214.73,2,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('087C0287-0DF6-4524-B888-02BC31D98044',2,1,1,2015,'4CC232A5-D705-48A0-A495-C0DCCC68FC59','Test Line Item 236',-212.92,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,0,NOW()),
			 ('C4B1A7BB-4AF0-488E-AF43-B5A8DBA06E22',2,15,1,2015,'0BC45B85-D6ED-4A62-BD5E-A99A5A598432','Test Line Item 237',-630.99,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('282E49AC-F342-4440-9476-CE82991A559A',3,24,3,2015,'90DC03F2-B110-4B0C-B879-3EA157555DDF','Test Line Item 238',-164,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('24274A07-B61E-4E85-A6B2-3FB05198B53D',3,15,1,2015,'302D08BD-D007-4B1F-96F0-111FCB1683BE','Test Line Item 239',-28.8,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('EB3761E7-9157-41B4-8299-F91EAD71287B',3,1,1,2015,'4CC232A5-D705-48A0-A495-C0DCCC68FC59','Test Line Item 240',-212.92,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('6B8ED868-9DAB-4EFB-B747-A618364985CF',2,13,6,2015,'A886199A-3203-4DA7-9042-DB5518D199E6','Test Line Item 241',-185.77,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('48032883-1632-443A-8102-BA9BF866D910',1,14,4,2015,'C4CD23AC-5B64-4234-9515-9CC7EC92E577','Test Line Item 242',-319.38,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('4A4C0804-E837-4048-B71A-AD78BEDA36C4',1,1,5,2015,'D88C9DA1-3788-404C-B3A0-72B371CC171F','Test Line Item 243',532.3,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('30F8D1B0-B3FC-4A39-9D94-30FDB0052E03',1,1,5,2015,'6AC0FC1B-72C3-4595-B594-4117755A8307','Test Line Item 244',4590.18,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('DFFE4825-8B2E-4D64-BAF7-6258BF294E33',4,14,3,2015,'39BA6ADF-6526-4D8A-A502-72468A9733F3','Test Line Item 245',-38.91,2,0,2,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('707D0FC0-1B3A-4738-BB18-3FA95AF8FEE7',1,5,2,2015,'BBE64D1D-F8A1-46DE-8880-B700FA99D48C','Test Line Item 246',-27.57,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,0,NOW()),
			 ('4830F539-9C95-4B38-8FF9-77F6F3ADE9E4',4,9,5,2015,'C4CD23AC-5B64-4234-9515-9CC7EC92E577','Test Line Item 247',-239.53,0,0,2,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('32375CE2-8B22-4348-B691-A7C70A586304',3,31,3,2015,'74801902-27FC-47F6-B6DE-B6D956FCDF34','Test Line Item 248',-2266.43,2,0,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('76E1CCA1-F425-435B-98C0-C8A7F044E21D',3,1,1,2015,'38BB2D2D-307D-4C5C-AB7C-93D34ABABD1D','Test Line Item 249',2209.04,2,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('37626EA7-CD72-410B-BEB6-C766F8470DE2',1,16,6,2015,'A886199A-3203-4DA7-9042-DB5518D199E6','Test Line Item 250',-11.98,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,0,NOW()),
			 ('D5282B2C-BA26-410E-879F-17D5108C7C48',1,14,4,2015,'BCB2E098-7FA5-432E-8E7A-B7EA4C510002','Test Line Item 251',-57.81,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,0,NOW()),
			 ('A16A2BF2-CF84-4390-AD1C-40C9A77EE5D1',3,2,2,2015,'5AA0B1F1-64AE-43C2-9F31-3B1248728799','Test Line Item 252',-242.36,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('65B31BFE-F264-4DB0-8CDE-4ACD54F3A57C',3,17,3,2015,'8B5E5DC1-FC90-404E-A260-1F5155044E0F','Test Line Item 253',-374.31,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('49AA659D-E9F2-4A59-BA23-E02AB39ED729',4,8,4,2015,'39BA6ADF-6526-4D8A-A502-72468A9733F3','Test Line Item 254',-483.65,0,0,2,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('6D5BA37E-6858-41AC-AD13-EA9A9CBA9883',2,14,7,2015,'6FA0C20F-2E60-4463-9467-F768A90F29D1','Test Line Item 255',-179.86,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('34FE4D2F-2047-4648-9225-D4166E24465F',1,6,3,2015,'384E325E-ABE3-4490-9532-56B90E9A1A48','Test Line Item 256',-676.02,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,0,NOW()),
			 ('CCE3289D-EEE0-4017-A724-B933429CD424',3,12,5,2015,'C4CD23AC-5B64-4234-9515-9CC7EC92E577','Test Line Item 257',-239.53,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('EC0B502C-B9E1-4C82-9036-5615D5CADBBA',1,20,3,2015,'BCB2E098-7FA5-432E-8E7A-B7EA4C510002','Test Line Item 258',-9.47,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('AE158F1B-9E91-4D00-9355-C80F8AC472E1',3,25,4,2015,'39BA6ADF-6526-4D8A-A502-72468A9733F3','Test Line Item 259',-121.05,2,0,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('AC4CD6E4-D13A-4F1D-8191-C19ED8A6032B',4,1,4,2015,'B1F4EBEE-ABBD-4501-A11F-3FFA4FEAFF8C','Test Line Item 260',0,1,0,2,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('B0504787-D576-4A50-AB23-CBCD8E9379E2',4,18,7,2015,'A886199A-3203-4DA7-9042-DB5518D199E6','Test Line Item 261',-19.96,0,0,2,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('F0796B15-DA30-4203-83D5-5249A2BDFFFB',3,2,2,2015,'4ABE4F16-DA07-45EA-9345-1CA35CC37FA5','Test Line Item 262',-851.68,0,0,1,'D6A03F18-D7E9-4C09-9490-EA8AB4F29D5E',0,0,NOW()),
			 ('6DD77BDB-6B94-494C-86E3-DEB78D8E13A9',4,4,7,2015,'9B26784E-67A3-4BBA-9DCE-D06E33ED84D3','Test Line Item 263',-582.82,0,0,2,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('33405B67-8806-40F5-AC9B-1D1962E71D24',4,1,4,2015,'9B26784E-67A3-4BBA-9DCE-D06E33ED84D3','Test Line Item 264',638.76,1,1,2,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('0CA065B5-8E11-487A-933B-EFE1BBDEA25B',1,23,6,2015,'2638253D-B50C-427F-B587-7703EB29BBBA','Test Line Item 265',-154.63,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('F2DD800F-84F9-4839-8346-23B5EC43E376',2,26,5,2015,'A886199A-3203-4DA7-9042-DB5518D199E6','Test Line Item 266',-116.89,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('03DD78B0-BAA3-45EF-AB2F-BE093D2B18FC',4,1,4,2015,'4CC232A5-D705-48A0-A495-C0DCCC68FC59','Test Line Item 267',-212.92,0,0,2,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('3AD9E8B5-C738-4125-BA55-AD0A34C5BBCD',2,8,1,2015,'D88C9DA1-3788-404C-B3A0-72B371CC171F','Test Line Item 268',-133.07,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('E6AF8EB5-79F3-4CFB-BC7A-CF8D57C908E4',1,1,5,2015,'6AC0FC1B-72C3-4595-B594-4117755A8307','Test Line Item 269',6517.32,2,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('A4C4598F-D517-473D-9D00-644571AB5221',4,1,4,2015,'82B2A266-5181-45D7-8610-2F9213A397ED','Test Line Item 270',420.46,1,1,2,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('C1DC7566-9C1C-404C-8EF6-6728B6DA63BF',3,22,1,2015,'2638253D-B50C-427F-B587-7703EB29BBBA','Test Line Item 271',-199.29,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('4855152D-5897-4E89-9CA0-5FCFBCFE8AB2',1,1,5,2015,'FDE3F005-D3D4-4A10-B79E-112A011013CF','Test Line Item 272',307.4,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('018A72A2-1D6C-4EA4-A59F-D543DAB60584',4,1,4,2015,'BBE64D1D-F8A1-46DE-8880-B700FA99D48C','Test Line Item 273',-52.22,0,0,2,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('5F9AD34A-5B49-41D5-8AB7-8E5F27110342',1,28,4,2015,'A886199A-3203-4DA7-9042-DB5518D199E6','Test Line Item 274',-163.15,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,0,NOW()),
			 ('587C0F17-F7EE-4FD8-837E-15EC6A4B919C',3,1,1,2015,'8B5E5DC1-FC90-404E-A260-1F5155044E0F','Test Line Item 275',-53.23,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('7830AF6F-AAF7-43C2-8D21-959F061F1FDE',3,1,1,2015,'74801902-27FC-47F6-B6DE-B6D956FCDF34','Test Line Item 276',7.77,2,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('4FBF6DE2-47D7-439B-81A8-B0A49185A0FB',4,12,1,2015,'A886199A-3203-4DA7-9042-DB5518D199E6','Test Line Item 277',-75.11,0,0,2,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('AEA1CD71-5500-4100-A132-A84D7C1B9DBA',2,1,1,2015,'8125DB24-54E0-4B28-80BB-858D6111D64D','Test Line Item 278',88.89,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('9CB59B60-539F-4EE9-8268-47BC58BCA016',1,1,5,2015,'81690BD3-8C3F-47D1-B874-433DB1482EF6','Test Line Item 279',1027.07,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('BE3701F3-79D4-4AAC-9247-D7A74A704AFA',3,16,2,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 280',-101.72,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('BFB33C89-204B-49AF-9B38-2AC16DCC5A22',2,2,2,2015,'BCB2E098-7FA5-432E-8E7A-B7EA4C510002','Test Line Item 281',-2661.5,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('975CCD36-2343-4DBB-9AD2-8CDB89F63138',3,15,1,2015,'6FA0C20F-2E60-4463-9467-F768A90F29D1','Test Line Item 282',79.74,2,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('DA4FD185-3F26-48CD-AA67-4F54239316AE',4,6,2,2015,'94615CEE-9857-4897-8C5A-64C788BCF29F','Test Line Item 283',-14829.93,0,0,2,'6580A957-EC90-4987-B763-56F1072FD295',0,0,NOW()),
			 ('B59054E7-D5F6-4E88-85D2-22FA5D06BAB8',2,16,2,2015,'FDE3F005-D3D4-4A10-B79E-112A011013CF','Test Line Item 284',-346.95,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('0744C236-35EF-40DB-8800-2CE1F34F9031',3,1,1,2015,'C58CABB1-8443-4BDF-898F-312DDFB74C6E','Test Line Item 285',186.3,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('8BA1B22F-5587-4A92-99CE-78DA9D49A4F8',4,12,1,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 286',-26.61,0,0,2,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('0E846C3B-72F3-452A-97EA-E07B214B37EE',3,1,1,2015,'94615CEE-9857-4897-8C5A-64C788BCF29F','Test Line Item 287',14829.93,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('C9632D1E-ECED-46EC-AB9D-3F6F3E7D1A01',2,9,2,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 288',-99.81,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('D1DB8705-EC9E-4198-AA2C-A5FAFFD0B948',4,12,1,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 289',-5.8,0,0,2,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('6D6C3E4A-F69E-4944-AAE7-D83766D48D8D',1,22,5,2015,'3E51C340-43CE-4726-9CBD-76600E1B7DF1','Test Line Item 290',-106.46,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,0,NOW()),
			 ('8194A992-C182-482D-B1C0-A4E20FDB77D8',4,2,5,2015,'4ABE4F16-DA07-45EA-9345-1CA35CC37FA5','Test Line Item 291',-638.76,0,0,2,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('69FA2136-AA38-4F91-9AB5-180409A32356',3,1,1,2015,'4F21EE9D-316F-40C2-8379-71F8D429FA11','Test Line Item 292',212.92,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('0BC92D41-D9D1-4473-858D-C097CA20F8DA',3,15,1,2015,'4F21EE9D-316F-40C2-8379-71F8D429FA11','Test Line Item 293',115.88,2,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('582983FC-8AD2-437D-87D3-3E6DE090FAD7',4,14,3,2015,'39BA6ADF-6526-4D8A-A502-72468A9733F3','Test Line Item 294',-0.21,2,0,2,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('E9F16EF4-D0DC-4AC7-8C5F-A778FF43A86F',2,27,6,2015,'74801902-27FC-47F6-B6DE-B6D956FCDF34','Test Line Item 295',16143.86,2,1,1,'2F7552F5-E69E-48B2-9FE6-B125BDE851E4',0,0,NOW()),
			 ('F7474F83-0BF0-4382-8B24-85D6F281D9AA',1,14,4,2015,'FDE3F005-D3D4-4A10-B79E-112A011013CF','Test Line Item 296',-232.93,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,0,NOW()),
			 ('DB77D28A-84A4-48BE-899F-960E5B0295AF',4,1,4,2015,'4CC232A5-D705-48A0-A495-C0DCCC68FC59','Test Line Item 297',212.92,1,1,2,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('2A6C2F56-49AD-4705-BD76-D0FD194A9C51',4,3,6,2015,'BBE64D1D-F8A1-46DE-8880-B700FA99D48C','Test Line Item 298',-243.15,0,0,2,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('B649D832-26E0-4597-9970-2D6637FC3F86',1,4,1,2015,'8B5E5DC1-FC90-404E-A260-1F5155044E0F','Test Line Item 299',-116.57,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,0,NOW()),
			 ('F1D9C9D4-F525-4067-A929-A97205D69B2B',2,7,7,2015,'FDE3F005-D3D4-4A10-B79E-112A011013CF','Test Line Item 300',-76.97,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('0DD67FBA-8CAC-4E00-95AB-42E7FC408161',3,4,4,2015,'C4CD23AC-5B64-4234-9515-9CC7EC92E577','Test Line Item 301',-319.38,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('6A1C47EC-EC66-43E3-8B06-D23826C63A05',3,21,7,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 302',-53.28,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('640507C9-EA04-4A67-B99C-01450E22A8F2',3,7,7,2015,'BCB2E098-7FA5-432E-8E7A-B7EA4C510002','Test Line Item 303',-851.68,0,0,1,'D6A03F18-D7E9-4C09-9490-EA8AB4F29D5E',0,0,NOW()),
			 ('0113FFFC-D3F1-4C33-879A-EE991128C0EC',3,14,7,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 304',-538,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('34A96161-AA3F-4C26-A8C0-A0ACEAF62C03',2,27,6,2015,'BCB2E098-7FA5-432E-8E7A-B7EA4C510002','Test Line Item 305',-1022.02,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('6C04CBAF-1A74-42AF-A1E6-C4F93642E194',2,24,3,2015,'BCB2E098-7FA5-432E-8E7A-B7EA4C510002','Test Line Item 306',-2337.86,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('B0862B40-F15D-4247-B634-2AE8211DCDDC',2,28,7,2015,'74801902-27FC-47F6-B6DE-B6D956FCDF34','Test Line Item 307',-4788.36,2,0,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('0DE9199E-EEB3-4CCA-AF11-C424C45845CE',3,1,1,2015,'3E51C340-43CE-4726-9CBD-76600E1B7DF1','Test Line Item 308',266.15,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('611B3A31-A444-4CD6-A550-EE97E283FCEC',2,1,1,2015,'1E6B1C48-31C9-4C7F-9C03-75BD81124A1D','Test Line Item 309',150.8,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('AA93D389-E33B-489F-BCE8-EC75FC69BBF1',2,7,7,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 310',-212.92,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('DE369D7A-0A3F-4BE7-BA2A-9623D15707A8',2,1,1,2015,'BCB2E098-7FA5-432E-8E7A-B7EA4C510002','Test Line Item 311',5439.36,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('43924C42-88FA-4548-91E4-EE1E29E6701D',2,1,1,2015,'0EAB9B99-4BC4-4B54-8E08-024A8A4BCAD6','Test Line Item 312',1755.9,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('DA826908-6F46-4D38-AB5B-83DF035D8026',3,1,1,2015,'5363AD11-B0EC-4ABF-85D2-26487A7963E7','Test Line Item 313',106.46,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('047FFF7C-7F4F-4D06-A9DA-67CBEBCFCDB0',3,17,3,2015,'A886199A-3203-4DA7-9042-DB5518D199E6','Test Line Item 314',-312.46,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('74D86636-F099-4B6B-9D1B-9BE79FB2D23B',2,14,7,2015,'8B5E5DC1-FC90-404E-A260-1F5155044E0F','Test Line Item 315',-198.28,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('EFAC6051-7815-4DC4-BCA8-6839F56D4792',4,14,3,2015,'8125DB24-54E0-4B28-80BB-858D6111D64D','Test Line Item 316',0.21,2,1,2,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('F38143DD-7AF5-403B-8603-04D52D7C9397',1,16,6,2015,'BCB2E098-7FA5-432E-8E7A-B7EA4C510002','Test Line Item 317',-66.27,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('29157C74-F169-4F45-8B6B-1B9EE0EF4722',1,1,5,2015,'BCB2E098-7FA5-432E-8E7A-B7EA4C510002','Test Line Item 318',6166.06,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('7F9BDA52-58CF-436B-8383-2125DA98F2F9',4,1,4,2015,'4ABE4F16-DA07-45EA-9345-1CA35CC37FA5','Test Line Item 319',638.76,1,1,2,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('CB2928FF-120F-437B-B460-03522F889C8A',3,1,1,2015,'6AC0FC1B-72C3-4595-B594-4117755A8307','Test Line Item 320',4590.18,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('EAAA179F-6E7A-4750-BFCF-ECFCAFBC81EF',3,1,1,2015,'C4CD23AC-5B64-4234-9515-9CC7EC92E577','Test Line Item 321',1596.9,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('FA515079-FC47-4C26-85EA-837DA3EBEC89',1,3,7,2015,'A886199A-3203-4DA7-9042-DB5518D199E6','Test Line Item 322',-68.29,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,0,NOW()),
			 ('48EB1183-026D-476F-9F87-271B63DAF925',4,3,6,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 323',-7.4,0,0,2,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('00706DFB-7549-4033-98C3-231A610F5380',2,2,2,2015,'94615CEE-9857-4897-8C5A-64C788BCF29F','Test Line Item 324',-14829.93,0,0,1,'6580A957-EC90-4987-B763-56F1072FD295',0,0,NOW()),
			 ('1485B985-B445-48A0-B7D9-88554370E30D',1,16,6,2015,'9B26784E-67A3-4BBA-9DCE-D06E33ED84D3','Test Line Item 325',-203.02,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('94148A25-1479-4BFC-880A-84C703F3D761',4,5,1,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 326',-15.92,0,0,2,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('11CAD43B-0B62-47F9-AAF5-91BC54E98FFB',3,15,1,2015,'6FA0C20F-2E60-4463-9467-F768A90F29D1','Test Line Item 327',-79.74,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('465419AF-4BD1-476A-A686-13F5388A59DB',2,27,6,2015,'A886199A-3203-4DA7-9042-DB5518D199E6','Test Line Item 328',-7.56,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('5D852794-D790-44F8-813A-98B4104833F6',1,22,5,2015,'3E51C340-43CE-4726-9CBD-76600E1B7DF1','Test Line Item 329',-70.32,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,0,NOW()),
			 ('A4406A71-EA85-42BE-B37D-D8D47C307C19',1,28,4,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 330',-85.06,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,0,NOW()),
			 ('B3C0A1EE-C6FF-40BE-BB4D-823D29D98369',3,1,1,2015,'0BC45B85-D6ED-4A62-BD5E-A99A5A598432','Test Line Item 331',638.76,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('96122166-81EB-429F-BDE5-04365A36B39E',2,1,1,2015,'A886199A-3203-4DA7-9042-DB5518D199E6','Test Line Item 332',1596.9,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('8B4ADD67-04B2-4322-8CA8-0B36B5894993',4,12,1,2015,'0BC45B85-D6ED-4A62-BD5E-A99A5A598432','Test Line Item 333',-631.31,0,0,2,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('41D9B055-B7CD-4943-9CA5-E50960A700C3',4,1,4,2015,'39BA6ADF-6526-4D8A-A502-72468A9733F3','Test Line Item 334',526.98,2,1,2,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('E51EAFA6-EB2C-42CF-89DE-E80F033C9E18',1,15,5,2015,'BCB2E098-7FA5-432E-8E7A-B7EA4C510002','Test Line Item 335',-66.54,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('4D4A823F-A14F-49E3-99A0-983A8E678AA5',2,16,2,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 336',-53.07,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,1,NOW()),
			 ('2FF71BD4-4561-4AAE-9295-D1A65ED83C47',2,1,1,2015,'8B5E5DC1-FC90-404E-A260-1F5155044E0F','Test Line Item 337',798.45,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('575F88C5-702E-4F5F-8097-EF27D9C716AD',2,26,5,2015,'8B5E5DC1-FC90-404E-A260-1F5155044E0F','Test Line Item 338',-148.83,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('655107E7-7794-4C85-A795-3822EAE00E61',4,16,5,2015,'C4CD23AC-5B64-4234-9515-9CC7EC92E577','Test Line Item 339',-122.43,0,0,2,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('31ADFBE3-E0BB-47A9-A67B-DD3A3E06BB21',3,12,5,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 340',-24.96,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('6E9F57FF-9183-4139-AC81-A6159E34944F',4,1,4,2015,'1E6B1C48-31C9-4C7F-9C03-75BD81124A1D','Test Line Item 341',145.32,1,1,2,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('F2502B19-50E3-46E8-919C-B4A8CC28140C',2,14,7,2015,'8B5E5DC1-FC90-404E-A260-1F5155044E0F','Test Line Item 342',-41.36,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('2C302FDF-0EDA-4A62-8C7E-FE61DF037924',1,25,1,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 343',-133.55,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,0,NOW()),
			 ('0E02BDD4-A389-4CB2-A0EE-97ECED0171BD',1,1,5,2015,'302D08BD-D007-4B1F-96F0-111FCB1683BE','Test Line Item 344',0,2,0,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('0A7C3506-0A49-4E56-99ED-3CDE2A132B58',2,10,3,2015,'7B7A6AB7-3D74-421B-BD50-96C7A7AE02A8','Test Line Item 345',-443.3,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('CC08F25A-C1A8-486F-9FB0-C4DA41D6C978',1,28,4,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 346',-72.29,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,0,NOW()),
			 ('5E6CB643-06E0-4E25-A4E3-50413938D27A',4,11,7,2015,'B1F4EBEE-ABBD-4501-A11F-3FFA4FEAFF8C','Test Line Item 347',-234.11,0,0,2,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('79E3FD62-7F22-4A03-9FD3-45E5E1090ED7',3,1,1,2015,'71D83AC4-0F57-4936-BB59-38C50E692E3F','Test Line Item 348',1596.9,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('4D0830BD-B030-42E7-B011-AEC415EAB926',1,24,7,2015,'90DC03F2-B110-4B0C-B879-3EA157555DDF','Test Line Item 349',-124.08,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('8714148C-AE49-436D-96B8-AA525DFF6753',1,1,5,2015,'FFE5A167-FBCE-452C-A5E0-7AA8BDDA41B0','Test Line Item 350',0,2,0,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('4558733C-B39D-48B5-B6B4-33DBF2714E1D',1,1,5,2015,'0EAB9B99-4BC4-4B54-8E08-024A8A4BCAD6','Test Line Item 351',-1755.9,0,0,1,'6580A957-EC90-4987-B763-56F1072FD295',0,0,NOW()),
			 ('D14A1E1A-2FDE-4183-ACB6-4285C6289095',1,1,5,2015,'C4CD23AC-5B64-4234-9515-9CC7EC92E577','Test Line Item 352',1463.82,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('16A31696-8768-4A5F-9430-DC0D6F3B06F4',4,12,1,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 353',-186.3,0,0,2,'D6A03F18-D7E9-4C09-9490-EA8AB4F29D5E',0,0,NOW()),
			 ('3E05D020-494E-4D16-ADF8-E465447FB612',3,1,1,2015,'74801902-27FC-47F6-B6DE-B6D956FCDF34','Test Line Item 354',133.07,2,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('F1AE8D49-506E-45FD-85B8-DAB64C706A57',4,1,4,2015,'94615CEE-9857-4897-8C5A-64C788BCF29F','Test Line Item 355',14829.93,1,1,2,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('CFC7BB97-54C0-4FDE-86B9-8B41B2560EE9',2,2,2,2015,'81690BD3-8C3F-47D1-B874-433DB1482EF6','Test Line Item 356',-894,0,0,1,'6580A957-EC90-4987-B763-56F1072FD295',0,0,NOW()),
			 ('5F5C8C54-DC8B-457E-9D46-A8ED7211B6CC',1,8,5,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 357',-98.21,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,0,NOW()),
			 ('4FE69689-C228-45A7-A7E5-1D675EAB9794',2,1,1,2015,'C4CD23AC-5B64-4234-9515-9CC7EC92E577','Test Line Item 358',1463.82,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('99BE4E11-28E3-405B-BB39-5782545F155B',4,1,4,2015,'6FA0C20F-2E60-4463-9467-F768A90F29D1','Test Line Item 359',0,1,0,2,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('C9E2C208-CE1A-4FE8-98E8-051BC235BC46',3,1,1,2015,'74801902-27FC-47F6-B6DE-B6D956FCDF34','Test Line Item 360',2736.45,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('277DB240-E236-41BB-B7E6-8B4E8A52A7D2',1,5,2,2015,'A886199A-3203-4DA7-9042-DB5518D199E6','Test Line Item 361',-71.81,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,0,NOW()),
			 ('175FAE6F-C289-4289-B69D-377E0E3D1AB6',3,11,4,2015,'8B5E5DC1-FC90-404E-A260-1F5155044E0F','Test Line Item 362',732.18,2,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('4A99E333-7269-4CBA-9B23-A2A8D9DC80CF',3,15,1,2015,'4F21EE9D-316F-40C2-8379-71F8D429FA11','Test Line Item 363',-225.75,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('13FF9987-E77B-4C97-8370-E2C8F1EBE6C7',2,16,2,2015,'A886199A-3203-4DA7-9042-DB5518D199E6','Test Line Item 364',-53.66,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('E9930CC0-C02D-4329-A38E-43B7365E8BDE',2,1,1,2015,'74801902-27FC-47F6-B6DE-B6D956FCDF34','Test Line Item 365',10646,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('466639E4-B756-4C98-B1B7-B21DDD34AECC',3,1,1,2015,'8125DB24-54E0-4B28-80BB-858D6111D64D','Test Line Item 366',88.89,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('E803EC07-616A-4AA3-8837-049B02215D1C',1,5,2,2015,'BCB2E098-7FA5-432E-8E7A-B7EA4C510002','Test Line Item 367',-94.16,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,0,NOW()),
			 ('210269AE-F0F3-4A7A-856D-F473066EB50B',1,28,4,2015,'C4CD23AC-5B64-4234-9515-9CC7EC92E577','Test Line Item 368',-239.53,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('1B59B996-633B-4DC4-ABD9-65616235A427',2,13,6,2015,'74801902-27FC-47F6-B6DE-B6D956FCDF34','Test Line Item 369',16143.91,2,1,1,'2F7552F5-E69E-48B2-9FE6-B125BDE851E4',0,0,NOW()),
			 ('E46782A9-FFA6-4C34-B91D-FFC5F989253B',3,2,2,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 370',-7.4,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('9EA44603-9CCE-47C2-8B81-713C02205133',1,1,5,2015,'EA079363-9B14-4C23-AF48-49FF0284A930','Test Line Item 371',0,2,0,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('7E24C46A-2CAF-42B2-9C30-8224ECBA4C94',4,5,1,2015,'FDE3F005-D3D4-4A10-B79E-112A011013CF','Test Line Item 372',-122.75,0,0,2,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('2E2DFB72-58E6-4C6D-968A-3A77EAE1411A',1,5,2,2015,'BCB2E098-7FA5-432E-8E7A-B7EA4C510002','Test Line Item 373',-1379.51,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('F0269C9F-0019-4943-AE81-3F9400D973B9',3,3,3,2015,'39BA6ADF-6526-4D8A-A502-72468A9733F3','Test Line Item 374',-53.23,2,0,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('DD288C03-71D7-4A0D-B05D-A421535C5275',2,9,2,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 375',-18.63,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('A3C73EC6-3653-43E1-8E37-4C9AAF4C89F7',3,1,1,2015,'8B5E5DC1-FC90-404E-A260-1F5155044E0F','Test Line Item 376',798.45,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('5A72D9B6-1809-4245-9F80-5A60D3362944',1,25,1,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 377',-212.92,0,0,1,'D6A03F18-D7E9-4C09-9490-EA8AB4F29D5E',0,0,NOW()),
			 ('0AA45BBA-2710-4BCE-96AB-556A9A6CB7D4',1,1,5,2015,'C4CD23AC-5B64-4234-9515-9CC7EC92E577','Test Line Item 378',90.76,2,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('28ACA0DA-5F0F-47EB-9552-606D39DBD142',3,1,1,2015,'74801902-27FC-47F6-B6DE-B6D956FCDF34','Test Line Item 379',266.15,2,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('C10EA185-E339-4B98-A0B6-AB914416F2A6',3,6,6,2015,'3E51C340-43CE-4726-9CBD-76600E1B7DF1','Test Line Item 380',-106.46,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('4940418A-9F08-4214-88FE-093B750D8CC4',1,21,4,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 381',-227.35,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,0,NOW()),
			 ('11DCB457-B4F8-4EDA-8C7C-49952E983038',3,8,1,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 382',-58.5,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('869E94F6-0F49-4D11-BFD6-E133132591A5',3,2,2,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 383',-396.78,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('88F91323-1672-4941-A700-5E7E8980BE31',3,4,4,2015,'81690BD3-8C3F-47D1-B874-433DB1482EF6','Test Line Item 384',-894,0,0,1,'6580A957-EC90-4987-B763-56F1072FD295',0,0,NOW()),
			 ('893CA70E-E152-45A3-91C6-6C8BDA0BFB94',3,1,1,2015,'0EAB9B99-4BC4-4B54-8E08-024A8A4BCAD6','Test Line Item 385',1755.9,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('BCEB1D4D-F374-4611-A219-EB512B4B3BE5',3,14,7,2015,'A886199A-3203-4DA7-9042-DB5518D199E6','Test Line Item 386',-211.8,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('A5E10179-1212-4849-A877-C77A51EB5926',3,15,1,2015,'4F21EE9D-316F-40C2-8379-71F8D429FA11','Test Line Item 387',-115.88,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('4FF6E2D2-B684-49AC-82EA-A0908B13F923',4,4,7,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 388',-147.82,0,0,2,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('888EFCB5-FFEA-4449-B009-F718ACDBCADA',3,1,1,2015,'384E325E-ABE3-4490-9532-56B90E9A1A48','Test Line Item 389',676.02,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('1628A81D-D952-4564-9D18-22C3B45E227B',1,13,3,2015,'8125DB24-54E0-4B28-80BB-858D6111D64D','Test Line Item 390',-88.89,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,0,NOW()),
			 ('292DAA90-43D5-46E9-95AE-83BDEE709BD1',1,3,7,2015,'3E51C340-43CE-4726-9CBD-76600E1B7DF1','Test Line Item 391',-23,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,0,NOW()),
			 ('6E0E64B5-6CAB-482B-BCC7-0410B7F607B4',4,18,7,2015,'A886199A-3203-4DA7-9042-DB5518D199E6','Test Line Item 392',-47.85,0,0,2,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('6CC6318C-BA3F-469B-A238-2BE56B4C9DC2',4,1,4,2015,'43C269B0-6676-4B82-83CC-4BEB607AE442','Test Line Item 393',212.92,1,1,2,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('B6EC5B41-CFD4-45B9-896D-84A3EA327DEE',3,15,1,2015,'4F21EE9D-316F-40C2-8379-71F8D429FA11','Test Line Item 394',12.83,2,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('13EB69BA-F9B6-4D3E-98E2-C2D766BA0BFE',2,15,1,2015,'A886199A-3203-4DA7-9042-DB5518D199E6','Test Line Item 395',-35.82,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('D10B6BAB-0EE0-47B7-BB32-04980AE23465',2,8,1,2015,'A886199A-3203-4DA7-9042-DB5518D199E6','Test Line Item 396',-258.17,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('82BF21A4-6236-4534-97FC-B5B7145039B4',3,7,7,2015,'BCB2E098-7FA5-432E-8E7A-B7EA4C510002','Test Line Item 397',-638.76,0,0,1,'D6A03F18-D7E9-4C09-9490-EA8AB4F29D5E',0,0,NOW()),
			 ('A2D6B89F-DF4E-44A9-9595-8FA0ADE806E0',1,16,6,2015,'BCB2E098-7FA5-432E-8E7A-B7EA4C510002','Test Line Item 398',-198.39,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('FA9208C0-F0E1-4247-9583-CE918276529B',4,7,3,2015,'90DC03F2-B110-4B0C-B879-3EA157555DDF','Test Line Item 399',-420.25,0,0,2,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('62738230-86D7-4903-8123-5FEB3001956B',1,22,5,2015,'4ABE4F16-DA07-45EA-9345-1CA35CC37FA5','Test Line Item 400',-15.7,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,0,NOW()),
			 ('C9706AB6-DC6F-46E0-A11A-D6C9F217F916',4,4,7,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 401',-212.92,0,0,2,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('3D793BF5-EFF2-428D-AB68-0BFDB6ADC09C',2,16,2,2015,'FDE3F005-D3D4-4A10-B79E-112A011013CF','Test Line Item 402',-108.38,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('99D0C8AC-93B9-46C8-AE81-6E76F0AE8C4F',3,31,3,2015,'4F21EE9D-316F-40C2-8379-71F8D429FA11','Test Line Item 403',-115.99,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('6E46ACD6-AB24-495C-9416-259C0C32D4F1',4,16,5,2015,'C4CD23AC-5B64-4234-9515-9CC7EC92E577','Test Line Item 404',-319.38,0,0,2,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,1,NOW()),
			 ('495AE893-30B1-4FD8-A803-5D82D67BB946',2,22,1,2015,'2638253D-B50C-427F-B587-7703EB29BBBA','Test Line Item 405',-143.35,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('428EB63D-3953-48CC-B052-BB879D5F891B',3,9,2,2015,'BCB2E098-7FA5-432E-8E7A-B7EA4C510002','Test Line Item 406',79.84,2,1,1,'2F7552F5-E69E-48B2-9FE6-B125BDE851E4',0,0,NOW()),
			 ('C161F98A-B574-40FC-BEE2-06C7041C63DA',1,15,5,2015,'BCB2E098-7FA5-432E-8E7A-B7EA4C510002','Test Line Item 407',-100.87,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('70EA73FC-A184-4622-930A-1F0B9E5ECBD4',2,12,5,2015,'8125DB24-54E0-4B28-80BB-858D6111D64D','Test Line Item 408',-88.89,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('6A191B3C-4135-4366-B30E-07985B9763DC',1,1,5,2015,'1E6B1C48-31C9-4C7F-9C03-75BD81124A1D','Test Line Item 409',150.8,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('F1DFB879-610D-4219-AD0F-954A4B16E6C0',3,31,3,2015,'BBE64D1D-F8A1-46DE-8880-B700FA99D48C','Test Line Item 410',-202.97,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('40A80A22-B53B-4B36-A6E1-FAE61F7289DF',3,1,1,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 411',2129.2,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('E82C2A41-202F-49EA-8069-B04C7E30E607',3,21,7,2015,'A886199A-3203-4DA7-9042-DB5518D199E6','Test Line Item 412',-28.96,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('BF11AAD7-945E-4B31-A4DA-B924BBA09A71',1,9,6,2015,'8B5E5DC1-FC90-404E-A260-1F5155044E0F','Test Line Item 413',-92.83,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('AD2F455B-63D2-4D0E-AC2C-D19037E3A1EC',1,13,3,2015,'0BC45B85-D6ED-4A62-BD5E-A99A5A598432','Test Line Item 414',-630.67,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('29E912EE-10DD-4F0F-800C-7410AD411D33',1,14,4,2015,'BBE64D1D-F8A1-46DE-8880-B700FA99D48C','Test Line Item 415',-335.35,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('5BEAF0CC-57E8-4772-A1B8-CF673746F7DC',1,7,4,2015,'C4CD23AC-5B64-4234-9515-9CC7EC92E577','Test Line Item 416',-239.53,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('526DCEEB-FD49-47EA-ADA1-C39B6D74DB8C',3,12,5,2015,'39BA6ADF-6526-4D8A-A502-72468A9733F3','Test Line Item 417',-138.4,2,0,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('E628E757-CD6F-41A4-B8B5-792DCC99E33A',2,3,3,2015,'FFE5A167-FBCE-452C-A5E0-7AA8BDDA41B0','Test Line Item 418',-191.89,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('7FFECE01-BB31-4C6C-A6FA-EB9E9CC1EF6E',3,1,1,2015,'FDE3F005-D3D4-4A10-B79E-112A011013CF','Test Line Item 419',212.92,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('F1C4FAAE-D5FF-4C7C-9782-6671B8ADAD79',4,1,4,2015,'8B5E5DC1-FC90-404E-A260-1F5155044E0F','Test Line Item 420',798.45,1,1,2,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('1B1C6110-8D98-4C1C-8808-2B39A081EAC0',3,2,2,2015,'5AA0B1F1-64AE-43C2-9F31-3B1248728799','Test Line Item 421',49.24,2,1,1,'2F7552F5-E69E-48B2-9FE6-B125BDE851E4',0,0,NOW()),
			 ('D07C6A53-E333-454F-AA51-D11D8E56F002',3,25,4,2015,'C4CD23AC-5B64-4234-9515-9CC7EC92E577','Test Line Item 422',-239.53,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('353DE7E5-BB2E-4873-9F8F-C8D85ECAE5E7',4,1,4,2015,'6AC0FC1B-72C3-4595-B594-4117755A8307','Test Line Item 423',3486.56,1,1,2,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('C1842D44-81EE-4CCE-AF92-B55FB0DCB9D6',1,6,3,2015,'2638253D-B50C-427F-B587-7703EB29BBBA','Test Line Item 424',-29.65,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,0,NOW()),
			 ('960A13EA-2FE0-4A5F-A32B-B4E605053CB4',3,7,7,2015,'3E51C340-43CE-4726-9CBD-76600E1B7DF1','Test Line Item 425',-159.69,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('1F62699B-749C-4960-AD30-7D88460CC88B',3,1,1,2015,'20616ABA-8911-4523-ABA1-0E4E86EBCAF9','Test Line Item 426',638.76,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('62E71C23-2212-4707-8F52-35A4AF52FA10',2,1,1,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 427',2129.2,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('CF9F70F8-489E-4C97-A6EA-95093BF29A3C',4,12,1,2015,'8125DB24-54E0-4B28-80BB-858D6111D64D','Test Line Item 428',-89.11,0,0,2,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('572CD8ED-B328-402F-995A-D2C1AC1C7C7A',1,20,3,2015,'BCB2E098-7FA5-432E-8E7A-B7EA4C510002','Test Line Item 429',-26.56,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,0,NOW()),
			 ('088A0E48-198B-4FD5-9761-34817E0EEFA2',3,2,2,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 430',-53.23,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('B720BA8A-37F7-43AD-8144-71AA53A48A9D',2,7,7,2015,'C4CD23AC-5B64-4234-9515-9CC7EC92E577','Test Line Item 431',-35.66,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('CA1081C4-CBDF-4CC8-8401-F54A3E9A7679',1,1,5,2015,'90DC03F2-B110-4B0C-B879-3EA157555DDF','Test Line Item 432',691.99,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('4A13E938-C149-44CD-8A5A-193CA6E5E4AA',2,16,2,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 433',-319.22,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('8B619E27-490D-4802-8254-32D0A2A8B3AF',1,31,7,2015,'8B5E5DC1-FC90-404E-A260-1F5155044E0F','Test Line Item 434',-26.56,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,0,NOW()),
			 ('FA7409A6-0DAB-4E19-B4FE-72754B5E8E8B',1,1,5,2015,'39BA6ADF-6526-4D8A-A502-72468A9733F3','Test Line Item 435',2661.5,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('E87B0783-94DA-41B6-A3D0-8E23CC821BB7',4,1,4,2015,'C62DE4AF-3A37-4B84-9883-FFF41F847700','Test Line Item 436',138.4,1,1,2,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('61781174-E77C-4B5C-AB05-DC8F2046C969',4,1,4,2015,'4F21EE9D-316F-40C2-8379-71F8D429FA11','Test Line Item 437',212.92,1,1,2,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('89FE6707-9447-4F20-ABE8-01C83E6CE22D',1,21,4,2015,'C4CD23AC-5B64-4234-9515-9CC7EC92E577','Test Line Item 438',-239.53,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('56CA99CE-6A99-47D9-9233-D862C69BA9C9',2,7,7,2015,'A886199A-3203-4DA7-9042-DB5518D199E6','Test Line Item 439',-232.51,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('8C453831-51A2-4888-B09A-387CC888B18B',2,28,7,2015,'74801902-27FC-47F6-B6DE-B6D956FCDF34','Test Line Item 440',-51012.22,2,0,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('A2ED81E5-1513-49C7-86C3-B3005B5557BA',4,1,4,2015,'5363AD11-B0EC-4ABF-85D2-26487A7963E7','Test Line Item 441',106.46,1,1,2,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('AAC8159A-1CD7-479F-A5F1-629F656AA84E',4,11,7,2015,'A886199A-3203-4DA7-9042-DB5518D199E6','Test Line Item 442',-32.74,0,0,2,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('EFAF51C6-634E-4027-B994-6D6D2D56E443',2,16,2,2015,'BBE64D1D-F8A1-46DE-8880-B700FA99D48C','Test Line Item 443',-159.69,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,1,NOW()),
			 ('0281A104-4C86-4FAA-AAD5-55BB01B15FF3',2,1,1,2015,'7B7A6AB7-3D74-421B-BD50-96C7A7AE02A8','Test Line Item 444',448.04,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('307062D9-F3B6-4CC6-A5E9-7E13049D4DA5',3,1,1,2015,'1E6B1C48-31C9-4C7F-9C03-75BD81124A1D','Test Line Item 445',145.32,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('4AC6B242-5EEE-4E8E-A0AF-E3D9BAAF735E',2,22,1,2015,'BCB2E098-7FA5-432E-8E7A-B7EA4C510002','Test Line Item 446',-1502.15,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('DF95D44C-90EC-4031-BE50-8055E47E6AF0',4,1,4,2015,'384E325E-ABE3-4490-9532-56B90E9A1A48','Test Line Item 447',676.02,1,1,2,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('84B3DE63-E6FC-4CAE-B56A-ACC128F4BBAE',2,28,7,2015,'74801902-27FC-47F6-B6DE-B6D956FCDF34','Test Line Item 448',21427.63,2,1,1,'2F7552F5-E69E-48B2-9FE6-B125BDE851E4',0,0,NOW()),
			 ('295844E0-AC38-415E-961A-7B5EF04179EB',2,15,1,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 449',-47.85,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('A3B22A61-A2C2-4A45-8D80-8B3427CA47CC',3,1,1,2015,'2638253D-B50C-427F-B587-7703EB29BBBA','Test Line Item 450',638.76,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('8492AFD5-AF1F-4099-97FF-8AEDE8C4B58B',2,28,7,2015,'90DC03F2-B110-4B0C-B879-3EA157555DDF','Test Line Item 451',-141.91,2,0,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('2A3BC394-BFFC-47CF-BBD6-98010F13F621',4,1,4,2015,'20616ABA-8911-4523-ABA1-0E4E86EBCAF9','Test Line Item 452',638.76,1,1,2,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('AF0586D9-77C4-4617-A93C-39C45B6CA404',4,1,4,2015,'74801902-27FC-47F6-B6DE-B6D956FCDF34','Test Line Item 453',7867.98,1,1,2,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('AF9EE8FD-244C-4FA7-B04F-0020C62D652C',1,1,5,2015,'B1F4EBEE-ABBD-4501-A11F-3FFA4FEAFF8C','Test Line Item 454',2241.78,2,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('8EBDB4EF-73FF-4852-AC8D-935EFF73419E',3,1,1,2015,'74801902-27FC-47F6-B6DE-B6D956FCDF34','Test Line Item 455',-9.05,2,0,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('587E3006-EECB-43A7-BD96-D2CE08548E1D',1,1,5,2015,'BBE64D1D-F8A1-46DE-8880-B700FA99D48C','Test Line Item 456',90.07,2,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('76F17A9E-63EC-449D-A176-DB381D10D0CE',1,6,3,2015,'C4CD23AC-5B64-4234-9515-9CC7EC92E577','Test Line Item 457',-319.38,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('82D3CBE8-F92B-4455-A546-E3B3E2C70FBA',3,28,7,2015,'A886199A-3203-4DA7-9042-DB5518D199E6','Test Line Item 458',-214.41,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('AD061FBF-54DC-4385-964B-11EDC410A5BE',2,11,4,2015,'B1F4EBEE-ABBD-4501-A11F-3FFA4FEAFF8C','Test Line Item 459',-234.11,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('7317B21E-5422-479E-83DF-562B15CAC873',4,4,7,2015,'4F21EE9D-316F-40C2-8379-71F8D429FA11','Test Line Item 460',-143.14,0,0,2,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('D11A3A09-C371-4849-B3C8-446D852E0985',2,16,2,2015,'BBE64D1D-F8A1-46DE-8880-B700FA99D48C','Test Line Item 461',-73.78,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('41B167F5-AF39-4606-9381-681D404E4130',3,25,4,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 462',106.73,2,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('94A8A649-EB1E-497C-8B88-F70A5E7863F4',1,20,3,2015,'BCB2E098-7FA5-432E-8E7A-B7EA4C510002','Test Line Item 463',-26.56,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,0,NOW()),
			 ('18B7211A-76FB-4532-88CB-D023E1BB7099',2,15,1,2015,'4F21EE9D-316F-40C2-8379-71F8D429FA11','Test Line Item 464',-159.37,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('CABFB681-A15B-402F-862A-B2BFAB4AE439',3,13,6,2015,'74801902-27FC-47F6-B6DE-B6D956FCDF34','Test Line Item 465',0.21,2,1,1,'2F7552F5-E69E-48B2-9FE6-B125BDE851E4',0,0,NOW()),
			 ('F9143F5D-12BA-436B-8A31-A8A8A8401BAA',3,7,7,2015,'BCB2E098-7FA5-432E-8E7A-B7EA4C510002','Test Line Item 466',-5998.7,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('F2534DA0-0C29-48AF-B0FF-0FD3A5AEA52A',3,19,5,2015,'20616ABA-8911-4523-ABA1-0E4E86EBCAF9','Test Line Item 467',-726.11,0,0,1,'A3C285C0-A027-418A-8810-3177A96054A3',0,0,NOW()),
			 ('9FB4AF3C-E802-4E5D-8D68-25DDE18E9256',4,1,4,2015,'CA9625CF-8A39-4754-888B-E653203FA725','Test Line Item 468',-2262.27,3,2,2,'97824A38-B1DD-4885-B24B-A46E459A5AB0',3,0,NOW()),
			 ('2455F278-BDCE-4E20-A21A-4DAB8AABEFE7',4,3,6,2015,'81690BD3-8C3F-47D1-B874-433DB1482EF6','Test Line Item 469',-894,0,0,2,'6580A957-EC90-4987-B763-56F1072FD295',0,0,NOW()),
			 ('9B505D45-5DDA-4492-A21F-263758647A44',3,15,1,2015,'302D08BD-D007-4B1F-96F0-111FCB1683BE','Test Line Item 470',-249.65,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('6DDF9A81-3392-4F48-BBDC-5191DAAA3C9C',3,2,2,2015,'A886199A-3203-4DA7-9042-DB5518D199E6','Test Line Item 471',-19.16,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('CBFF4957-E3E9-4CFB-BF06-E2C5265DD15E',1,15,5,2015,'71D83AC4-0F57-4936-BB59-38C50E692E3F','Test Line Item 472',-1596.9,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,0,NOW()),
			 ('495BA933-84B5-4946-A127-1822E28EEEA7',3,8,1,2015,'384E325E-ABE3-4490-9532-56B90E9A1A48','Test Line Item 473',-676.02,0,0,1,'6580A957-EC90-4987-B763-56F1072FD295',0,0,NOW()),
			 ('00DAB3A9-2AF0-4264-82C0-6A418F8DA306',4,1,4,2015,'71D83AC4-0F57-4936-BB59-38C50E692E3F','Test Line Item 474',1596.9,1,1,2,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('7ACFDA33-D254-488C-87DA-038C2F47B7BD',1,31,7,2015,'2638253D-B50C-427F-B587-7703EB29BBBA','Test Line Item 475',-136.85,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,0,NOW()),
			 ('F10F2E5D-AC42-486E-8A98-18C6424E7C61',4,1,4,2015,'39BA6ADF-6526-4D8A-A502-72468A9733F3','Test Line Item 476',-526.98,0,0,2,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('25730FB6-CD8D-4E55-B119-AF98704C4418',3,10,3,2015,'7B7A6AB7-3D74-421B-BD50-96C7A7AE02A8','Test Line Item 477',-443.3,0,0,1,'A3C285C0-A027-418A-8810-3177A96054A3',0,0,NOW()),
			 ('27069B1D-63E2-4E6E-8DD7-10CA576FE38E',1,8,5,2015,'FDE3F005-D3D4-4A10-B79E-112A011013CF','Test Line Item 478',-74.47,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,0,NOW()),
			 ('73A32827-FB87-4B2A-B386-DA5C1E8A9468',3,31,3,2015,'4F21EE9D-316F-40C2-8379-71F8D429FA11','Test Line Item 479',115.99,2,1,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('7021CDE8-FE5D-4499-8483-EC09427214F3',1,1,5,2015,'97E08362-5E98-4156-B3F1-80AFB8FCB9C5','Test Line Item 480',638.76,2,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('8DE9786C-023D-4018-9D81-0A882E8FF3A2',1,1,5,2015,'8B5E5DC1-FC90-404E-A260-1F5155044E0F','Test Line Item 481',678.04,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('F735D5F7-9537-4F51-8C6C-9DB8A7909CC7',3,25,4,2015,'8B5E5DC1-FC90-404E-A260-1F5155044E0F','Test Line Item 482',121.05,2,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('5D8F3B9F-B956-4C62-943F-117562334B4C',2,1,1,2015,'6AC0FC1B-72C3-4595-B594-4117755A8307','Test Line Item 483',4590.18,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('68C1CA04-0537-42FF-BD21-DB313093235A',4,5,1,2015,'FDE3F005-D3D4-4A10-B79E-112A011013CF','Test Line Item 484',-75.69,0,0,2,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('ED0E5DC7-F1A3-4EA8-AB01-AEE22ED2711B',3,13,6,2015,'74801902-27FC-47F6-B6DE-B6D956FCDF34','Test Line Item 485',16143.96,2,1,1,'2F7552F5-E69E-48B2-9FE6-B125BDE851E4',0,0,NOW()),
			 ('3811379C-26E4-4456-B21B-09B487B378AE',1,5,2,2015,'2638253D-B50C-427F-B587-7703EB29BBBA','Test Line Item 486',-85.65,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,0,NOW()),
			 ('5F656671-F5D4-46B2-B30B-CDEB3642B527',4,7,3,2015,'C4CD23AC-5B64-4234-9515-9CC7EC92E577','Test Line Item 487',-319.38,0,0,2,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('68C87B70-D298-4899-A951-F96F0B58D57B',3,2,2,2015,'5AA0B1F1-64AE-43C2-9F31-3B1248728799','Test Line Item 488',-78.25,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('C584C08A-2123-4811-AF2C-52E10D112F2E',2,1,1,2015,'FDE3F005-D3D4-4A10-B79E-112A011013CF','Test Line Item 489',532.3,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('65D5FB39-197E-4C79-806A-56D320129DB7',4,10,6,2015,'A886199A-3203-4DA7-9042-DB5518D199E6','Test Line Item 490',-211.91,0,0,2,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('F71F897D-412A-4362-92E7-8C2CC17CEDB9',1,1,5,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 491',1695.64,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('83EF605E-E6D0-4FAD-B467-4064469F2BA5',1,9,6,2015,'82B2A266-5181-45D7-8610-2F9213A397ED','Test Line Item 492',-420.46,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('1E622B57-F7BC-4DB7-AD6B-95D66554C2E0',3,13,6,2015,'71D83AC4-0F57-4936-BB59-38C50E692E3F','Test Line Item 493',-1596.9,0,0,1,'6580A957-EC90-4987-B763-56F1072FD295',0,0,NOW()),
			 ('A712B4C9-A2A5-4724-9881-086D34B8FEDA',2,1,1,2015,'90DC03F2-B110-4B0C-B879-3EA157555DDF','Test Line Item 494',691.99,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('3C460EF1-FB7A-4AF4-B4AE-D0C90FEFB8B3',4,12,1,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 495',-27.36,0,0,2,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('F4E45845-77BE-45A0-9251-2C1DD361BEE8',3,1,1,2015,'A886199A-3203-4DA7-9042-DB5518D199E6','Test Line Item 496',1863.05,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('F87BF4E5-3E2B-4B8C-A395-685AEDCCBD6F',1,1,5,2015,'0BC45B85-D6ED-4A62-BD5E-A99A5A598432','Test Line Item 497',630.67,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('E4480C9D-C6EC-4159-9D37-0598205AFC0E',4,14,3,2015,'74801902-27FC-47F6-B6DE-B6D956FCDF34','Test Line Item 498',0.27,2,1,2,'2F7552F5-E69E-48B2-9FE6-B125BDE851E4',0,0,NOW()),
			 ('4D407BF8-0215-486F-9FE6-08B88E0AFC2A',3,15,1,2015,'39BA6ADF-6526-4D8A-A502-72468A9733F3','Test Line Item 499',-79.74,2,0,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('F9E38122-A509-41CD-A057-ED2FC75EA351',1,1,5,2015,'4F21EE9D-316F-40C2-8379-71F8D429FA11','Test Line Item 500',26.03,2,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('8B6BF1F6-4C44-4F5A-A2DE-D9EBA6CD4555',3,1,1,2015,'74801902-27FC-47F6-B6DE-B6D956FCDF34','Test Line Item 501',141.91,2,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('18FEBF86-30C1-41BC-82B2-00EE4B4D916B',1,1,5,2015,'43C269B0-6676-4B82-83CC-4BEB607AE442','Test Line Item 502',584.52,2,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('B0EB0506-FB20-4E68-8A55-E5F2A2A12987',4,19,1,2015,'A886199A-3203-4DA7-9042-DB5518D199E6','Test Line Item 503',-163.2,0,0,2,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('AB266936-6FDF-469E-B33C-FBF6194A531D',2,12,5,2015,'5AA0B1F1-64AE-43C2-9F31-3B1248728799','Test Line Item 504',-1150.09,3,2,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',3,0,NOW()),
			 ('BB593A36-B92C-4518-955A-6ADD4E7939B9',3,12,5,2015,'C62DE4AF-3A37-4B84-9883-FFF41F847700','Test Line Item 505',138.4,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('D8609FA2-0610-400B-A7BC-1A23BE2C7DB2',2,9,2,2015,'C4CD23AC-5B64-4234-9515-9CC7EC92E577','Test Line Item 506',-319.38,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('3C6B6013-04E8-4E11-A66D-F47298FDBAED',3,28,7,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 507',-106.46,0,0,1,'D6A03F18-D7E9-4C09-9490-EA8AB4F29D5E',0,0,NOW()),
			 ('02068074-F232-4CDF-9476-C6E23EC469D6',3,16,2,2015,'8B5E5DC1-FC90-404E-A260-1F5155044E0F','Test Line Item 508',-361.96,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('B319C2C7-7D5B-4FBA-974C-C34012025BB7',4,1,4,2015,'C4CD23AC-5B64-4234-9515-9CC7EC92E577','Test Line Item 509',1596.9,1,1,2,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('2F497EA9-4178-40EA-8DD9-E4B3FB948B65',2,9,2,2015,'4F21EE9D-316F-40C2-8379-71F8D429FA11','Test Line Item 510',-186.46,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('53D25CCD-31BE-4F60-994B-0F916BCE63C4',4,1,4,2015,'0BC45B85-D6ED-4A62-BD5E-A99A5A598432','Test Line Item 511',638.76,1,1,2,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('F60AF020-02F9-47B9-9F6C-4D38E05D9E6A',1,1,5,2015,'9B26784E-67A3-4BBA-9DCE-D06E33ED84D3','Test Line Item 512',284.73,2,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('EC48BF96-6256-4ADF-B79B-43BA80EE8CCE',1,14,4,2015,'BBE64D1D-F8A1-46DE-8880-B700FA99D48C','Test Line Item 513',-419.13,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,0,NOW()),
			 ('F549E5E6-5264-4909-BEF8-5DFF2265CA13',3,1,1,2015,'5AA0B1F1-64AE-43C2-9F31-3B1248728799','Test Line Item 514',494.13,2,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('BF6F4C79-1558-4C29-91C6-A803A4B77B53',1,1,5,2015,'43C269B0-6676-4B82-83CC-4BEB607AE442','Test Line Item 515',266.15,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('6E6ADFE5-392E-4C08-B8D1-7DE94506652B',4,18,7,2015,'A886199A-3203-4DA7-9042-DB5518D199E6','Test Line Item 516',-149.95,0,0,2,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,1,NOW()),
			 ('A3703BB8-E067-42A1-9111-4CDD367EC00F',2,1,1,2015,'5363AD11-B0EC-4ABF-85D2-26487A7963E7','Test Line Item 517',106.46,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('0712DC0D-8BBC-4FF5-BE86-8CD52F3979C3',3,1,1,2015,'D88C9DA1-3788-404C-B3A0-72B371CC171F','Test Line Item 518',532.3,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('D1B9AEB5-44A4-49E4-A4D5-4E025FB9F759',3,28,7,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 519',-336.31,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('6D3529D5-195B-40B7-8D1E-504B9C4B66E7',3,15,1,2015,'39BA6ADF-6526-4D8A-A502-72468A9733F3','Test Line Item 520',-12.83,2,0,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('974F3416-4C6D-4DC7-BB69-A0D586E67FF6',3,12,5,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 521',-17.46,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('A347C921-3EC8-407C-B94D-4F4F41BE33B2',2,15,1,2015,'8B5E5DC1-FC90-404E-A260-1F5155044E0F','Test Line Item 522',-21.24,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('983D1AFB-0E21-432A-95E4-1B97433B472A',3,31,3,2015,'39BA6ADF-6526-4D8A-A502-72468A9733F3','Test Line Item 523',-214.73,2,0,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('19102AA6-2D4E-43E0-BA73-C7C8A916E9A3',4,15,4,2015,'74801902-27FC-47F6-B6DE-B6D956FCDF34','Test Line Item 524',16143.91,2,1,2,'2F7552F5-E69E-48B2-9FE6-B125BDE851E4',0,0,NOW()),
			 ('7D63A8E1-8FAD-4D85-9202-7A922D0BBE45',3,10,3,2015,'74801902-27FC-47F6-B6DE-B6D956FCDF34','Test Line Item 525',691.99,2,1,1,'2F7552F5-E69E-48B2-9FE6-B125BDE851E4',0,0,NOW()),
			 ('DA1E4395-85AB-48A5-82FE-D85E1299C2D1',3,16,2,2015,'0BC45B85-D6ED-4A62-BD5E-A99A5A598432','Test Line Item 526',-630.99,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('AB7D59E7-029B-4C39-BD88-CF556952E4BA',3,19,5,2015,'A886199A-3203-4DA7-9042-DB5518D199E6','Test Line Item 527',-92.51,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('EBBCC9E1-6507-4AE4-BD08-8F02322664D1',2,5,5,2015,'74801902-27FC-47F6-B6DE-B6D956FCDF34','Test Line Item 528',691.99,2,1,1,'2F7552F5-E69E-48B2-9FE6-B125BDE851E4',0,0,NOW()),
			 ('D8DF9601-7C9B-402B-AB5B-A0BC9B0DECB3',1,8,5,2015,'A886199A-3203-4DA7-9042-DB5518D199E6','Test Line Item 529',-127.11,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,0,NOW()),
			 ('943565CB-A96B-4BDB-95B4-AADB87E51537',4,1,4,2015,'CA9625CF-8A39-4754-888B-E653203FA725','Test Line Item 530',452.45,2,1,2,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('2F3F7832-5580-4A66-8956-95CE3E9C7CAE',2,1,1,2015,'43C269B0-6676-4B82-83CC-4BEB607AE442','Test Line Item 531',266.15,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('4FCF4857-0BF4-4A17-8839-D468BF61CB78',3,31,3,2015,'74801902-27FC-47F6-B6DE-B6D956FCDF34','Test Line Item 532',16143.91,2,0,1,'2F7552F5-E69E-48B2-9FE6-B125BDE851E4',0,0,NOW()),
			 ('E93583D3-F727-4F50-B7DA-42504875BBB2',3,1,1,2015,'C4CD23AC-5B64-4234-9515-9CC7EC92E577','Test Line Item 533',9.05,2,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('1F2B0133-15FD-4D97-B520-DC87C33EB7D1',2,24,3,2015,'90DC03F2-B110-4B0C-B879-3EA157555DDF','Test Line Item 534',-164,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('11CF7CEF-D904-40FF-A9DB-FD0873E40F61',2,19,5,2015,'C4CD23AC-5B64-4234-9515-9CC7EC92E577','Test Line Item 535',-239.53,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('B3734E7A-A0A8-4745-ABE5-3B8945B9CB3C',4,13,2,2015,'39BA6ADF-6526-4D8A-A502-72468A9733F3','Test Line Item 536',-452.35,0,0,2,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('82AC348F-7646-4B9C-A020-F9F9294450BF',2,21,7,2015,'74801902-27FC-47F6-B6DE-B6D956FCDF34','Test Line Item 537',2224.37,2,1,1,'2F7552F5-E69E-48B2-9FE6-B125BDE851E4',0,0,NOW()),
			 ('F5B44AB2-8E22-4042-A513-DB31762C8118',3,21,7,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 538',-7.93,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('06F5AFCC-F35F-4A06-9F35-D5321991C00D',1,1,5,2015,'5363AD11-B0EC-4ABF-85D2-26487A7963E7','Test Line Item 539',311.61,2,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('10A620CE-3B86-4E25-ABCC-DD031DC4216F',1,18,1,2015,'BCB2E098-7FA5-432E-8E7A-B7EA4C510002','Test Line Item 540',-4546.53,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('BD5425BA-306B-4509-807D-F56B3D64666A',1,14,4,2015,'D88C9DA1-3788-404C-B3A0-72B371CC171F','Test Line Item 541',-11.5,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,0,NOW()),
			 ('80AA62BA-F645-40AB-BB0C-D69989239414',2,1,1,2015,'81690BD3-8C3F-47D1-B874-433DB1482EF6','Test Line Item 542',894,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('0F140B2D-C019-497E-A808-44188F476B5C',2,11,4,2015,'90DC03F2-B110-4B0C-B879-3EA157555DDF','Test Line Item 543',-420.25,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('FEB29C9D-9AB7-422C-AA05-D483B956F086',2,27,6,2015,'8B5E5DC1-FC90-404E-A260-1F5155044E0F','Test Line Item 544',-5.06,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('0F82D630-1E84-4077-9BE2-A946101FA0EE',3,1,1,2015,'82B2A266-5181-45D7-8610-2F9213A397ED','Test Line Item 545',420.46,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('B39C378C-9E7C-4419-8E46-AA8569B06888',1,24,7,2015,'A886199A-3203-4DA7-9042-DB5518D199E6','Test Line Item 546',-78.83,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,0,NOW()),
			 ('5292D756-D6A7-4AA1-B5A2-0C37DC5BB07E',1,9,6,2015,'8B5E5DC1-FC90-404E-A260-1F5155044E0F','Test Line Item 547',-27.95,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,0,NOW()),
			 ('C1E672C6-6677-4ABB-A9C6-C7B1C18ED7F0',2,28,7,2015,'2638253D-B50C-427F-B587-7703EB29BBBA','Test Line Item 548',-266.15,2,0,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('3DF6F0F7-0999-47B9-B8BF-8A6E7B290CD9',3,8,1,2015,'2638253D-B50C-427F-B587-7703EB29BBBA','Test Line Item 549',-225.59,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('AED05AC0-445F-4124-B4DB-C45A3A20BFB9',3,1,1,2015,'FFE5A167-FBCE-452C-A5E0-7AA8BDDA41B0','Test Line Item 550',728.88,2,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('F55150E7-C203-4DDD-9050-9546255E9D5B',1,16,6,2015,'9B26784E-67A3-4BBA-9DCE-D06E33ED84D3','Test Line Item 551',-26.08,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('124816C0-EA7E-43A2-BD8C-2528818E3A69',2,16,2,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 552',-102.95,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('1DB528B8-C9E8-4059-899B-BE1184E87FC4',4,18,7,2015,'C4CD23AC-5B64-4234-9515-9CC7EC92E577','Test Line Item 553',-2.77,0,0,2,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('A820D9FC-0375-4EB2-8B7A-C1B3DF9C13E7',4,1,4,2015,'2638253D-B50C-427F-B587-7703EB29BBBA','Test Line Item 554',638.76,1,1,2,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('3D891B27-8A4E-4AA3-8BBF-0B0A60EC442E',5,1,6,2015,'302D08BD-D007-4B1F-96F0-111FCB1683BE','Test Line Item 555',1181.71,1,1,2,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,1,NOW()),
			 ('CD44F331-0434-4BA1-A50C-AD99A4A82006',4,1,4,2015,'0EAB9B99-4BC4-4B54-8E08-024A8A4BCAD6','Test Line Item 556',1755.9,1,1,2,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('D2D9F979-3673-4743-A739-0CEEF8E712CE',2,11,4,2015,'74801902-27FC-47F6-B6DE-B6D956FCDF34','Test Line Item 557',0.21,2,1,1,'2F7552F5-E69E-48B2-9FE6-B125BDE851E4',0,0,NOW()),
			 ('F3C95616-9D64-496B-B85F-6C960732EE74',3,11,4,2015,'39BA6ADF-6526-4D8A-A502-72468A9733F3','Test Line Item 558',-732.18,2,0,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('00770D74-3FA7-40EE-A3B3-137D025DFFF3',1,6,3,2015,'BCB2E098-7FA5-432E-8E7A-B7EA4C510002','Test Line Item 559',-45.62,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,0,NOW()),
			 ('B3C8282E-7348-452B-B6A6-A336649FED1F',2,1,1,2015,'BBE64D1D-F8A1-46DE-8880-B700FA99D48C','Test Line Item 560',-52.22,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,0,NOW()),
			 ('1A4115AA-100E-4122-AF73-21F50825B892',2,23,2,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 561',-2.93,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('299B9E8E-26E5-4DCC-9B48-927B3B5C412D',1,2,6,2015,'2638253D-B50C-427F-B587-7703EB29BBBA','Test Line Item 562',-79.26,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,0,NOW()),
			 ('2E07D01D-E6BF-4D5B-B311-0279EEBB64F8',2,13,6,2015,'A886199A-3203-4DA7-9042-DB5518D199E6','Test Line Item 563',-23.95,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('4CCBC16C-1DE7-42F8-A30E-50388D2E5766',4,10,6,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 564',-45.14,0,0,2,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('A6E64E36-D3D0-4490-BDA3-9ED957EEE5AC',2,21,7,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 565',-153.04,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('074A7963-6985-47E3-A2A0-9D8CF21D42B2',1,5,2,2015,'90DC03F2-B110-4B0C-B879-3EA157555DDF','Test Line Item 566',-369.74,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,0,NOW()),
			 ('0E95AB03-B322-4F3E-8525-914F674B8953',2,18,4,2015,'BCB2E098-7FA5-432E-8E7A-B7EA4C510002','Test Line Item 567',-59.62,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('CA51D5B8-4722-4255-80D5-18B54C0F186C',4,1,4,2015,'81690BD3-8C3F-47D1-B874-433DB1482EF6','Test Line Item 568',894,1,1,2,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('0A4AE7B1-23C9-4BDA-A643-24F0836F7F92',4,11,7,2015,'2638253D-B50C-427F-B587-7703EB29BBBA','Test Line Item 569',-202.11,0,0,2,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('D2E4242D-A392-4E38-B8ED-C49E06FF9985',3,19,5,2015,'FFE5A167-FBCE-452C-A5E0-7AA8BDDA41B0','Test Line Item 570',-95.81,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,1,NOW()),
			 ('6C225467-8738-48BA-88C9-19301E415344',2,28,7,2015,'BBE64D1D-F8A1-46DE-8880-B700FA99D48C','Test Line Item 571',-133.07,2,0,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('2E6702FB-BC86-40F8-AE45-58C18473A08C',4,16,5,2015,'C4CD23AC-5B64-4234-9515-9CC7EC92E577','Test Line Item 572',-6.39,0,0,2,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('09144B0B-E0B9-4597-AD1C-4AD439576D1E',4,4,7,2015,'C4CD23AC-5B64-4234-9515-9CC7EC92E577','Test Line Item 573',-30.34,0,0,2,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('C83AC630-0FCB-48BC-9C4C-08AA29FD45B5',1,21,4,2015,'BCB2E098-7FA5-432E-8E7A-B7EA4C510002','Test Line Item 574',-10.65,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('B427E307-E8EE-40D4-804B-D7F2FE70983D',1,5,2,2015,'BCB2E098-7FA5-432E-8E7A-B7EA4C510002','Test Line Item 575',-89,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,0,NOW()),
			 ('E02DBC7C-F772-447B-96BF-9AAB7519B70B',3,12,5,2015,'8125DB24-54E0-4B28-80BB-858D6111D64D','Test Line Item 576',-88.89,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('7F2E7AB1-E4B4-405B-96D4-29AA71C21225',4,3,6,2015,'BBE64D1D-F8A1-46DE-8880-B700FA99D48C','Test Line Item 577',-93.15,0,0,2,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW()),
			 ('3BDD2EC8-6C0A-438A-A127-0A85D6B8C7B8',4,1,4,2015,'74801902-27FC-47F6-B6DE-B6D956FCDF34','Test Line Item 578',-526.98,1,0,2,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('AFFCB4B5-E0BA-4954-B82F-EA1E8D9C5A8E',3,11,4,2015,'B1F4EBEE-ABBD-4501-A11F-3FFA4FEAFF8C','Test Line Item 579',-234.11,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('8097BF5A-25CB-465D-9280-A257A2B270E1',3,4,4,2015,'8B5E5DC1-FC90-404E-A260-1F5155044E0F','Test Line Item 580',-732.18,0,0,1,'66798E19-15F0-4AD8-800B-2CC5255F8C6F',0,0,NOW()),
			 ('F9445477-4ABF-4CC7-9B2E-844ECC6655C3',3,17,3,2015,'2638253D-B50C-427F-B587-7703EB29BBBA','Test Line Item 581',-204.51,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,1,NOW()),
			 ('71C8FBB4-BA09-40BB-B01A-26B6B0779C09',1,8,5,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 582',-107.05,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,0,NOW()),
			 ('51A6C8B1-8334-49C0-9FC5-9D5A33D94DA4',1,1,5,2015,'3E51C340-43CE-4726-9CBD-76600E1B7DF1','Test Line Item 583',253,1,1,1,'97824A38-B1DD-4885-B24B-A46E459A5AB0',0,0,NOW()),
			 ('F26C128A-7EAC-4B7E-B346-99A6C36BD9B4',1,22,5,2015,'4ABE4F16-DA07-45EA-9345-1CA35CC37FA5','Test Line Item 584',-44.98,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,0,NOW()),
			 ('8F956F53-B77D-4EBB-91AE-6576C7C6EF6B',1,28,4,2015,'C4CD23AC-5B64-4234-9515-9CC7EC92E577','Test Line Item 585',-102.47,0,0,1,'878BA1FC-4DC5-4219-A581-3A81A16EAAAE',0,0,NOW()),
			 ('47F4789B-E0F8-47EA-8CCB-983F2F06C88C',3,23,2,2015,'E4C5A03D-9A9F-4D5D-BD14-5B51730BA1B1','Test Line Item 586',-74.15,0,0,1,'1117AFEB-3933-46C1-A6F1-7033DE501727',0,0,NOW());

-- Truncate the BudgetAllowances Table
TRUNCATE TABLE BudgetAllowances;

-- Build it from test data
INSERT INTO BudgetAllowances
SELECT
  a.AccountName,
	c.CategoryName,
	sc.SubcategoryName,
	CASE
		WHEN ri.ReconciledAmount IS NULL THEN 0.0
		ELSE ri.ReconciledAmount
	END AS ReconciledAmount,
	CASE 
		WHEN pi.PendingAmount IS NULL THEN 0.0
		ELSE pi.PendingAmount
	END AS PendingAmount,
	CASE
		WHEN ri.LatestTxnDate IS NULL AND pi.LatestTxnDate IS NULL THEN null
		WHEN ri.LatestTxnDate IS NOT NULL AND pi.LatestTxnDate IS NULL THEN ri.LatestTxnDate
		WHEN ri.LatestTxnDate IS NULL AND pi.LatestTxnDate IS NOT NULL THEN pi.LatestTxnDate
		WHEN ri.LatestTxnDate >= pi.LatestTxnDate THEN ri.LatestTxnDate
		ELSE pi.LatestTxnDate
	END AS LatestTransactionDate
FROM
	dimSubcategory sc
	INNER JOIN
	dimCategory c
	ON sc.CategoryKey = c.CategoryKey
  INNER JOIN
  dimAccount a
  ON sc.AccountKey = a.AccountKey
	LEFT OUTER JOIN
	(SELECT
		fli.SubcategoryKey,
		SUM(fli.Amount) AS ReconciledAmount,
		MAX(fli.LastUpdatedDate) AS LatestTxnDate
	FROM
		factLineItem fli
	WHERE
		fli.StatusId = 0 -- reconciled items only
	GROUP BY
		fli.SubcategoryKey) AS ri
	ON sc.SubcategoryKey = ri.SubcategoryKey
	LEFT OUTER JOIN
	(SELECT
		fli.SubcategoryKey,
		SUM(fli.Amount) AS PendingAmount,
		MAX(fli.LastUpdatedDate) AS LatestTxnDate
	FROM
		factLineItem fli
	WHERE
		fli.StatusId = 1 -- pending items only
	GROUP BY
		fli.SubcategoryKey) AS pi
	ON sc.SubcategoryKey = pi.SubcategoryKey;
                           
SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
