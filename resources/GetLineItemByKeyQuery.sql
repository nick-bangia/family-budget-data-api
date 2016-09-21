SELECT 
	fli.UniqueKey,
	fli.MonthId, 
	m.MonthName,
	fli.DayOfMonth, 
	fli.DayOfWeekId,
	dow.DayOfWeekName,
	fli.Year, 
	c.CategoryKey,
	c.CategoryName,
	fli.SubcategoryKey,
	sc.SubcategoryName,
	sc.SubcategoryPrefix,
	fli.Description, 
	fli.Amount, 
	fli.TypeId, 
	fli.SubtypeId, 
	fli.Quarter, 
	fli.PaymentMethodKey,
	pm.PaymentMethodName,
	a.AccountName,
    g.GoalAmount,
	fli.StatusId,
    fli.IsTaxDeductible,
	fli.LastUpdatedDate
FROM 
	factLineItem fli
	INNER JOIN
	dimSubcategory sc ON fli.SubcategoryKey = sc.SubcategoryKey
	INNER JOIN
	dimCategory c on sc.CategoryKey = c.CategoryKey
	INNER JOIN
	dimAccount a on sc.AccountKey = a.AccountKey
    LEFT OUTER JOIN
    dimGoal g on sc.SubcategoryKey = g.GoalKey
	INNER JOIN
	dimPaymentMethod pm on fli.PaymentMethodKey = pm.PaymentMethodKey
	INNER JOIN
	Months m ON fli.MonthId = m.MonthId
	INNER JOIN
	DaysOfWeek dow ON fli.DayOfWeekId = dow.DayOfWeekId
WHERE
	fli.UniqueKey = ?;