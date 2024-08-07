---
title: 'Finding Files - Part Two'
tags: ['Linux']
keywords: ['Linux']
date: 2024-07-01
draft: false
description: "This post explain the use of the linux find command"
---

In part one I gave an overview of the more fundamental features of find. Here, I'll go over how we can incorporate regular expressions.

Regular expressions are one of those skills that you'll end up using throughout of your career, from using in a bash script, BGP route manipulation or filtering, or a simple grep. 

One of the features that makes find awesome is its ability to incorporate regular expressions, to create granular search patterns.

### Which Regular Expressions ###
Though all implementations of regular expressions have commonalities, some are more feature rich than others. Find allows us to use different types of regex.

```
eurus:/etc$ find -regextype help
find: Unknown regular expression type ‘help’; valid types are ‘findutils-default’, ‘ed’, ‘emacs’, ‘gnu-awk’, ‘grep’, ‘posix-awk’, ‘awk’, ‘posix-basic’, ‘posix-egrep’, ‘egrep’, ‘posix-extended’, ‘posix-minimal-basic’, ‘sed’.
```
Running the above command lets use know what type of regular expressions are supported. So we can change from 'findutils-default' to a more familiar type. 

This needs to be kept in mind, as you might find that your pattern though correct in one type of implementation, but doesn't work in the one set.
```
user:/etc$ find /etc -maxdepth 1 -type f -regex "\/etc\/f.*[conf]{4}"
user:/etc$ find /etc -maxdepth 1 -type f -regextype awk -regex "\/etc\/f.*[conf]{4}"
user:/etc$ find /etc -maxdepth 1 -type f -regextype posix-extended -regex "\/etc\/f.*[conf]{4}"
/etc/fuse.conf
/etc/fprintd.conf
user:/etc$ find /etc -maxdepth 1 -type f -regextype egrep -regex "\/etc\/f.*[conf]{4}"
/etc/fuse.conf
/etc/fprintd.conf

```
Above we can see that "findutils-default" and "awk" fail to match on the pattern, but if we switch to "posix-extended" or "egrep" the pattern returns the expected files.


### Building a Pattern ##

One thing that needs to be taken into account when using the -regex flag, the pattern is matched on the absolute path, not just the file name. 
```
user:/etc$ find /etc -maxdepth 1 -type d -regex "\/etc\/sys.*" 2>/dev/null
/etc/systemd
/etc/sysctl.d
/etc/sysstat
user:/etc$ find /etc -maxdepth 1 -type d -regex ".*\/sys.*" 2>/dev/null
/etc/sysctl.d
/etc/sysstat
/etc/systemd
```
If this part "\/etc\/" of the pattern or the wild card ".*" isn't present above, no results will be returned. 

We have a few useful regular expressions to help use quantify sections of our patterns:

| Symbol | Property                                              |
| :----- | :---------------------------------------------------- |
| \*     | Represents 0 or more characters when used with -regex |
| \+     | Represents 1 or more characters                       |
| \?     | Represents 1 or 0 characters                          |
| \{n\}  | This sets the pattern to a certain number
| \{n,\} | This sets the pattern to a minimum number
| \{,n\} | This sets the pattern to a maximum number
| \{n,p\}| This sets the pattern to a range


We have an object called a Character Class, and  this allows us to set a range of characters. We use the square brackets to contain the range [].
```
user:/tmp/test$ ls
client.cnf  client.conf  client.config script.pl  vimrc
user:/tmp/test$ find ./ -maxdepth 1 -type f -regextype egrep -regex ".*/.*\.[config]{4,}"
./client.config
./client.conf
user:/tmp/test$ find ./ -maxdepth 1 -type f -regextype egrep -regex ".*/.*\.[config]{4}"
./client.conf
user:/tmp/test$ find ./ -maxdepth 1 -type f -regextype egrep -regex ".*/.*\.[config]{,4}"
./client.cnf
./client.conf
```
Above, we have used a Character Class and a quantifier to change our search pattern.

#### Metacharacters ####

The fullstop "." represents any character. Below we'll link it with a quantifier and ends with a "c".
```
user:/tmp/test$ ls
client.cnf  client.conf  client.config  script.pl  vimrc
user:/tmp/test$ find ./ -maxdepth 1 -type f -regextype egrep -regex "\./(.){4}c"
./vimrc
```

We can also use logic within our pattern. By using grouping with brackets and using the pipe as the or logical operator. Below, we are looking for files that end in .pl or .conf
```
user:/tmp/test$ ls
client.cnf  client.conf  client.config  script.pl  vimrc
user:/tmp/test$ find ./ -maxdepth 1 -type f -regextype egrep -regex ".*/.*\.(pl|conf)"
./script.pl
./client.conf
```
We can also negate characters by using the Character Class with the carrot. Below, we'll search from all files that start with any character other than "c".
```
user:/tmp/test$ ls
client.cnf  client.conf  client.config script.pl  vimrc
users:/tmp/test$ find ./ -maxdepth 1 -type f -regextype egrep -regex "\./[^c].*"
./script.pl
./vimrc
```

### Wrap Up ###
As you can see, by using regular expressions with find, it allows us to search our filesystem at an extremely granular level. If you haven't already learnt regular expressions, I'd highly recommend that you do. You'll come across them in many areas from DevOps, Networking, Programming, too many areas to list.



