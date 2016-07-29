SET @token = ?;

SELECT
  CASE 
    WHEN ValidTokenStore.AccessToken IS NULL AND ExpiredTokenStore.AccessToken IS NULL THEN 'NOT AUTHORIZED'
    WHEN ValidTokenStore.AccessToken IS NULL AND ExpiredTokenStore.AccessToken IS NOT NULL THEN 'EXPIRED'
    WHEN ValidTokenStore.AccessToken IS NOT NULL AND ExpiredTokenStore.AccessToken is NULL THEN 'AUTHORIZED'
    ELSE 'NOT AUTHORIZED'
  END AS 'AuthorizationState'
FROM
  (SELECT
    @token AS 'Token') RequestingAccess
  
  LEFT OUTER JOIN
  (SELECT
     at.AccessToken,
     at.AccessExpires
   FROM
     AccessToken at) ValidTokenStore
   ON RequestingAccess.Token = ValidTokenStore.AccessToken COLLATE utf8_general_ci
   AND ValidTokenStore.AccessExpires > NOW()
   
   LEFT OUTER JOIN
   (SELECT
     at.AccessToken,
     at.AccessExpires
    FROM
      AccessToken at) ExpiredTokenStore
   ON RequestingAccess.Token = ExpiredTokenStore.AccessToken COLLATE utf8_general_ci
   AND ExpiredTokenStore.AccessExpires <= NOW();
