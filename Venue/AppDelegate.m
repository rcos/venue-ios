//
//  AppDelegate.m
//  Venue
//
//  Created by Jim Boulter on 1/1/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import "AppDelegate.h"
#import "AXAPI.h"
#import "AXLoginViewController.h"
#import "AXWebLoginViewController.h"
#import "AXOverviewViewController.h"
#import "UIFont+Venue.h"
#import "AXNavigationBar.h"
#import "AXAppCoordinator.h"

@interface AppDelegate ()
@end

@implementation AppDelegate

- (void)setLoggedIn {
    self.isLoggingIn = false;
    
    [AXLocationExec exec];
//    UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:[[AXOverviewViewController alloc] init]];
    [[AXAppCoordinator sharedInstance] setNewWindow:self.window];

}

-(void)setLoggedOut {
    self.isLoggingIn = true;
    [[AXAPI API] logOut];
    AXWebLoginViewController* viewController = [[AXWebLoginViewController alloc] init];
    [UIView transitionWithView:self.window
                      duration:.25
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [self.window setRootViewController:viewController];
                    } completion:nil];
}

-(void)configureAppearances {
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setBackgroundColor:[UIColor primaryColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor primaryColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor secondaryColor]];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    [UINavigationBar appearance].titleTextAttributes = @{NSFontAttributeName:[UIFont boldFontOfSize:22]};
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor backgroundColor];
    
    [self configureAppearances];
    
    [Fabric with:@[[Crashlytics class]]];
    
    if ([[FXKeychain defaultKeychain] objectForKey:kSessionToken]) {
        [self setLoggedIn];
    }
    else [self setLoggedOut];
    
    [self.window makeKeyAndVisible];
	
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
