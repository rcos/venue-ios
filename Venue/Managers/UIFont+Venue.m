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

+(UIFont*)boldFont {
    return [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
}

+(UIFont*)boldFontOfSize:(NSInteger)size {
    return [UIFont fontWithName:@"HelveticaNeue-Bold" size:size];
}

+(UIFont*)regularFont {
    return [UIFont fontWithName:@"HelveticaNeue" size:14];
}

+(UIFont*)regularFontOfSize:(NSInteger)size {
    return [UIFont fontWithName:@"HelveticaNeue" size:size];
}

@end
