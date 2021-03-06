#!/bin/bash
#
# Copyright (C) 2014 eNovance SAS <licensing@enovance.com>
#
# Author: Emilien Macchi <emilien.macchi@enovance.com>
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.

# Script that synchronise downstream to upstream eDeploy server.

set -e
set -x

edeploymaster="$1"
release="$2"

# Download and Extract .edeploy files from upstream to downstream eDeploy server
for role in openstack-full install-server; do
    wget http://$edeploymaster/edeploy-roles/$release/$role-$release.edeploy -P /tmp
    rm -rf /var/lib/debootstrap/install/$release/$role
    mkdir -p /var/lib/debootstrap/install/$release/$role
    tar zx -C /var/lib/debootstrap/install/$release/$role < /tmp/$role-$release.edeploy
done

# Synchronize eDeploy metadata with upstream
# metadata contain informations about upgrade itself
rsync -av --numeric-ids --delete-after $edeploymaster::metadata/ /var/lib/debootstrap/metadata/

exit 0
