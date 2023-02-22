#!/bin/bash

# fill in the names below
REMOTE_DIR=remote_name:remote_dir_path
REMOTE_BACKUP_DIR=possibly_other_remote_name:backup_dir_path/`date +%A_%d-%m-%y_%H:%M:%S`
LOCAL_DIR=local_dir_path
ME=name_of_this_device

# set password environment variable (remove if not needed)
echo -n "rclone pw: "
read -s PW
echo ""
export RCLONE_CONFIG_PASS=$PW

push()
{
    # push changes to the remote
    rclone sync $LOCAL_DIR $REMOTE_DIR -P \
        --backup-dir $REMOTE_BACKUP_DIR \
        --exclude="/{rpush,rpull}.sh" --exclude="/.lock"
}

if [ -n "$1" ] && [ "$1" = "--force" ]
then
    echo "Will force the lock and push"
    # >/dev/null below because .lock may not be in the remote
    rclone delete $REMOTE_DIR/.lock 2>/dev/null
    push
else
    LOCK_OWNER=`rclone cat ${REMOTE_DIR}/.lock`

    if [ $? -ne 0 ] || [ $LOCK_OWNER != $ME ]
    then
        echo "You don't own the lock. Abort."
    else
        if [ -n "$1" ] && [ "$1" = "--keep" ]
        then
            echo "Will sync without releasing the lock."
        else
            echo "You release the lock."
            rclone delete $REMOTE_DIR/.lock
        fi

        push
    fi
fi
