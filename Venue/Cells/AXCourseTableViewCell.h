//
//  AXCourseTableViewCell.h
//  Venue
//
//  Created by Jim Boulter on 1/6/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>

#import "AXTableViewCell.h"
#import "AXCourse.h"
#import "AXEvent.h"


@interface AXCourseTableViewCell : AXTableViewCell

- (void)configureWithCourse:(NSDictionary*)course;
- (void)configureWithEvent:(NSDictionary*)event;

@end
