#!/bin/bash

set -e

. "${TMP_COOKBOOKS_DIR}/source/font.sh"

source_dir=$(dirname $(readlink -f "$0"))
cp -R "${source_dir}/files/service" /

####################################
echo-info "Installing NGINX"
####################################

apt-get update
apt-get install -y nginx