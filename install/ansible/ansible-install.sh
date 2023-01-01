#!/usr/bin/env bash

set -e

ANSIBLE_VERISON="${1}"

echo-info "Installing Ansible"
apt-get -y update
apt-get -y install --no-install-recommends python3 python3-pip python3-dev
pip install ansible=="${ANSIBLE_VERISON}"