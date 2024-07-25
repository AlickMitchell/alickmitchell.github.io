---
title: 'Finding Files'
tags: ['Linux']
keywords: ['Linux']
date: 2024-06-21
draft: true
description: "This post explain the use of the linux find command"
---

When using Linux you'll come to use a certain group of tools daily. Grep, sed, awk are often mentioned, but one I use regularly is find. Find allows us to pin point a specific file by name, or by a certain charateristic. When we link this with regular expressions and the ability to perform actions on the found files, find becomes a powerful tool.


### Looking for a Specific Named File ###
One of the simplest uses of find is searching for files by name.

```
user:/etc$ find /etc -name "fstab" 2>/dev/null
/etc/fstab
```

Here we use the -name flag to specify the exact match we are looking for. This flag also allows us to use the wildcard character to glob for files.
```
0:59:45 eurus:/etc$ find /etc -name "sy*.conf" 2>/dev/null
/etc/systemd/system.conf
/etc/ufw/sysctl.conf
/etc/sysctl.conf
```

### Limit the Digging ###
Often when searching, we might only need to search the current directory. To keep the results more accurate we can set a depth flag. 
```
user:/etc$ find /etc -maxdepth 1 -name "ma*" 2>/dev/null
/etc/magic
/etc/manpath.config
/etc/mailcap
```
This can be altered to how deep we want to drill into the filesystem, by sepcifying the number after the -maxdepth option.

### Where's that directory ###
Find also has the ability to search by type. Though normally we are looking for files, we can search for directories, symbolic links, pipes, etc
```
user:/etc$ find / -type d -name "apache2" 2>/dev/null  
/etc/apache2
```
As you'll notice we start linking options together to get the result we are after.

### Regular Expressions ###
One of the features that makes find awesome is it's ability to use regular expressions.
```
eurus:/etc$ find -regextype help
find: Unknown regular expression type ‘help’; valid types are ‘findutils-default’, ‘ed’, ‘emacs’, ‘gnu-awk’, ‘grep’, ‘posix-awk’, ‘awk’, ‘posix-basic’, ‘posix-egrep’, ‘egrep’, ‘posix-extended’, ‘posix-minimal-basic’, ‘sed’.
```
Running the above command lets use know what type of regular expressions are supported. So we can change from 'findutils-default' to a more familiar type. 

One thing that needs to be taken into account when using the -regex the pattern is matched on the absolute path not just the file name. 
```
user:/etc$ find /etc -maxdepth 1 -type d -regex "\/etc\/sys.*" 2>/dev/null
/etc/systemd
/etc/sysctl.d
/etc/sysstat
```
If this part "\/etc\/" of the pattern isn't present no results will be returned. 

We have a few useful regular expressions that 
  - * - Where are we use this for globing with the -name option, here we use it to represent 0 or above number of characters
  - + - This represents 1 or greater number of pattern
