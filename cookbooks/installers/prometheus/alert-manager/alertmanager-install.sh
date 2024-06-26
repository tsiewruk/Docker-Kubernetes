#!/bin/bash

set -e

. "${TMP_COOKBOOKS_DIR}/source/font.sh"

source_dir=$(dirname $(readlink -f "$0"))
cp -R "${source_dir}/files/service" /

ALERTMANAGER_VERSION="${1}"

####################################
echo-info "Installing Alert-manager version - ${ALERTMANAGER_VERSION}"
####################################

wget https://github.com/prometheus/alertmanager/releases/download/v${ALERTMANAGER_VERSION}/alertmanager-${ALERTMANAGER_VERSION}.linux-amd64.tar.gz -P /tmp/alertmanager
tar -xvzf /tmp/alertmanager/alertmanager-${ALERTMANAGER_VERSION}.linux-amd64.tar.gz -C /tmp/alertmanager
mkdir -p /etc/alert-manager /etc/alert-manager/data
mv /tmp/alertmanager/alertmanager-${ALERTMANAGER_VERSION}.linux-amd64/{alertmanager,amtool} /usr/local/bin/

rm -rf /tmp/alertmanager

sed -i "s|<ALERT_MANAGER_URL>|${ALERT_MANAGER_URL}|" /service/alert-manager/run 