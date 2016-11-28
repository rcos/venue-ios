//
//  NSString+Venue.m
//  Venue
//
//  Created by Jim Boulter on 11/27/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import "NSString+Venue.h"

@implementation NSString (Venue)

-(BOOL)isEmpty {
	return self == nil || [self isEqualToString:@""];
}

@end
