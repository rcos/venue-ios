//
//  AXUtilities.m
//  Venue
//
//  Created by Max Shavrick on 2/28/17.
//  Copyright © 2017 JimBoulter. All rights reserved.
//

#import <Foundation/Foundation.h>

extern void AXLog(NSString *fmt, ...) {
#if DEBUG
	
	// will move this to os_log
	
	va_list args;
	va_start(args, fmt);
	NSString *join = [[NSString alloc] initWithFormat:fmt arguments:args];
	va_end(args);
	NSLog(@"%@:::%@", join, [NSThread callStackSymbols]);
#endif
}
