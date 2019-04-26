@echo off

rem apollo config db info
set apollo_config_db_url="jdbc:mysql://nuke-adapter-uat-db-cluster.cluster-czahiwwi6rzh.us-west-2.rds.amazonaws.com/apolloconfigdb?useUnicode=true&characterEncoding=UTF-8&useSSL=false"
set apollo_config_db_username="root"
set apollo_config_db_password="derbysoft"

rem apollo portal db info
set apollo_portal_db_url="jdbc:mysql://10.200.1.185:3306/ApolloPortalDB?characterEncoding=utf8"
set apollo_portal_db_username="root"
set apollo_portal_db_password="derbysoft"

rem meta server url, different environments should have different meta server addresses
set dev_meta="http://localhost:8080"
set fat_meta="http://someIp:8080"
set uat_meta="http://10.110.233.102/apollo"
set pro_meta="http://yetAnotherIp:8080"

set META_SERVERS_OPTS=-Ddev_meta=%dev_meta% -Dfat_meta=%fat_meta% -Duat_meta=%uat_meta% -Dpro_meta=%pro_meta%

rem =============== Please do not modify the following content ===============
rem go to script directory
cd "%~dp0"

cd ..

rem package config-service
echo "==== starting to build config-service ===="

call mvn clean package -DskipTests -pl apollo-configservice -am -Dapollo_profile=github -Dspring_datasource_url=%apollo_config_db_url% -Dspring_datasource_username=%apollo_config_db_username% -Dspring_datasource_password=%apollo_config_db_password%

echo "==== building config-service  finished ===="

rem package  admin-service
echo "==== starting to build admin-service ===="

call mvn clean package -DskipTests -pl apollo-adminservice -am -Dapollo_profile=github -Dspring_datasource_url=%apollo_config_db_url% -Dspring_datasource_username=%apollo_config_db_username% -Dspring_datasource_password=%apollo_config_db_password%

echo "==== building admin-service finished ===="

rem echo "==== starting to build portal ===="

call mvn clean package -DskipTests -pl apollo-portal -am -Dapollo_profile=github,auth -Dspring_datasource_url=%apollo_portal_db_url% -Dspring_datasource_username=%apollo_portal_db_username% -Dspring_datasource_password=%apollo_portal_db_password% %META_SERVERS_OPTS%

rem echo "==== building portal finished ===="

pause
