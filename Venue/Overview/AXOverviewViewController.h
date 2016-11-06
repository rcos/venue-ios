//
//  AXCoursesViewController.h
//  Venue
//
//  Created by Jim Boulter on 1/4/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//
//  Displays courses and events

#import <UIKit/UIKit.h>
#import "Masonry.h"
#import "AXContentSelectionToolbar.h"
#import "AppDelegate.h"
#import <KVOController/NSObject+FBKVOController.h>

@interface AXOverviewViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, AXContentSelectionToolbarDelegate, UISearchResultsUpdating>

@end
