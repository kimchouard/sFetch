//
//  AFIAppDelegate.m
//  sFetch
//
//  Created by Tanguy Hélesbeux on 11/11/2013.
//  Copyright (c) 2013 AnyFetch - INSA. All rights reserved.
//

#import "AFIAppDelegate.h"
#import "AFIUser.h"
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
#import <CoreTelephony/CTSubscriberInfo.h>

@interface AFIAppDelegate()

@property (strong, nonatomic) CTCallCenter *callCenter;

@end


@implementation AFIAppDelegate

- (CTCallCenter *)callCenter
{
    if (!_callCenter) _callCenter = [[CTCallCenter alloc] init];
    return _callCenter;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    //UIViewController* loginViewController = [mainstoryboard instantiateViewControllerWithIdentifier:@"AFILoginVC"];
    //UIViewController *rootViewController = [AFIAppDelegate topMostController];
    //[rootViewController presentViewController:loginViewController animated:YES completion:NULL];

    
    // Override point for customization after application launch.
    
    self.callCenter.callEventHandler=^(CTCall* call)
    {
        if (call.callState == CTCallStateDialing) {
            
            NSLog(@"Call in progress");
            
        } else if (call.callState == CTCallStateDisconnected) {
            
            NSLog(@"Call has been disconnected");
            
        } else if (call.callState == CTCallStateConnected) {
            
            NSLog(@"Call has just been connected");
            
        } else if(call.callState == CTCallStateConnected) {
            
            NSLog(@"Call is incoming");
            
        } else {
            
            NSLog(@"None of the conditions");
            
        }
    };
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    NSSet *calls = self.callCenter.currentCalls;
    for (CTCall *call in calls) {
        NSLog(@"Call = %@", call);
//        NSString *caller = CTCallCopyAddress(NULL, call);
//        NSLog(@"caller:%@",caller);
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    if ([AFIUser isCalling]) {
        UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        UIViewController* viewController = [mainstoryboard instantiateViewControllerWithIdentifier:@"CallBack"];
        UIViewController *topViewcontroller = [AFIAppDelegate topMostController];
        [topViewcontroller presentViewController:viewController animated:YES completion:NULL];
    }
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

+ (UIViewController*)topMostController
{
    UIViewController *topController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    return topController;
}

@end
