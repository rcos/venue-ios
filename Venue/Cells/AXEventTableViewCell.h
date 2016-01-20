//
//  AXEventTableViewCell.h
//  Venue
//
//  Created by Jim Boulter on 1/10/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import "AXTableViewCell.h"
#import "Masonry.h"

@interface AXEventTableViewCell : AXTableViewCell

-(void)configureWithEvent:(NSDictionary*)event;

@end
