//
//  AXCourseTableViewCell.h
//  Venue
//
//  Created by Jim Boulter on 1/6/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import "AXTableViewCell.h"
#import "Masonry.h"

@interface AXCourseTableViewCell : AXTableViewCell

-(void)configureWithDictionary:(NSDictionary*)dict;

@end
