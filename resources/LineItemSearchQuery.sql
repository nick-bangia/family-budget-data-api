SET @uniqueKey = ?;
SET @dateCompareOperator = ?;
SET @minDate = ?;
SET @maxDate = ?;
SET @year = ?;
SET @quarter = ?;
SET @month = ?;
SET @day = ?;
SET @dayOfWeek = ?;
SET @descriptionContains = ?;
SET @categoryKey = ?;
SET @subcategoryKey = ?;
SET @amountCompareOperator = ?;
SET @minAmount = ?;
SET @maxAmount = ?;
SET @type = ?;
SET @subtype = ?;
SET @paymentMethodKey = ?;
SET @status = ?;
SET @updatedAfter = ?;

SELECT
	`fli`.`UniqueKey` AS `UniqueKey`,
	`fli`.`MonthId` AS `MonthId`,
	`m`.`MonthName` AS `Month`,
	`fli`.`DayOfMonth` AS `DayOfMonth`,
	`fli`.`DayOfWeekId` AS `DayOfWeekId`,
	`dow`.`DayOfWeekName` AS `DayOfWeek`,
	`fli`.`Year` AS `Year`,
	`c`.`CategoryKey`,
	`c`.`CategoryName`,
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
	`sc`.`IsGoal`,
	`fli`.`LastUpdatedDate` AS `LastUpdatedDate`
FROM
	factLineItem fli
	INNER JOIN
	dimSubcategory sc ON fli.SubcategoryKey = sc.SubcategoryKey
	INNER JOIN
	dimCategory c ON sc.CategoryKey = c.CategoryKey
	INNER JOIN
	Months m ON fli.MonthId = m.MonthId
	INNER JOIN
	DaysOfWeek dow ON fli.DayOfWeekId = dow.DayOfWeekId
	INNER JOIN
	dimAccount a ON sc.AccountKey = a.AccountKey
	INNER JOIN
	dimPaymentMethod pm ON fli.PaymentMethodKey = pm.PaymentMethodKey
WHERE
	(@uniqueKey IS NULL OR @uniqueKey = fli.UniqueKey)
	AND ((@minDate IS NULL AND @maxDate IS NULL) 
			OR ((@dateCompareOperator IS NULL AND @minDate IS NOT NULL AND 
				 @minDate = str_to_date(CONCAT(fli.Year, '-', fli.MonthId, '-', fli.DayOfMonth), '%Y-%m-%d'))) 
			OR ((@dateCompareOperator = 'gte' AND @minDate IS NOT NULL AND
				 str_to_date(CONCAT(fli.Year, '-', fli.MonthId, '-', fli.DayOfMonth), '%Y-%m-%d') >= @minDate))
			OR ((@dateCompareOperator = 'lte' AND @minDate IS NOT NULL AND
				 str_to_date(CONCAT(fli.Year, '-', fli.MonthId, '-', fli.DayOfMonth), '%Y-%m-%d') <= @minDate))
			OR ((@dateCompareOperator = 'gt' AND @minDate IS NOT NULL AND
				 str_to_date(CONCAT(fli.Year, '-', fli.MonthId, '-', fli.DayOfMonth), '%Y-%m-%d') > @minDate))
			OR ((@dateCompareOperator = 'lt' AND @minDate IS NOT NULL AND
				 str_to_date(CONCAT(fli.Year, '-', fli.MonthId, '-', fli.DayOfMonth), '%Y-%m-%d') < @minDate))
			OR ((@dateCompareOperator = 'eq' AND @minDate IS NOT NULL AND
				 str_to_date(CONCAT(fli.Year, '-', fli.MonthId, '-', fli.DayOfMonth), '%Y-%m-%d') = @minDate))
			OR ((@dateCompareOperator = 'ne' AND @minDate IS NOT NULL AND
				 str_to_date(CONCAT(fli.Year, '-', fli.MonthId, '-', fli.DayOfMonth), '%Y-%m-%d') <> @minDate))
			OR ((@dateCompareOperator = 'btw' AND @minDate IS NOT NULL AND @maxDate IS NOT NULL AND
				 str_to_date(CONCAT(fli.Year, '-', fli.MonthId, '-', fli.DayOfMonth), '%Y-%m-%d') >= @minDate AND
				 str_to_date(CONCAT(fli.Year, '-', fli.MonthId, '-', fli.DayOfMonth), '%Y-%m-%d') <= @maxDate))
		)
	AND (@year IS NULL OR @year = fli.Year)
	AND (@quarter IS NULL OR @quarter = fli.Quarter)
	AND (@month IS NULL OR @month = fli.MonthId)
	AND (@day IS NULL OR @day = fli.DayOfMonth)
	AND (@dayOfWeek IS NULL OR @dayOfWeek = fli.DayOfWeekId)
	AND (@descriptionContains IS NULL OR fli.Description LIKE @descriptionContains COLLATE utf8_unicode_ci)
	AND (@categoryKey IS NULL OR sc.CategoryKey = @categoryKey COLLATE utf8_unicode_ci)
	AND (@subcategoryKey IS NULL OR fli.SubcategoryKey = @subcategoryKey COLLATE utf8_unicode_ci)
	AND ((@minAmount IS NULL AND @maxAmount IS NULL)
			OR ((@amountCompareOperator IS NULL AND @minAmount IS NOT NULL AND
				 @minAmount = fli.Amount))
			OR ((@amountCompareOperator = 'gte' AND @minAmount IS NOT NULL AND
				 fli.Amount >= @minAmount))
			OR ((@amountCompareOperator = 'lte' AND @minAmount IS NOT NULL AND
				 fli.Amount <= @minAmount))
			OR ((@amountCompareOperator = 'gt' AND @minAmount IS NOT NULL AND
				 fli.Amount > @minAmount))
			OR ((@amountCompareOperator = 'lt' AND @minAmount IS NOT NULL AND
				 fli.Amount < @minAmount))
			OR ((@amountCompareOperator = 'eq' AND @minAmount IS NOT NULL AND
				 fli.Amount = @minAmount))
			OR ((@amountCompareOperator = 'ne' AND @minAmount IS NOT NULL AND
				 fli.Amount <> @minAmount))
			OR ((@amountCompareOperator = 'btw' AND @minAmount IS NOT NULL AND @maxAmount IS NOT NULL AND
				 fli.Amount >= @minAmount AND fli.Amount <= @maxAmount))
		)
	AND (@type IS NULL OR @type = fli.TypeId)
	AND (@subtype IS NULL OR @subtype = fli.SubtypeId)
	AND (@paymentMethodKey IS NULL OR @paymentMethodKey = fli.PaymentMethodKey COLLATE utf8_unicode_ci)
	AND (@status IS NULL OR @status = fli.StatusId)
	AND (@updatedAfter IS NULL OR fli.LastUpdatedDate >= @updatedAfter)
ORDER BY
	fli.Year,
	fli.MonthId,
	fli.DayOfMonth;