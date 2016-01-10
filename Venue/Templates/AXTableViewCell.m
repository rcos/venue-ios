//
//  AXTableViewCell.m
//  Venue
//
//  Created by Jim Boulter on 1/6/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import "AXTableViewCell.h"

@implementation AXTableViewCell

-(instancetype)init
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[AXTableViewCell reuseIdentifier]];
    if(self)
    {
        self.view = self.contentView;
    }
    return self;
}

+(NSString*)reuseIdentifier
{
    return NSStringFromClass([self class]);
}

@end
