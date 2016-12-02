//
//  AXDetailViewController.h
//  Venue
//
//  Created by Jim Boulter on 1/9/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"
#import "AXNavigationBar.h"

@interface AXDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property UIProgressView* progressView;
@property UILabel* emptyLabel;
@property UITableView* tableView;
@property UIRefreshControl* refreshControl;

@property AXNavigationBar* navBar;

@end
