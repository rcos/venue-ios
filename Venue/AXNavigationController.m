//
//  AXNavigationController.m
//  Venue
//
//  Created by Rocco Del Priore on 12/1/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import "AXNavigationController.h"
#import "AXNavigationBar.h"

@interface AXNavigationController ()

@end

@implementation AXNavigationController

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [super pushViewController:viewController animated:animated];
    [self.customDelegate didPushViewController:self];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    UIViewController *viewController = [super popViewControllerAnimated:animated];
    [self.customDelegate didPopViewController:self];
    return viewController;
}

@end
