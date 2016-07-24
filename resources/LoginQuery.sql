SET @authorizedUser = ?;
SET @newToken = ?;
SET @authorizedInterval = ?;

-- Delete any open sessions for this user
DELETE FROM AccessToken
WHERE
	AuthorizedUser = @authorizedUser COLLATE utf8_unicode_ci;

-- create a new session
INSERT INTO AccessToken
	(AuthorizedUser, Token, Expires)
VALUES
	(@authorizedUser, @newToken, DATE_ADD(NOW(), INTERVAL @authorizedInterval MINUTE));

-- select back that token to return to the user
SELECT
	Token,
	Expires
FROM
	AccessToken
WHERE
	AuthorizedUser = @authorizedUser COLLATE utf8_unicode_ci;
	