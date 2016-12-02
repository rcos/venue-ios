//
//  AXCoursesViewController.h
//  Venue
//
//  Created by Jim Boulter on 1/4/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//
//  Displays courses and events

#import <UIKit/UIKit.h>
#import <KVOController/NSObject+FBKVOController.h>

#import "AppDelegate.h"
#import "AXNavigationBar.h"

@interface AXOverviewViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, AXNavigationBarDelegate, UISearchResultsUpdating>

@end
