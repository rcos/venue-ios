//
//  AXExec.m
//  Venue
//
//  Created by Jim Boulter on 1/5/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import "AXExec.h"

@implementation AXExec

+(AppDelegate*)appDel
{
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}

#pragma mark - Utils

//Sanitizes an NSString, getting rid of &'s ='s and ?'s so it can be sent to a server
+(NSString *) sanitizeNSString:(NSString *)string
{
    NSMutableString *sanitized = [[string stringByReplacingOccurrencesOfString:@"&" withString:@""] copy];
    sanitized = [[sanitized stringByReplacingOccurrencesOfString:@"=" withString:@""] copy];
    sanitized = [[sanitized stringByReplacingOccurrencesOfString:@"?" withString:@""] copy];
    
    return [NSString stringWithFormat:@"%@", sanitized];
}

@end
