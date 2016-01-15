//
//  AXDetailViewController.h
//  Venue
//
//  Created by Jim Boulter on 1/9/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"

@interface AXDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property UIImageView* imageView;
@property UIVisualEffectView* blurView;
@property UILabel* detailTitleLabel;
@property UILabel* detailSubtitleLabel;
@property UITextView* detailDescriptionTextView;
@property UILabel* tableTitleLabel;
@property UITableView* tableView;

@end