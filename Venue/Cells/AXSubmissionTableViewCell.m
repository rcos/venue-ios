//
//  AXSubmissionTableViewCell.m
//  Venue
//
//  Created by Jim Boulter on 1/14/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import "AXSubmissionTableViewCell.h"

@interface AXSubmissionTableViewCell ()

@property UILabel* titleLabel;
@property UILabel* subtitleLabel;
@property UIImageView* submissionImageView;

@end

@implementation AXSubmissionTableViewCell
@synthesize titleLabel, subtitleLabel, submissionImageView;

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        titleLabel = [[UILabel alloc] init];
        [self.view addSubview:titleLabel];
        
        subtitleLabel = [[UILabel alloc] init];
        [self.view addSubview:subtitleLabel];
        
        submissionImageView = [[UIImageView alloc] init];
        [self.view addSubview:submissionImageView];
        
        UIEdgeInsets padding = UIEdgeInsetsMake(10, 10, -10, -10);
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).with.offset(padding.left);
            make.top.equalTo(self.view.mas_top).with.offset(padding.top);
            make.bottom.equalTo(submissionImageView.mas_top).with.offset(padding.bottom);
        }];
        
        [subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view.mas_right).with.offset(padding.right);
            make.top.equalTo(self.view.mas_top).with.offset(padding.top);
            make.bottom.equalTo(submissionImageView.mas_top).with.offset(padding.bottom);
        }];
        
        [submissionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).with.offset(padding.left);
            make.top.equalTo(titleLabel.mas_bottom).with.offset(padding.top);
            make.right.equalTo(self.view.mas_right).with.offset(padding.right);
            make.bottom.equalTo(self.view.mas_bottom).with.offset(padding.bottom);
        }];
    }
    return self;
}

@end
