//
//  AXLayoutController.h
//  Venue
//
//  Created by Rocco Del Priore on 12/2/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AXNavigationBar.h"

@interface AXLayoutController : UIViewController

@property (nonatomic, readonly) AXNavigationBar *navigationBar;

- (void)setRootViewController:(UIViewController *)rootViewController;

- (void)pushViewController:(UIViewController *)viewController;

- (void)popViewController;

@end
