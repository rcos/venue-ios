//
//  AXCourse.h
//  Venue
//
//  Created by Jim Boulter on 5/5/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AXCourse : NSObject

@property NSNumber* courseId;
@property NSString* name;
@property NSString* courseDescription;
@property NSString* department;
@property NSString* courseNumber;
@property NSDate* startDate;
@property NSDate* endDate;
@property NSString* imageUrl;

-(instancetype)initWithDictionary:(NSDictionary*)dict;

@end

