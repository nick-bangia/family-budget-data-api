SET @currentToken = ?;
SET @newAccessToken = ?;
SET @authorizedInterval = ?;
SET @refreshToken = ?;
SET @refreshInterval = ?;
SET @accessExpires = DATE_ADD(NOW(), INTERVAL @authorizedInterval MINUTE);
SET @refreshExpires = DATE_ADD(@accessExpires, INTERVAL @refreshInterval MINUTE);
SET @authorizedUser = null;

-- Get the authorized user for the current access token
SELECT AuthorizedUser INTO @authorizedUser
FROM AccessToken at
WHERE at.AccessToken = @currentToken COLLATE utf8_general_ci;

-- Delete any open sessions for this user
DELETE FROM AccessToken
WHERE
	AuthorizedUser = @authorizedUser COLLATE utf8_unicode_ci;

-- create a new session
INSERT INTO AccessToken
	(AuthorizedUser, AccessToken, AccessExpires, RefreshToken, RefreshExpires)
VALUES
	(@authorizedUser, @newAccessToken, @accessExpires, @refreshToken, @refreshExpires);

-- select back that token to return to the user
SELECT
	AccessToken,
	AccessExpires,
    RefreshToken,
    RefreshExpires
FROM
	AccessToken
WHERE
	AuthorizedUser = @authorizedUser COLLATE utf8_unicode_ci;
	