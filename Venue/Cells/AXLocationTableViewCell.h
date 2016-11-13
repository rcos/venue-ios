//
//  AXIconTableViewCell.h
//  Venue
//
//  Created by Jim Boulter on 11/7/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import "AXTableViewCell.h"

typedef enum : NSUInteger {
    AXAddressMode,
    AXSubmissionMode
} AXIconMode;

@interface AXIconTableViewCell : AXTableViewCell

-(instancetype)initWithText:(NSString*)address mode:(AXIconMode)mode;

@end
