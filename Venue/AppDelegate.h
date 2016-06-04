//
//  AppDelegate.h
//  Venue
//
//  Created by Jim Boulter on 1/1/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "AXOverviewViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

-(void)setLoggedIn;
-(void)setLoggedOut;

@end

