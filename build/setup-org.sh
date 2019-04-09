# Get the private key from the environment variable
echo "Setting up Production Connection..."
#mkdir keys
echo $SFDC_ORG_CLIENTID
echo $SFDC_ORG_USER

# Authenticate to salesforce
echo "Authenticating..."
sfdx force:auth:jwt:grant --clientid $SFDC_ORG_CLIENTID --jwtkeyfile keys/server.key --username $SFDC_ORG_USER --setdefaultdevhubusername -a DevHub