//
//  AXEventTableViewCell.m
//  Venue
//
//  Created by Jim Boulter on 1/10/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import "AXEventTableViewCell.h"

@interface AXEventTableViewCell ()

@property UILabel* titleLabel;
@property UILabel* subtitleLabel;
@property UILabel* dateLabel;

@end

@implementation AXEventTableViewCell
@synthesize titleLabel, subtitleLabel, dateLabel;

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        
        titleLabel = [[UILabel alloc] init];
        
        subtitleLabel = [[UILabel alloc] init];
        
        dateLabel = [[UILabel alloc] init];
        
        [self.view addSubview:titleLabel];
        [self.view addSubview:subtitleLabel];
        [self.view addSubview:dateLabel];
        
        UIEdgeInsets padding = UIEdgeInsetsMake(10, 10, -10, -10);
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).with.offset(padding.top);
            make.left.equalTo(self.view.mas_left).with.offset(padding.left);
            make.right.equalTo(dateLabel.mas_right).with.offset(padding.right);
            make.bottom.equalTo(subtitleLabel.mas_top).with.offset(padding.bottom);
        }];
        
        [subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).with.offset(padding.top);
            make.left.equalTo(self.view.mas_left).with.offset(padding.left);
            make.right.equalTo(dateLabel.mas_left).with.offset(padding.right);
            make.bottom.equalTo(self.view.mas_bottom).with.offset(padding.bottom);
        }];
        
        [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).with.offset(padding.top);
            make.left.equalTo(titleLabel.mas_right).with.offset(padding.left);
            make.right.equalTo(self.view.mas_right).with.offset(padding.right);
        }];
    }
    return self;
}

-(void)configureWithEvent:(NSDictionary *)event
{
    [titleLabel setText:event[@"info"][@"title"]];
    [subtitleLabel setText:event[@"info"][@"description"]];
    
    NSArray* times = event[@"info"][@"times"];
    if(times.count > 0)[dateLabel setText:[times firstObject]];
}

@end
