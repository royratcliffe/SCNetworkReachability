//
//  SCNetworkReachabilityAppDelegate.h
//  SCNetworkReachability
//
//  Created by Roy Ratcliffe on 22/08/2011.
//  Copyright 2011 Pioneering Software, United Kingdom. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCNetworkReachabilityViewController;

@interface SCNetworkReachabilityAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet SCNetworkReachabilityViewController *viewController;

@end
