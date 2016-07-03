//
//  UIImageView_UIImageView_Venue.h
//  Venue
//
//  Created by Jim Boulter on 7/3/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AXAPI.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface UIImageView (Venue)
- (void) setImageWithUnknownPath:(NSString*)path;
@end
