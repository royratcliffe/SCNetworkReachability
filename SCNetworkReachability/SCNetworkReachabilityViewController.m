// SCNetworkReachability SCNetworkReachabilityViewController.m
//
// Copyright © 2011, Roy Ratcliffe, Pioneering Software, United Kingdom
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the “Software”), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED “AS IS,” WITHOUT WARRANTY OF ANY KIND, EITHER
// EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO
// EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES
// OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
// ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
// DEALINGS IN THE SOFTWARE.
//
//------------------------------------------------------------------------------

#import "SCNetworkReachabilityViewController.h"

@implementation SCNetworkReachabilityViewController

// reachability by name
@synthesize nameImageView;
@synthesize nameStatusField;
@synthesize nameFlagsLabel;

// Internet reachability
@synthesize internetImageView;
@synthesize internetStatusField;
@synthesize internetFlagsLabel;

// link-local reachability
@synthesize linkLocalImageView;
@synthesize linkLocalStatusField;
@synthesize linkLocalFlagsLabel;

@synthesize summaryLabel;

/*
 * Translates a given network reachability object to the corresponding set of
 * views and controls wired up to this view controller. This method is an
 * attempt to centralise in one place the mapping of reachability instances to
 * their matching views and controls, i.e. an image view for the icon, a text
 * field for the status, and a label for the flags.
 */
- (void)userInterfaceViewsAndControlsFromNetReach:(SCNetworkReachability *)netReach
										imageView:(UIImageView **)outImageView
									  statusField:(UITextField **)outStatusField
									   flagsLabel:(UILabel **)outFlagsLabel
{
	if (netReach == nameReach)
	{
		if (outImageView)
		{
			*outImageView = nameImageView;
		}
		if (outStatusField)
		{
			*outStatusField = nameStatusField;
		}
		if (outFlagsLabel)
		{
			*outFlagsLabel = nameFlagsLabel;
		}
	}
	else if (netReach == internetReach)
	{
		if (outImageView)
		{
			*outImageView = internetImageView;
		}
		if (outStatusField)
		{
			*outStatusField = internetStatusField;
		}
		if (outFlagsLabel)
		{
			*outFlagsLabel = internetFlagsLabel;
		}
	}
	else if (netReach == linkLocalReach)
	{
		if (outImageView)
		{
			*outImageView = linkLocalImageView;
		}
		if (outStatusField)
		{
			*outStatusField = linkLocalStatusField;
		}
		if (outFlagsLabel)
		{
			*outFlagsLabel = linkLocalFlagsLabel;
		}
	}
	else
	{
		if (outImageView)
		{
			*outImageView = nil;
		}
		if (outStatusField)
		{
			*outStatusField = nil;
		}
		if (outFlagsLabel)
		{
			*outFlagsLabel = nil;
		}
	}
}

- (void)didChangeForNetReach:(SCNetworkReachability *)netReach flags:(SCNetworkReachabilityFlags)flags
{
	// Start by selecting the three user-interface elements to update.
	UIImageView *imageView;
	UITextField *statusField;
	UILabel *flagsLabel;
	[self userInterfaceViewsAndControlsFromNetReach:netReach imageView:&imageView statusField:&statusField flagsLabel:&flagsLabel];
	
	// Take the reachability flags from the notification. Use them to present
	// the current flags as a string and to interpret the “reach” based on the
	// kind of network reachability being assessed. Take care not to ask for
	// flags. The notification already contains sufficient information to assess
	// the current status.
	NSString *stringFromFlags = [(NSString *)SCNetworkReachabilityCFStringCreateFromFlags(flags) autorelease];
	SCNetworkReachable reach = [netReach networkReachableForFlags:flags];
	NSString *statusString;
	switch (reach)
	{
		case kSCNetworkNotReachable:
			imageView.image = [UIImage imageNamed:@"stop-32.png"];
			statusString = @"Not Reachable";
			break;
		case kSCNetworkReachableViaWiFi:
			imageView.image = [UIImage imageNamed:@"Airport.png"];
			statusString = @"Reachable Via Wi-Fi";
			break;
		case kSCNetworkReachableViaWWAN:
			imageView.image = [UIImage imageNamed:@"WWAN5.png"];
			statusString = @"Reachable Via WWAN";
			break;
		default:
			statusString = nil;
	}
	if (statusString && (flags & kSCNetworkReachabilityFlagsConnectionRequired))
	{
		statusString = [NSString stringWithFormat:@"%@, Connection Required", statusString];
	}
	statusField.text = statusString;
	flagsLabel.text = stringFromFlags;
	
	// Name reachability updates the summary label. Naughty but nice. Update the
	// summary whenever “name” reachability changes. Hide the summary if the
	// WWAN is unreachable, i.e. no cellular data. Otherwise report as available
	// or active according to whether reachability requires connection.
	if (netReach == nameReach)
	{
		NSString *summaryString;
		if ((flags & kSCNetworkReachabilityFlagsConnectionRequired))
		{
			summaryString = @"Cellular data network is available. Internet traffic will be routed through it after a connection is established.";
		}
		else
		{
			summaryString = @"Cellular data network is active. Internet traffic will be routed through it.";
		}
		summaryLabel.hidden = (reach != kSCNetworkReachableViaWWAN);
		summaryLabel.text = summaryString;
	}
}

- (void)netReachDidChange:(NSNotification *)notification
{
	// Important not to send -[SCNetworkReachability getFlags:] at this
	// point. No need. Just extract the reachability object and the
	// notification's reachability flags. Together they provide sufficient
	// information for handling the notification, after determining current
	// reachability status.
	SCNetworkReachability *netReach = [notification object];
	SCNetworkReachabilityFlags flags = [[[notification userInfo] objectForKey:kSCNetworkReachabilityFlagsKey] unsignedIntValue];
	[self didChangeForNetReach:netReach flags:flags];
}

- (void)viewDidLoad
{
	nameReach = [[SCNetworkReachability networkReachabilityForName:@"www.apple.com"] retain];
	internetReach = [[SCNetworkReachability networkReachabilityForInternet] retain];
	linkLocalReach = [[SCNetworkReachability networkReachabilityForLinkLocal] retain];
	
	// Now prepare to receive network reachability notifications.
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netReachDidChange:) name:kSCNetworkReachabilityDidChangeNotification object:nil];
	
	// You do not automatically receive an initial notification. Use the
	// synchronous API at first. These messages can block and, if they block for
	// too long a time, can trigger the watchdog to kill the application. Better
	// to respond after this initial assessment by taking reachability flags
	// from notifications.
	SCNetworkReachabilityFlags flags;
	if ([nameReach getFlags:&flags])
	{
		[self didChangeForNetReach:nameReach flags:flags];
	}
	if ([internetReach getFlags:&flags])
	{
		[self didChangeForNetReach:internetReach flags:flags];
	}
	if ([linkLocalReach getFlags:&flags])
	{
		[self didChangeForNetReach:linkLocalReach flags:flags];
	}
	
	[nameReach startNotifier];
	[internetReach startNotifier];
	[linkLocalReach startNotifier];
	
	[super viewDidLoad];
}

- (void)viewDidUnload
{
	[nameReach stopNotifier];
	[internetReach stopNotifier];
	[linkLocalReach stopNotifier];
	
	[nameReach release];
	[internetReach release];
	[linkLocalReach release];
	
	[super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
