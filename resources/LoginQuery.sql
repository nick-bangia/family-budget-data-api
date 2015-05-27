SET @authorizedUser = ?;
SET @newToken = ?;
SET @authorizedInterval = ?;

-- Deactivate any open sessions for this user
UPDATE AccessToken
	SET IsActive = 0
WHERE
	AuthorizedUser = @authorizedUser COLLATE utf8_unicode_ci
	AND IsActive = 1;

-- create a new session
INSERT INTO AccessToken
	(AuthorizedUser, Token, Expires, IsActive)
VALUES
	(@authorizedUser, @newToken, DATE_ADD(NOW(), INTERVAL @authorizedInterval MINUTE), 1);

-- select back that token to return to the user
SELECT
	Token,
	Expires
FROM
	AccessToken
WHERE
	AuthorizedUser = @authorizedUser COLLATE utf8_unicode_ci
	AND IsActive = 1;
	