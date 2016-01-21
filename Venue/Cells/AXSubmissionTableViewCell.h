//
//  AXSubmissionTableViewCell.h
//  Venue
//
//  Created by Jim Boulter on 1/14/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import "AXTableViewCell.h"
#import "Masonry.h"
#import "AXAPI.h"

@interface AXSubmissionTableViewCell : AXTableViewCell

-(instancetype)initWithSubmission:(NSDictionary*)submission;

@end
