-- CREATE USER STATEMENTS - CREATES THE NEW USER
-- REPLACE $user WITH DESIRED USERNAME
-- REPLACE $password WITH DESIRED PASSWORD
-- REPLACE $host WITH THE HOSTNAME OF THE COMPUTER
CREATE USER '$user'@'localhost' IDENTIFIED BY '$password';
CREATE USER '$user'@'127.0.0.1' IDENTIFIED BY '$password';
CREATE USER '$user'@'$host' IDENTIFIED BY '$password';

-- GRANT STATEMENTS - GIVES PRIVILEGES TO THE NEW USER
-- REPLACE $user WITH DESIRED USERNAME FROM ABOVE CREATE USER
-- REPLACE $host WITH THE HOSTNAME OF THE COMPUTER FROM ABOVE CREATE USER
GRANT SELECT, INSERT, UPDATE, DELETE, SHOW VIEW ON familybudget.* TO '$user'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE, SHOW VIEW ON familybudget.* TO '$user'@'127.0.0.1';
GRANT SELECT, INSERT, UPDATE, DELETE, SHOW VIEW ON familybudget.* TO '$user'@'$host';
