//
//  AXNavigationBar.h
//  Venue
//
//  Created by Jim Boulter on 11/27/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AXNavigationController.h"

typedef NS_ENUM(NSInteger, AXContentMode){
    AXContentModeEvents,
    AXContentModeCourses,
};

@protocol AXNavigationBarDelegate <NSObject>
-(void)contentModeDidChange:(AXContentMode)mode;
@end

@class AXEvent, AXCourse;
@interface AXNavigationBar : UIView <AXNavigationControllerDelegate>
@property (strong, nonatomic) id<AXNavigationBarDelegate> delegate;
@property (strong, nonatomic, readonly) UIButton *backButton;
- (void)setEvent:(AXEvent *)event;
- (void)setCourse:(AXCourse *)course;
@end
