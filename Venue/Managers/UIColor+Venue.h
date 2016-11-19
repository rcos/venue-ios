//
//  UIColor+Venue.h
//  Venue
//
//  Created by Jim Boulter on 1/5/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import <UIKit/UIKit.h>

#define COLOR(r, g, b) \
    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];

#define COLOR_WITH_PERCENTAGES(r, g, b) \
    [UIColor colorWithRed:r green:g blue:b alpha:1];

#define COLOR_WITH_ALPHA(r, g, b, a) \
    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a];

@interface UIColor(Venue)

+(UIColor*)venueRedColor;
+(UIColor*)rpiRedColor;
+(UIColor*)venueBlackColor;
+(UIColor*)venueBlueColor;

+(UIColor*)randomColor;
+(UIColor*)shadowGrayColor;
+(UIColor*)paleGrayColor;

+(UIColor*)primaryColor;
+(UIColor*)secondaryColor;
+(UIColor*)accentColor;
+(UIColor*)backgroundColor;

@end
