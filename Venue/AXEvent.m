//
//  AXEvent.m
//  Venue
//
//  Created by Jim Boulter on 5/5/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import "AXEvent.h"

@implementation AXEvent

-(instancetype)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if(self)
    {
        _eventId = dict[@"_id"];
        _name = dict[@"title"];
        _eventDescription = dict[@"description"];
        
        NSArray* times = dict[@"times"];
        if(times.count > 0)
        {
            NSDictionary* time = [times firstObject];
            NSString* start = time[@"start"];
            NSString* end = time[@"end"];
            
            NSDateFormatter* df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSz"];
            
            _startDate = [df dateFromString:start];
            _endDate = [df dateFromString:end];
            
            [df setDateFormat:@"MM/dd h:mma"];
            _startTime = [df stringFromDate:_startDate];
            [df setDateFormat:@"h:mma"];
            _endTime = [df stringFromDate:_endDate];
        }
        
        _imageUrl = [dict[@"imageURLs"] firstObject];
        
        CLLocationDegrees lat = [dict[@"location"][@"geo"][@"coordinates"][1] doubleValue];
        CLLocationDegrees lon = [dict[@"location"][@"geo"][@"coordinates"][0] doubleValue];
        _coords = CLLocationCoordinate2DMake(lat, lon);
    }
    return self;
}

@end
