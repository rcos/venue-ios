//
//  AXCourseTableViewCell.m
//  Venue
//
//  Created by Jim Boulter on 1/6/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import "AXCourseTableViewCell.h"

@interface AXCourseTableViewCell ()

@property UIImageView* sideImageView;
@property UILabel* titleLabel;
@property UILabel* subtitleLabel;
@property UILabel* classLabel;
@property UILabel* eventsLabel;

@end

@implementation AXCourseTableViewCell
@synthesize sideImageView, titleLabel, subtitleLabel, classLabel, eventsLabel;

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        sideImageView = [[UIImageView alloc] init];
        sideImageView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:sideImageView];
        
        titleLabel = [[UILabel alloc] init];
        titleLabel.backgroundColor = [UIColor greenColor];
        [titleLabel setContentCompressionResistancePriority:749 forAxis:UILayoutConstraintAxisHorizontal];
        [self.view addSubview:titleLabel];
        
        subtitleLabel = [[UILabel alloc] init];
        subtitleLabel.backgroundColor = [UIColor blueColor];
        [subtitleLabel setContentCompressionResistancePriority:749 forAxis:UILayoutConstraintAxisHorizontal];
        subtitleLabel.numberOfLines = 0;
        [self.view addSubview:subtitleLabel];
        
        classLabel = [[UILabel alloc] init];
        classLabel.text = @"CSCI-4269";
        classLabel.textColor = [UIColor lightGrayColor];
        classLabel.font = [UIFont thinFont];
        [classLabel setContentCompressionResistancePriority:751 forAxis:UILayoutConstraintAxisHorizontal];
        [self.view addSubview:classLabel];
        
        eventsLabel = [[UILabel alloc] init];
        eventsLabel.font = [UIFont systemFontOfSize:14];
        eventsLabel.textColor = [UIColor whiteColor];
        eventsLabel.backgroundColor = [UIColor venueRedColor];
        eventsLabel.text = @"2 events";
        eventsLabel.textAlignment = NSTextAlignmentCenter;
        eventsLabel.layer.cornerRadius = 8;
        eventsLabel.clipsToBounds = YES;

        [self.view addSubview:eventsLabel];
        
        UIEdgeInsets padding = UIEdgeInsetsMake(10, 10, -10, -10);
        
        [sideImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left);
            make.top.equalTo(self.view.mas_top);
            make.bottom.equalTo(self.view.mas_bottom);
            make.width.equalTo(@30);
        }];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(sideImageView.mas_right).with.offset(padding.left);
            make.top.equalTo(self.view.mas_top).with.offset(padding.top);
            make.right.equalTo(classLabel.mas_left).with.offset(padding.right);
            make.bottom.equalTo(subtitleLabel.mas_top).with.offset(padding.bottom);
        }];
        
        [subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(sideImageView.mas_right).with.offset(padding.left);
            make.top.equalTo(titleLabel.mas_bottom).with.offset(padding.top);
            make.right.equalTo(classLabel.mas_left).with.offset(padding.right);
            make.bottom.equalTo(self.view.mas_bottom).with.offset(padding.bottom);
        }];
        
        [classLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel.mas_right).with.offset(padding.left);
            make.top.equalTo(self.view.mas_top).with.offset(padding.top);
            make.right.equalTo(self.view.mas_right);
        }];
        
        [eventsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(classLabel.mas_left);
            make.right.equalTo(classLabel.mas_right);
            make.bottom.equalTo(self.view.mas_bottom).with.offset(padding.bottom);
        }];
    }
    return self;
}

-(void)configureWithDictionary:(NSDictionary*)dict
{
    [eventsLabel setHidden:([dict objectForKey:@"contentMode"]==AXContentModeEvents)];
}

@end
