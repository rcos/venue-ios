//
//  AXAppCoordinator.h
//  Venue
//
//  Created by Rocco Del Priore on 12/2/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AXEvent, AXCourse;
@interface AXAppCoordinator : NSObject

+ (instancetype)sharedInstance;

- (void)setNewWindow:(UIWindow *)window;

- (void)navigateToCourse:(AXCourse *)course;

- (void)navigateToEvent:(AXEvent *)event;

- (void)navigateToSettings;

@end
