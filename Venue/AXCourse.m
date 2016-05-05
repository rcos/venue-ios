//
//  AXCourse.m
//  Venue
//
//  Created by Jim Boulter on 5/5/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import "AXCourse.h"

@implementation AXCourse

-(instancetype)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if(self)
    {
        _courseId = dict[@"_id"];
        _department = dict[@"department"];
        _courseNumber = dict[@"courseNumber"];
        _name = dict[@"name"];
        _courseDescription = dict[@"description"];
        _imageUrl = [dict[@"imageURLs"] firstObject];
    }
    return self;
}

@end
