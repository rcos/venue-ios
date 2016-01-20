//
//  UIFont+Venue.m
//  Venue
//
//  Created by Jim Boulter on 1/6/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import "UIFont+Venue.h"

@implementation UIFont (Venue)

+(UIFont*)thinFont
{
    return [UIFont fontWithName:@"HelveticaNeue-Thin" size:14];
}

+(UIFont*)thinFontOfSize:(NSInteger)size
{
    return [UIFont fontWithName:@"HelveticaNeue-Thin" size:size];
}

@end
