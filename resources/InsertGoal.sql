SET @goalKey = ?;
SET @categoryKey = ?;
SET @accountKey = ?;
SET @goalName = ?;
SET @goalPrefix = ?;
SET @goalAmount = ?;
SET @estimatedCompletionDate = ?;
SET @isActive = ?;
SET @isAllocatable = ?;

INSERT INTO dimSubcategory
	(SubcategoryKey, CategoryKey, AccountKey, SubcategoryName, SubcategoryPrefix, IsActive, IsAllocatable, LastUpdatedDate)
VALUES
	(@goalKey, @categoryKey, @accountKey, @goalName, @goalPrefix, @isActive, @isAllocatable, NOW());
    
INSERT INTO dimGoal
	(GoalKey, GoalAmount, EstimatedCompletionDate, LastUpdatedDate)
VALUES
	(@goalKey, @goalAmount, @estimatedCompletionDate, NOW());
