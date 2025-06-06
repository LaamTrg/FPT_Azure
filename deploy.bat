@echo off

dotnet publish -c RELEASE -o publish
tar -a -c -f publish.zip publish

set RESOURCE_GROUP=learn-6e87e910-df0d-468e-bbd0-4355454a819c
set LOCATION=westus
set APP_SERVICE_PLAN=ASP-learn6e87e910df0d468ebbd0435545-8db8
set SERVICE_PLAN_PRICING_TIER=F1
set WEBAPP_NAME=TruongPhuLam
set RUNTIME=DOTNETCORE:8.0
set SQL_SERVER_NAME=truongphulam
set SQL_ADMIN_USER=lamadmin
set SQL_ADMIN_PASSWORD=LamStrongPassword@123
set SQL_DB=LamDatabase
set DEPLOY_SC_PATH=publish.zip

az group create --name %RESOURCE_GROUP% --location %LOCATION%
az appservice plan create --name %APP_SERVICE_PLAN% --resource-group %RESOURCE_GROUP% --sku F1 --is-linux

az webapp create ^
    --resource-group %RESOURCE_GROUP% ^
    --plan %APP_SERVICE_PLAN% ^
    --name %WEBAPP_NAME% ^
    --runtime %RUNTIME%

az sql server create ^
    --name %SQL_SERVER_NAME% ^
    --resource-group %RESOURCE_GROUP% ^
    --location %LOCATION% ^
    --admin-user %SQL_ADMIN_USER% ^
    --admin-password %SQL_ADMIN_PASSWORD%

az sql db create ^
    --resource-group %RESOURCE_GROUP% ^
    --server %SQL_SERVER_NAME% ^
    --name %SQL_DB% ^
    --service-objective S0

echo "Configuring firewall..."

az sql server firewall-rule create ^
    --name all-ip-firewall ^
    --resource-group %RESOURCE_GROUP% ^
    --server %SQL_SERVER_NAME% ^
    --start-ip-address   0.0.0.0 ^
    --end-ip-address   255.255.255.255

az webapp config connection-string set ^
    --name %WEBAPP_NAME% ^
    --resource-group %RESOURCE_GROUP% ^
    --settings "DefaultConnection=Server=tcp:%SQL_SERVER_NAME%.database.windows.net,1433;Initial Catalog=%SQL_DB%;Persist Security Info=False;User ID=%SQL_ADMIN_USER%;Password=%SQL_ADMIN_PASSWORD%;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;" ^
    --connection-string-type SQLAzure

az webapp deployment source config-zip ^
    --resource-group %RESOURCE_GROUP% ^
    --name %WEBAPP_NAME% ^
    --src %DEPLOY_SC_PATH%

echo "Deployment completed successfully."