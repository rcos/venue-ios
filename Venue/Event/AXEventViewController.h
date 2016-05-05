//
//  AXEventViewController.h
//  Venue
//
//  Created by Jim Boulter on 1/14/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import "AXDetailViewController.h"
#import <MapKit/MapKit.h>
#import "AXEvent.h"

@interface AXEventViewController : AXDetailViewController

-(instancetype)initWithEvent:(AXEvent*)event;

-(void)checkIn;

@end
