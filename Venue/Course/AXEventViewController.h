//
//  AXEventViewController.h
//  Venue
//
//  Created by Jim Boulter on 1/14/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import "AXDetailViewController.h"
#import <DBCamera/DBCameraViewController.h>
#import <DBCamera/DBCameraContainerViewController.h>
#import <DBCamera/DBCameraView.h>
#import <MapKit/MapKit.h>

@interface AXEventViewController : AXDetailViewController <DBCameraViewControllerDelegate>

-(instancetype)initWithEvent:(NSDictionary*)event;

-(void)checkIn;

@end
