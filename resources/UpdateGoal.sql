SET @goalKey = ?;
SET @categoryKey = ?;
SET @accountKey = ?;
SET @goalName = ?;
SET @goalPrefix = ?;
SET @goalAmount = ?;
SET @estimatedCompletionDate = ?;
SET @isActive = ?;
SET @isAllocatable = ?;

UPDATE dimSubcategory
SET
	CategoryKey = @categoryKey,
    AccountKey = @accountKey,
    SubcategoryName = @goalName,
    SubcategoryPrefix = @goalPrefix,
    IsActive = @isActive,
    IsAllocatable = @isAllocatable,
    LastUpdatedDate = NOW()
WHERE
	SubcategoryKey = @goalKey COLLATE utf8_unicode_ci;
    
UPDATE dimGoal
SET
	GoalAmount = @goalAmount,
    EstimatedCompletionDate = @estimatedCompletionDate,
    LastUpdatedDate = NOW()
WHERE
	GoalKey = @goalKey COLLATE utf8_unicode_ci;
