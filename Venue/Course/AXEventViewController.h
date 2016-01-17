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

@interface AXEventViewController : AXDetailViewController <DBCameraViewControllerDelegate>

-(void)checkIn;

@end
