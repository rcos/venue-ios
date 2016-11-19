//
//  UIColor+Venue.m
//  Venue
//
//  Created by Jim Boulter on 1/5/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import "UIColor+Venue.h"

@implementation UIColor(Venue)

+(UIColor*)venueRedColor
{
    return COLOR_WITH_PERCENTAGES(0.96, 0.16, 0.12);
}

+(UIColor *)venueBlueColor {
    return COLOR(0, 173, 238);
}

+(UIColor*)venueBlackColor {
    return COLOR(51, 51, 51);
}

+(UIColor*)rpiRedColor {
    return COLOR_WITH_PERCENTAGES(0.89, 0.14, 0.11);
}

+(UIColor *)randomColor
{
    /*
     github.com/kylefox/color.m
     Distributed under The MIT License:
     http://opensource.org/licenses/mit-license.php
     */
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

+(UIColor*)shadowGrayColor {
    return [UIColor colorWithWhite:1 alpha:.15];
}

+(UIColor*)paleGrayColor {
    return COLOR(239, 239, 244);
}

// Color variables

+(UIColor*)primaryColor {
    return [self venueBlackColor];
}

+(UIColor*)secondaryColor {
    return [self whiteColor];
}

+(UIColor*)accentColor {
    return [self venueBlueColor];
}

+(UIColor*)backgroundColor {
    return  [self paleGrayColor];
}

+(UIColor*)darkTextColor {
    return [self darkGrayColor];
}

@end
