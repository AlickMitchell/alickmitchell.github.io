+++
title = 'Link Redundancy with Administrative Distance'
tags = ['Cisco','Routing']
keywords = ['Cisco', 'Routing', 'Administrative Distance', 'AD']
date  = 2024-01-16
draft = false
+++

In the previous post I worked through how to use EEM when we had the constraint of having to keep the Backup circuit interface shutdown when not in use. Without this constraint we can implement redundancy with just Administrative Distance.

### Administratvie Distance ###
This is a metric that is used by vendors to rate the reliability of a route. Vendors do use different metrics. I'll be using cisco devices in this example. The lower the AD(Administrative Value) value the more reliable a route is deemed.

|Protocol        |Administrative Distance|
|:---------------|----------------------:|
|Connected       | 0|
|Static          | 1 |
|eBGP            | 20|
|OSPF            | 110|
|RIP             | 120|

Above we can see some values for routing protcols, static and connected routes.

Administrative distance comes into play when we have two identical routes, but they are provided by different methods. 

If OSPF has a route for 10.10.1.0/24 and we have a static route for 10.10.1.0/24, the static route will be placed into the routing table as it has the lower AD. Though the OSPF isn't entered into the routing it still kept in the OSPF Database. If the static route was to be removed it would then be inserted into the Routing table.

This functionality can be used by use to implement redundancy. If we have a Primary circuit and a Backup circuit we can set the Backup with a higher AD and if the Primary ever fails, the Backup will be inserted into the routing table.

