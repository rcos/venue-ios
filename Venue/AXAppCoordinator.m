//
//  AXAppCoordinator.m
//  Venue
//
//  Created by Rocco Del Priore on 12/2/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import "AXAppCoordinator.h"
#import "AXLayoutController.h"

#import "AXOverviewViewController.h"
#import "AXCourseViewController.h"
#import "AXEventViewController.h"

@implementation AXAppCoordinator {
    AXLayoutController *layoutController;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        layoutController = [[AXLayoutController alloc] init];
    }
    return self;
}

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static AXAppCoordinator *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)setNewWindow:(UIWindow *)window {
    AXOverviewViewController *viewController = [[AXOverviewViewController alloc] init];
    [layoutController setRootViewController:viewController];
	
    [UIView transitionWithView:window
                      duration:.25
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [window setRootViewController:layoutController];
                    } completion:nil];
}

- (void)navigateToCourse:(AXCourse *)course {
    AXCourseViewController *viewController = [[AXCourseViewController alloc] initWithCourse:course];
    [layoutController.navigationBar setCourse:course];
    [layoutController pushViewController:viewController];
}

- (void)navigateToEvent:(AXEvent *)event {
    AXEventViewController *viewController = [[AXEventViewController alloc] initWithEvent:event];
    [layoutController.navigationBar setEvent:event];
    [layoutController pushViewController:viewController];
}

- (void)navigateToSettings {
    NSLog(@"Navigate to Settings");
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Log out?"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Log out" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        AppDelegate* del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [del setLoggedOut];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil]];
    [layoutController presentViewController:alert animated:YES completion:nil];
}

@end
