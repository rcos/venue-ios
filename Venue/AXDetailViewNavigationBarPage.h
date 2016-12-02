//
//  AXDetailViewNavigationBarPage.h
//  Venue
//
//  Created by Rocco Del Priore on 12/2/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AXEvent, AXCourse;
@interface AXDetailViewNavigationBarPage : UIView
- (void)setEvent:(AXEvent *)event;
- (void)setCourse:(AXCourse *)course;
@end
