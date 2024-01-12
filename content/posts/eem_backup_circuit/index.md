+++
title = 'EEM and a Downed Primary Ciruit'
date  = 2024-01-11
draft = false
+++

The Embedded Event Manager is a brilliant tool that can be found in the Cisco IOS. Before the rollout of IOS-EX Cisco was limited to TCL and EEM to implement scripting locally on the device. Though we now get python available to us, TCL and EEM are very useful.

I'm just going to roll through a use of EEM when we lose our Primary Connection and need to flip to our backup. This can be scripted with EEM, we'll also put recovery in there. So when the primary ciruit comes back we switch from the backup to the primary.

So we'll be using EEM and also 'IP SLA' to perform this.

- First we need to create our ip sla instance. This will instruct the device to check the connectivity of the Primary Circuit.
```
ip sla 1
 icmp-echo 192.168.24.4 source-interface GigabitEthernet0/3
 frequency 5
ip sla schedule 1 life forever start-time now
```

- To attach the sla instance with EEM we create a track object
```
track 1 ip sla 1 reachability
```

- Now we create the 'BACKUP' EEM script that will watch the track object, and will bring up our secondary link and print a syslog message if it drops.
```
event manager applet BACKUP
 event track 1 state down
 action 100 cli command "enable"
 action 200 cli command "conf t"
 action 300 cli command "int gi0/2"
 action 400 cli command "no shut"
 action 500 syslog priority critical msg "THE WHOLE INTERNET IS DOWN. BRINGING UP BACKUP INTERFACE"
```

- We also need to have a recovery script 'RECOVER', running for when the Primary circuit comes back up. This is our recovery script.
```
event manager applet RECOVER
 event track 1 state up
 action 100 cli command "enable"
 action 110 set DONE "0"
 action 120 while $DONE ne 1
 action 130  wait 5
 action 140  cli command "ping 10.2.2.2 so gi0/3"
 action 150  regexp "!!!" "$_cli_result"
 action 160  if $_regexp_result eq "1"
 action 170   cli command "enable"
 action 181   cli command "conf t"
 action 192   cli command "int gi0/2"
 action 200   cli command "shut"
 action 210   cli command "end"
 action 220   set DONE "1"
 action 230  end
 action 240 end
 action 250 syslog priority notifications msg "Primary Interface Restored"
```

- Both of these scripts will continue to run in the background and are implemented when the variables change. For a Linux guy it's kind of like a cron job, constantly running in the background watching for the state change of set variables.

- This shows the power of EEM. With just a few lines of code we are able to add reliability to our network. 
