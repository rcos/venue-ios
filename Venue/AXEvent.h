//
//  AXEvent.h
//  Venue
//
//  Created by Jim Boulter on 5/5/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface AXEvent : NSObject

@property NSString* eventId;
@property NSString* name;
@property NSString* eventDescription;
@property NSDate* startDate;
@property NSDate* endDate;
@property NSString* startTime;
@property NSString* endTime;
@property NSString* imageUrl;
@property CLLocationCoordinate2D coords;
@property NSString* address;

-(instancetype)initWithDictionary:(NSDictionary*)dict;

@end
