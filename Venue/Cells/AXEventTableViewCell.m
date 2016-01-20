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
        [titleLabel setContentHuggingPriority:1000 forAxis:UILayoutConstraintAxisVertical];
        
        subtitleLabel = [[UILabel alloc] init];
        [subtitleLabel setFont:[UIFont systemFontOfSize:12]];
        [subtitleLabel setNumberOfLines:0];
        
        dateLabel = [[UILabel alloc] init];
        [dateLabel setFont:[UIFont thinFont]];
        [dateLabel setTextColor:[UIColor grayColor]];
        [dateLabel setTextAlignment:NSTextAlignmentRight];
        [dateLabel setContentCompressionResistancePriority:800 forAxis:UILayoutConstraintAxisHorizontal];
        
        
        [self.view addSubview:titleLabel];
        [self.view addSubview:subtitleLabel];
        [self.view addSubview:dateLabel];
        
        UIEdgeInsets padding = UIEdgeInsetsMake(10, 10, -10, -10);
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).with.offset(padding.top);
            make.left.equalTo(self.view.mas_left).with.offset(padding.left);
            make.right.equalTo(dateLabel.mas_left).with.offset(padding.right);
            make.bottom.equalTo(subtitleLabel.mas_top).with.offset(padding.bottom);
        }];
        
        [subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).with.offset(padding.top);
            make.left.equalTo(self.view.mas_left).with.offset(2*padding.left);
            make.right.equalTo(self.view.mas_right).with.offset(padding.right);
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
    if(times.count > 0)
    {
        NSDictionary* time = [times firstObject];
        NSString* start = time[@"start"];
        NSString* end = time[@"end"];
        
        NSDateFormatter* df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSz"];
        
        NSDate* startDate = [df dateFromString:start];
        NSDate* endDate = [df dateFromString:end];
        
        [df setDateFormat:@"h:mm"];
        NSString* startTime = [df stringFromDate:startDate];
        NSString* endTime = [df stringFromDate:endDate];
        
        [dateLabel setText:[NSString stringWithFormat:@"%@-%@", startTime, endTime]];
    }
}

@end
