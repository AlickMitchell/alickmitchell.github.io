---
title: 'Finding Files - Part One'
tags: ['Linux']
keywords: ['Linux']
date: 2024-06-21
draft: false
description: "This post explain the use of the linux find command"
---

When using Linux you'll come to use a certain group of tools daily. In your tool bag you'll no doubt have a worn grep, a shiny sed, a beat up awk, and a collection of other well used tools. One of my personal favourites is find.

Find allows us to pinpoint a specific file by name, or by a certain characteristic. We can link these search options together to work with very granular patterns to match against.


### Looking for a Specific Named File ###
One of the simplest uses of find is searching for files by name.

```
user:/etc$ find /etc -name "fstab" 2>/dev/null
/etc/fstab
```

Here, we use the -name flag to specify the exact match we are looking for. This flag also allows us to use the wildcard character to glob for files.
```
0:59:45 eurus:/etc$ find /etc -name "sy*.conf" 2>/dev/null
/etc/systemd/system.conf
/etc/ufw/sysctl.conf
/etc/sysctl.conf
```

### Limit the Digging ###
Often when searching, we might only need to search the current directory. To keep the search focused to produce an accurate set of results, we can use the depth flag. The number that follows indicates the number of directories we would like to descend.
```
user:/etc$ find /etc -maxdepth 1 -name "ma*" 2>/dev/null
/etc/magic
/etc/manpath.config
/etc/mailcap
```

### Where's that directory ###
Find also has the ability to search by type. Though normally we are looking for files, we can search for directories(d), symbolic links(l), pipes(p).
```
user:/etc$ find / -type d -name "apache2" 2>/dev/null  
/etc/apache2
```
As you'll notice, we're start to link more options together to get a more granular result.

### Using the Clock ###
We also have the ability to search on time characteristics of a file. Such as time of creation, last access, or last modification. 

- Finding files modified in the last 30 minutes in our home directory
```
user:~$ find ~/ -mmin 30
/home/user/snap/firefox/common/.cache/mozilla/firefox/reyjrfbf.default/cache2/entries/70C49D60B117049BE67EF60F92A91340278CCE3E
/home/user/snap/firefox/common/.cache/mozilla/firefox/reyjrfbf.default/cache2/entries/23915A14AF3BFC2C7FF5670FE299752C88648247
/home/user/snap/firefox/common/.cache/mozilla/firefox/reyjrfbf.default/cache2/entries/8C1855AF224FCB1DFE9412BBC3797E5C6AE91188
```

- Find files that have been access in the last 30 minutes
```
16:21:38 user:~$ find ~/ -amin 30
/home/user/posts/interface_configuration/index.html
/home/user/posts/firefox/index.html
```

### Permissions ###
Find allows us to search by file permissions. We can use both methods, either the numerical method(755) or using the symbolic method(u+x)

| Symbol | Meaning                                                           |
|:-------|:------------------------------------------------------------------|
| \-     | At least this permission level is set, and any higher permissions |
| \/     | Any permissions that are listed are set                           |

- Checking if any files have the execution bit set for all users
```
16:58:18 meses:/usr/sbin$ find /usr/sbin -type f -perm -o=x 2>/dev/null
/usr/sbin/avahi-daemon
/usr/sbin/reset-trace-bpfcc
/usr/sbin/pwck
/usr/sbin/wpa_supplicant
/usr/sbin/ucalls
/usr/sbin/cracklib-format
```
We can also search for the special permissions, setuid(4), getuid(2), and sticky bit(1), by setting the fourth bit.

- This makes auditing files for setuid an easy operation
```
user:~$ find /usr/bin -type f -perm -4000 2>/dev/null
/usr/bin/umount
/usr/bin/sudo
/usr/bin/su
/usr/bin/pkexec
/usr/bin/chfn
/usr/bin/gpasswd
/usr/bin/passwd
/usr/bin/chsh
/usr/bin/mount
/usr/bin/newgrp
```

### Working on the find ###
We are also given the ability to apply a command to the found item. This is done with the "-exec" flag. This is extremely handy, so we don't have to do any bashfu to have the found files collected and then piped into the command.
```
user:/tmp/test$ ls
client.cnf  client.conf  client.config  conf  script.pl  server.conf  vimrc
user:/tmp/test$ find . -name "*.conf" -exec mv {} ./conf \;
user:/tmp/test$ ls ./conf
client.conf  server.conf
```
Above we search for the ".conf" files in the directory, and then move them to the "conf" directory in the current working directory.

### Wrap up ###
As you can see from the few examples that I have show above, find is very flexible and can be a useful tool that is fantastic to keep in your toolbag. In the next post I'll discuss how to use regular expressions can be used in conjunction with find to create patterns even more granular.


