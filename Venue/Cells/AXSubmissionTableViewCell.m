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

-(instancetype)initWithSubmission:(NSDictionary*)submission
{
    self = [super init];
    if(self)
    {
        self.userInteractionEnabled = NO;
        
        titleLabel = [[UILabel alloc] init];
        [titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
        [titleLabel setText:[NSString stringWithFormat:@"%@ %@",submission[@"submitter"][@"firstName"], submission[@"submitter"][@"lastName"]]];
        [self.view addSubview:titleLabel];
        
        subtitleLabel = [[UILabel alloc] init];
        [subtitleLabel setTextColor:[UIColor grayColor]];
        [subtitleLabel setFont:[UIFont thinFont]];
        
        NSDateFormatter* df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSz"];
        
        NSDate* startDate = [df dateFromString:submission[@"time"]];
    
        [df setDateFormat:@"h:mma"];
        NSString* time = [df stringFromDate:startDate];
        [subtitleLabel setText:time];

        [self.view addSubview:subtitleLabel];
        
        submissionImageView = [[UIImageView alloc] init];
        submissionImageView.layer.cornerRadius = 4;
        submissionImageView.clipsToBounds = YES;
        submissionImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        [[AXAPI API] getImageAtPath:[submission[@"images"] firstObject] completion:^(UIImage *image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView transitionWithView:submissionImageView
                                  duration:0.2
                                   options:UIViewAnimationOptionTransitionCrossDissolve
                                animations:^{
                                    [submissionImageView setImage:image];
                                } completion:nil];
            });
            
        }];
        
//        [submissionImageView setImageWithURL:[NSURL URLWithString:[submission[@"images"] firstObject]
//                                                    relativeToURL:[NSURL URLWithString:baseURL]]];
        
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
