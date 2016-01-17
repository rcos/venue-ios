//
//  AXLocationExec.m
//  Venue
//
//  Created by Jim Boulter on 1/16/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import "AXLocationExec.h"

@interface AXLocationExec ()

@property CLLocationManager* locationManager;

@end

@implementation AXLocationExec
@synthesize locationManager, executeOnNextUpdate;

+(AXLocationExec*) exec
{
    static AXLocationExec* exec = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        exec = [[AXLocationExec alloc] init];
    });
    
    return exec;
}

#pragma mark - Init

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        locationManager = [[CLLocationManager alloc] init];
        [locationManager setDelegate:self];
        [self checkAuthorization];
    }
    return self;
}

#pragma mark - Location

-(void)getLocationWithCompletion:(void(^)(CLLocation* location))completion
{
    if(!self.location)executeOnNextUpdate = completion;
    else
    {
        completion(self.location);
    }
}

// Checks if we're allowed to use location services
-(CLAuthorizationStatus)checkAuthorization
{
    if([CLLocationManager locationServicesEnabled])
    {
        CLAuthorizationStatus authStat = [CLLocationManager authorizationStatus];
        
        //If we don't know about authorization, we need to ask the user
        if(authStat == kCLAuthorizationStatusNotDetermined)
        {
            //request ability to use location services
            // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
            if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                [self.locationManager requestWhenInUseAuthorization];
            }
        }
        
        return authStat;
    }
    return kCLAuthorizationStatusNotDetermined;
}

// This is called at starting of location services, no matter if there is actually a change in auth
// This means this will be our starting point which says "We're ready to use location services" after init
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if([CLLocationManager locationServicesEnabled] && status == kCLAuthorizationStatusAuthorizedWhenInUse)
    {
        //Good to start using location services
        [locationManager startUpdatingLocation];
    }
}

// If we got actual locations from the manager, they appear here
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
//    for(CLLocation* newLocation in locations)
//    {
//        
//    }
    self.location = [locations lastObject];
    if(executeOnNextUpdate)executeOnNextUpdate(self.location);
    [locationManager startMonitoringSignificantLocationChanges];
}

//Handle our errors here
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //NSLog(@"%@", error);
}

@end