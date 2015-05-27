SET @token = ?;

SELECT
  CASE 
    WHEN TokenStore.Token IS NULL THEN 0
    ELSE 1
  END AS 'IsAuthorized'
FROM
  (SELECT
    @token AS 'Token') RequestingAccess
  LEFT OUTER JOIN
  (SELECT
     at.Token,
     at.Expires,
     at.IsActive
   FROM
     AccessToken at) TokenStore
   ON RequestingAccess.Token = TokenStore.Token COLLATE utf8_general_ci
   AND TokenStore.Expires > NOW()
   AND TokenStore.IsActive = 1;
