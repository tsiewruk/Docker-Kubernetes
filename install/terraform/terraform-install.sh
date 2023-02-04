#!/usr/bin/env bash

set -e

source_dir="$(dirname $(readlink -f "$0"))"
source "${source_dir}/../../../source/font.sh"

TERRAFORM_VERSION="${1}"

echo-info "Installing Terraform"

wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
apt-get update -y
apt-get install -y --no-install-recommends terraform=${TERRAFORM_VERSION}