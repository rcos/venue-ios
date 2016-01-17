//
//  AXLocationExec.h
//  Venue
//
//  Created by Jim Boulter on 1/16/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface AXLocationExec : NSObject <CLLocationManagerDelegate>

@property CLLocation* location;
@property (nonatomic, copy) void (^executeOnNextUpdate)(CLLocation*);

+(AXLocationExec*) exec;

-(void)getLocationWithCompletion:(void(^)(CLLocation* location))completion;

@end
