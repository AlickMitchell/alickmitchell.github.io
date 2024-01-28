---
title: 'Single Area OSPF on Linux'
tags: ['Linux','Routing']
keywords: ['Linux', 'Routing', 'OSPF', 'Networking', 'FRR']
date: 2024-01-25
draft: true
description: "This post walks through the setting up of a single OSPF area on Linux"
---

Though Linux is usually thought of as a server OS. It has huge amount of implementations from embedded systems, the world of IOT, the mobile phone sector, and we're all still waiting for the year of the Linux Desktop(sure it'll be this year). But a function that is often over looked is the available routing protocol suite that eanbles linux to function as a router.

The routing protocol suite started off as a project called Zebra, which after becoming discontinued morphed into [Quagga Routing Software](https://github.com/Quagga). We'll be using [FRRouting](https://frrouting.org/), which is a project that has been built on top of qugga.

FRR provides use with the ability to work with many dynamic routing protcols:
  - OSPFv2/OSPFv3
  - BGP
  - RIP/RIPng
  - ISIS
  
Is this example I'm going to create a single OSPFv2 area 


### Topology ###
