//
//  AXMapTableViewCell.h
//  Venue
//
//  Created by Jim Boulter on 11/27/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import "AXTableViewCell.h"
#import "AXEvent.h"

@interface AXMapTableViewCell : AXTableViewCell <MKMapViewDelegate>

-(void)configureWithEvent:(AXEvent*)event;

@end
