//
//  AXCourseViewController.h
//  Venue
//
//  Created by Jim Boulter on 1/9/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AXDetailViewController.h"
#import "AXCourseTableViewCell.h"
#import "AXCourse.h"
#import "AXAPI.h"


@interface AXCourseViewController : AXDetailViewController

-(instancetype)initWithCourse:(AXCourse*)course;

@end

