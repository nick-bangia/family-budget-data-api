SET @token = ?;

SELECT
  CASE 
    WHEN ValidTokenStore.Token IS NULL AND ExpiredTokenStore.Token IS NULL THEN 'NOT AUTHORIZED'
    WHEN ValidTokenStore.Token IS NULL AND ExpiredTokenStore.Token IS NOT NULL THEN 'EXPIRED'
    WHEN ValidTokenStore.Token IS NOT NULL AND ExpiredTokenStore.Token is NULL THEN 'AUTHORIZED'
    ELSE 'NOT AUTHORIZED'
  END AS 'AuthorizationState'
FROM
  (SELECT
    @token AS 'Token') RequestingAccess
  
  LEFT OUTER JOIN
  (SELECT
     at.Token,
     at.Expires
   FROM
     AccessToken at) ValidTokenStore
   ON RequestingAccess.Token = ValidTokenStore.Token COLLATE utf8_general_ci
   AND ValidTokenStore.Expires > NOW()
   
   LEFT OUTER JOIN
   (SELECT
     at.Token,
     at.Expires
    FROM
      AccessToken at) ExpiredTokenStore
   ON RequestingAccess.Token = ExpiredTokenStore.Token COLLATE utf8_general_ci
   AND ExpiredTokenStore.Expires <= NOW();
