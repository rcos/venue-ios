//
//  UIImageView+Venue.m
//  Venue
//
//  Created by Jim Boulter on 7/3/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import "UIImageView+Venue.h"

@implementation UIImageView (Venue)

- (void) setImageWithUnknownPath:(NSString*)path
{
    if([path hasPrefix:@"http"])
    {
        [self sd_setImageWithURL: [NSURL URLWithString:path]];
    }
    else
    {
        NSString* imageUrl = [path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [[AXAPI API] getImageAtPath:imageUrl completion:^(UIImage *image) {
            [self setImage:image];
        }];
    }
}

@end