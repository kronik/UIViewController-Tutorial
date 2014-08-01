//
//  DKAppDelegate.m
//  Tutorial Category
//
//  Created by Dmitry Klimkin on 4/5/14.
//  Copyright (c) 2014 Dmitry Klimkin. All rights reserved.
//

#import "DKAppDelegate.h"
#import "UIViewController+Tutorial.h"

@implementation DKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    UIViewController *viewController = [UIViewController new];
    
    viewController.view.backgroundColor = [UIColor colorWithRed:0.29 green:0.59 blue:0.81 alpha:1];
    
    self.window.backgroundColor = viewController.view.backgroundColor;
    self.window.rootViewController = viewController;
    
    [viewController startNavigationTutorial];
    
    int64_t delayInSeconds = 5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        [viewController startCreateNewItemTutorialWithInfo:NSLocalizedString(@"Pull down to create new item", nil)];
    });

    delayInSeconds = 10;
    popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        [viewController startTapTutorialWithInfo:NSLocalizedString(@"Tap here to open settings", nil)
                                         atPoint:CGPointMake(160, 350)
                            withFingerprintPoint:CGPointMake(160, 200)
                            shouldHideBackground:NO
                                      completion:^{
                                          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tutorial finished" message:@"This is the completion block!" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                                          [alert show];
                                      }];
    });

    [self.window makeKeyAndVisible];
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
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
