//
//  AXExec.h
//  Venue
//
//  Created by Jim Boulter on 1/5/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface AXExec : NSObject

+(AppDelegate*)appDel;

+(NSString *) sanitizeNSString:(NSString *)string;

@end
