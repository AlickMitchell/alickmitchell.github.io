---
title: 'Finding Files - Part Two'
tags: ['Linux']
keywords: ['Linux']
date: 2024-06-2
draft: true
description: "This post explain the use of the linux find command"
---

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

We have a few useful regular expressions to help use create patterns:
| Symbol | Property                                              |
| :----- | :---------------------------------------------------- |
| \*     | Represents 0 or more characters when used with -regex |
| \+     | Represents 1 or more characters                       |
| \?     | Represents 1 or 0 characters                          |


### Working on the found files ###
Once we have found the files that we were looking for we can run into problems using pipes to try and and work with them. This problem is resolved with the -exec flag that will allow us to take action on each found item.

