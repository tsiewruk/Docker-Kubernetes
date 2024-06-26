#!/bin/bash

set -e

# prepare plugins dir
mkdir -p /usr/share/grafana/data/plugins

# start Grafana
nohup s6-svscan -t0 /service >> /var/log/s6-nohup.log 2>&1 & s6pid=$!
sleep 64

# set admin password
curl -X PUT -H "Content-Type: application/json" -d '{
    "oldPassword": "'"${grafana_admin_old_password}"'",
    "newPassword": "'"${grafana_admin_password}"'",
    "confirmNew": "'"${grafana_admin_password}"'"
}' http://${grafana_admin_login}:${grafana_admin_old_password}@localhost:3000/api/user/password

# set admin e-mail
curl -X PUT -H "Content-Type: application/json" -d '{
    "name":"'"${grafana_admin_name}"'",
    "email": "'"${grafana_admin_email}"'",
    "login":"'"${grafana_admin_login}"'"
}' http://${grafana_admin_login}:${grafana_admin_password}@localhost:3000/api/users/1

# set organization name
curl -X PUT -H "Content-Type: application/json" -d '{
    "name": "'"${grafana_organization_name}"'"
}' http://${grafana_admin_login}:${grafana_admin_password}@localhost:3000/api/org

# set organization timezone
curl -X PUT -H "Content-Type: application/json" -d '{
    "timezone": "'"${grafana_organization_timezone}"'",
    "weekStart":"'"${grafana_organization_weekstart}"'",
    "theme": "'"${grafana_organization_theme}"'"
}' http://${grafana_admin_login}:${grafana_admin_password}@localhost:3000/api/org/preferences

# remove processes and logs
s6-svc -d /service/grafana
kill ${s6pid}
rm /var/log/s6-nohup.log
sleep 8

# kill remaining process
ps auxf | awk '{print $2, $11}' | grep "/usr/share/grafana/bin/grafana" | awk '{print $1}' | xargs kill -9

# prepare config file
config_path=/usr/share/grafana/conf/
sed -i "s|<INSTANCE_NAME>|${instance_name}|" ${config_path}/defaults.ini-custom
sed -i "s|<SMTP_EMAIL>|${smtp_email}|" ${config_path}/defaults.ini-custom
sed -i "s|<SMTP_PASSWORD>|${smtp_password}|" ${config_path}/defaults.ini-custom
sed -i "s|<SMTP_HOST>|${smtp_host}|" ${config_path}/defaults.ini-custom
mv /usr/share/grafana/conf/defaults.ini-custom ${config_path}/defaults.ini

sed -i "s|b_configure_grafana_script=1|b_configure_grafana_script=0|" /usr/local/bin/entrypoint-scripts.env