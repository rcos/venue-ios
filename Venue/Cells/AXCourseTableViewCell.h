//
//  AXCourseTableViewCell.h
//  Venue
//
//  Created by Jim Boulter on 1/6/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import "AXTableViewCell.h"
#import "AXContentSelectionToolbar.h"
#import "Masonry.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AXEvent.h"
#import "AXCourse.h"


@interface AXCourseTableViewCell : AXTableViewCell

-(void)configureWithCourse:(NSDictionary*)course;
-(void)configureWithEvent:(NSDictionary*)event;

@end
