# my backup script
**Disclaimer:** I wrote this before  `rclone bisync`  existed.

I use this to keep a folder in my desktop and my notebook synced. `rclone` must be installed.

Both scripts must be inside the folder that'll be shared and must be present in all machines that'll share it.

On my notebook, inside the shared folder:
```
me@notebook$ ./rpull.sh
You acquire the lock.
## rest of output ##
me@notebook$ echo "Hello world!" >hi.txt # new file that wasn't in the remote
```
I forget to push to the remote and move to my desktop. Also inside the shared folder:
```
me@desktop$ ./rpull.sh
Someone owns the lock already. Abort.
## rest of output ##
```
Oops. Now back to my notebook:
```
me@notebook$ ./rpush.sh
You release the lock.
## rest of output ##
```
Now hi.txt is in the remote. Back to the desktop:
```
me@desktop$ ./rpull.sh
You acquire the lock.
## rest of output ##
```
You can always ignore the lock with the `--force` option.
When you push, deleted/modified stuff is stored in a remote backup directory of your choice. Eventually this must be manually emptied up.
