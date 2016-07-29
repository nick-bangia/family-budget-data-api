SET @accesstoken = ?;
SET @refreshToken = ?;

SELECT
  CASE 
    WHEN ValidTokenStore.AccessToken IS NULL AND 
         ValidTokenStore.RefreshToken IS NULL AND 
         ExpiredTokenStore.AccessToken IS NULL AND
         ExpiredTokenStore.RefreshToken IS NULL THEN 'NOT AUTHORIZED'
    WHEN ValidTokenStore.AccessToken IS NULL AND
         ValidTokenStore.RefreshToken IS NULL AND
         ExpiredTokenStore.AccessToken IS NOT NULL AND
         ExpiredTokenStore.RefreshToken IS NOT NULL THEN 'EXPIRED'
    WHEN ValidTokenStore.AccessToken IS NOT NULL AND 
         ValidTokenStore.RefreshToken IS NOT NULL AND
         ExpiredTokenStore.AccessToken IS NULL AND
         ExpiredTokenStore.RefreshToken IS NULL THEN 'AUTHORIZED'
    ELSE 'NOT AUTHORIZED'
  END AS 'RenewableState'
FROM
  (SELECT
    @accessToken AS 'ProvidedAccessToken',
    @refreshToken AS 'ProvidedRefreshToken') RequestingRenew
  
  LEFT OUTER JOIN
  (SELECT
     at.AccessToken,
     at.RefreshToken,
     at.RefreshExpires
   FROM
     AccessToken at) ValidTokenStore
   ON RequestingRenew.ProvidedAccessToken = ValidTokenStore.AccessToken COLLATE utf8_general_ci
   AND RequestingRenew.ProvidedRefreshToken = ValidTokenStore.RefreshToken COLLATE utf8_general_ci
   AND ValidTokenStore.RefreshExpires > NOW()
   
   LEFT OUTER JOIN
   (SELECT
     at.AccessToken,
     at.RefreshToken,
     at.RefreshExpires
    FROM
      AccessToken at) ExpiredTokenStore
   ON RequestingRenew.ProvidedAccessToken = ExpiredTokenStore.AccessToken COLLATE utf8_general_ci
   AND RequestingRenew.ProvidedRefreshToken = ExpiredTokenStore.RefreshToken COLLATE utf8_general_ci
   AND ExpiredTokenStore.RefreshExpires <= NOW();
