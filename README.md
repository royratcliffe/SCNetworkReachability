# Network Reachability App

This repository contains an iOS sample application demonstrating how to use [SCNetworkReachabilityKit][SCNetworkReachabilityKit].

[SCNetworkReachabilityKit]:https://github.com/royratcliffe/SCNetworkReachabilityKit

Using asynchronous notifications only, the application presents the status of three reachable networks:

1. by name, specifically [Apple](http://www.apple.com),
2. the Internet and
3. the local-link wi-fi network.

## How to Build the Sample

Clone the repository in the usual way. It incorporates the SCNetworkReachabilityKit as a Git sub-module however. Hence you also need to initialise and update the submodule. From your local repository type:

	git submodule update --init

Git will clone the appropriate repository as a submodule. You can now open the project using Xcode, build and run. Don't forget to set up the correct scheme: SCNetworkReachability » iPhone Simulator or iOS Device. iPad works too.

## Screenshots

The following screenshots show you what the sample app looks like under different connectivity test conditions.

### No Network Reachable

Mobile Data off, 3G off and Wi-Fi off. Everything disabled! Nothing reachable.

![No Network Reachable](https://github.com/royratcliffe/SCNetworkReachability/raw/master/Screenshots/No%20Network%20Reachable.png)

### EDGE Reachable

Mobile Data *on*, 3G off and Wi-Fi off. The iPhone picks up the local EDGE service, a slightly more advanced form of GPRS.

![EDGE Reachable](https://github.com/royratcliffe/SCNetworkReachability/raw/master/Screenshots/EDGE%20Reachable.png)

### 3G Reachable

Mobile Data *on* and 3G *on*, but Wi-Fi off. The iPhone picks up the local 3G service—fast cellular Internet.

![3G Reachable](https://github.com/royratcliffe/SCNetworkReachability/raw/master/Screenshots/3G%20Reachable.png)

### Wi-Fi Reachable

Mobile Data *on* and 3G *on*, and Wi-Fi *on*. The iPhone opts for the very fast broadband service available via wi-fi.

![Wi-Fi Reachable](https://github.com/royratcliffe/SCNetworkReachability/raw/master/Screenshots/Wi-Fi%20Reachable.png)
