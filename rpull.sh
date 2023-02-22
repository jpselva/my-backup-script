#!/bin/bash

# fill in the names below
REMOTE_DIR=remote_name:remote_dir_path
LOCAL_DIR=local_dir_path
ME=name_of_this_device

# set password environment variable (remove if not needed)
echo -n "rclone pw: "
read -s PW
echo ""
export RCLONE_CONFIG_PASS=$PW

pull()
{
    # pull changes from the remote
    rclone sync $REMOTE_DIR $LOCAL_DIR -P \
        --exclude="/{rpush,rpull}.sh" --exclude="/.lock"
}

if [ -n $1 ] && [ "$1" = "--force" ] 
then
    echo "will force the lock and pull"
    echo $ME | rclone rcat $REMOTE_DIR/.lock
    pull
else
    # running only for the exit status
    rclone cat ${REMOTE_DIR}/.lock 2>/dev/null

    if [ $? -eq 0 ]
    then
        echo "Someone owns the lock already. Abort."
    else
        echo $ME | rclone rcat $REMOTE_DIR/.lock
        echo "You acquire the lock."
        pull
    fi
fi
