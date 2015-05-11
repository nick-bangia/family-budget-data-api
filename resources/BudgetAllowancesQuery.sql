TRUNCATE TABLE BudgetAllowances;

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