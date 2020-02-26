#!/bin/bash
source ~/openrc.sh
INSTANCE=$(/home/yohan/env_py3/bin/openstack server show -c id --format value $(hostname))
sudo mkdir -p /mnt/volumes/onlyoffice_data
if ! mountpoint -q /mnt/volumes/onlyoffice_data
then
     VOLUME_ID=$(/home/yohan/env_py3/bin/openstack volume show onlyoffice_data -c id --format value)
     test -e /dev/disk/by-id/*${VOLUME_ID:0:20} || nova volume-attach $INSTANCE $VOLUME_ID auto
     sleep 3
     sudo mount /dev/disk/by-id/*${VOLUME_ID:0:20} /mnt/volumes/onlyoffice_data
fi
sudo mkdir -p /mnt/volumes/onlyoffice_log
if ! mountpoint -q /mnt/volumes/onlyoffice_log
then
     VOLUME_ID=$(/home/yohan/env_py3/bin/openstack volume show onlyoffice_log -c id --format value)
     test -e /dev/disk/by-id/*${VOLUME_ID:0:20} || nova volume-attach $INSTANCE $VOLUME_ID auto
     sleep 3
     sudo mount /dev/disk/by-id/*${VOLUME_ID:0:20} /mnt/volumes/onlyoffice_log
fi

sudo docker-compose up -d
