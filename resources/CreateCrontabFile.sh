#!/bin/bash
# ###################################################################### #
# file: 	CreateCrontabFile.sh		                         #
# purpose:	Creates the crontab.txt file that is used to setup the   #
#		cronjob to call the API at a regular interval to refresh #
#		the budget allowances.		 			 #
# parameters:	$1: MySQL username				  	 #
#		$2: MySQL password					 #
# 		$3: Refresh Interval (in hours)				 #
# ###################################################################### #

# Step 1: Generate a random password for the cronjob user of the API
apiPassword=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

# Step 2: Connect to the MySQL Server and insert a new row into AuthorizedUser for the cronjob
mysql -D FamilyBudget -u $1 -p$2 -e "UPDATE AuthorizedUser SET Password='$apiPassword' WHERE Username='cronjob';"

# Step 3: Create the Basic Authentication string to use in the API call
authString_b64=`node base64encode.js cronjob:$apiPassword`
authorization='Basic '$authString_b64

# Step 4: Create crontab.txt
echo '0 */'$3' * * * sudo /usr/bin/curl --header "Authorization: '$authorization'" http://127.0.0.1:8001/refreshAllowances' >> crontab.txt

exit 0; 
