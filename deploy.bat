@echo off

@REM dotnet publish -c RELEASE -o publish
@REM tar -a -c -f publish.zip publish

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

@REM az group create --name %RESOURCE_GROUP% --location %LOCATION%
@REM az appservice plan create --name %APP_SERVICE_PLAN% --resource-group %RESOURCE_GROUP% --sku F1 --is-linux

@REM az webapp create ^
@REM     --resource-group %RESOURCE_GROUP% ^
@REM     --plan %APP_SERVICE_PLAN% ^
@REM     --name %WEBAPP_NAME% ^
@REM     --runtime %RUNTIME%

@REM az sql server create ^
@REM     --name %SQL_SERVER_NAME% ^
@REM     --resource-group %RESOURCE_GROUP% ^
@REM     --location %LOCATION% ^
@REM     --admin-user %SQL_ADMIN_USER% ^
@REM     --admin-password %SQL_ADMIN_PASSWORD%

az sql db create ^
    --resource-group %RESOURCE_GROUP% ^
    --server %SQL_SERVER_NAME% ^
    --name %SQL_DB% ^
    --service-objective S0

@REM echo "Configuring firewall..."

@REM az sql server firewall-rule create ^
@REM     --name all-ip-firewall ^
@REM     --resource-group %RESOURCE_GROUP% ^
@REM     --server %SQL_SERVER_NAME% ^
@REM     --start-ip-address   0.0.0.0 ^
@REM     --end-ip-address   255.255.255.255

@REM az webapp config connection-string set ^
@REM     --name %WEBAPP_NAME% ^
@REM     --resource-group %RESOURCE_GROUP% ^
@REM     --settings "DefaultConnection=Server=tcp:%SQL_SERVER_NAME%.database.windows.net,1433;Initial Catalog=%SQL_DB%;Persist Security Info=False;User ID=%SQL_ADMIN_USER%;Password=%SQL_ADMIN_PASSWORD%;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;" ^
@REM     --connection-string-type SQLAzure

@REM az webapp deployment source config-zip ^
@REM     --resource-group %RESOURCE_GROUP% ^
@REM     --name %WEBAPP_NAME% ^
@REM     --src %DEPLOY_SC_PATH%

@REM echo "Deployment completed successfully."