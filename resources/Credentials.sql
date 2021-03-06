-- CREATE USER STATEMENTS - CREATES THE NEW USER
-- REPLACE $user WITH DESIRED USERNAME
-- REPLACE $password WITH DESIRED PASSWORD
CREATE USER '$user'@'localhost' IDENTIFIED BY '$password';
CREATE USER '$user'@'127.0.0.1' IDENTIFIED BY '$password';

-- GRANT STATEMENTS - GIVES PRIVILEGES TO THE NEW USER
-- REPLACE $user WITH DESIRED USERNAME FROM ABOVE CREATE USER
GRANT SELECT, INSERT, UPDATE, DELETE, SHOW VIEW ON FamilyBudget.* TO '$user'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE, SHOW VIEW ON FamilyBudget.* TO '$user'@'127.0.0.1';
GRANT DROP ON FamilyBudget.BudgetAllowances TO '$user'@'localhost';
GRANT DROP ON FamilyBudget.BudgetAllowances TO '$user'@'127.0.0.1';
