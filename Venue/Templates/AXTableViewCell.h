//
//  AXTableViewCell.h
//  Venue
//
//  Created by Jim Boulter on 1/6/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AXTableViewCell : UITableViewCell

+(NSString*)reuseIdentifier;

@property UIView* view;

@end
