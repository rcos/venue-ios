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
    return [UIColor colorWithRed:0.96 green:0.16 blue:0.12 alpha:1];
}

+(UIColor*)rpiRedColor {
    return [UIColor colorWithRed:0.89 green:0.14 blue:0.11 alpha:1.00];
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

@end
