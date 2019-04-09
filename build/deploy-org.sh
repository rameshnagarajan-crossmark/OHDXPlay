#Convert to MDAPI format for deployment to prod
echo "Converting to MDAPI format..."
sfdx force:source:convert -d deploy_org -r force-app 
#Deploy to prod & run all tests
echo "Deploying to production & running all tests..."
sfdx force:mdapi:deploy -u DevHub -d deploy_org/ -w -1 -l RunAllTestsInOrg