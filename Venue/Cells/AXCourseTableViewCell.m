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
@property UIView* slideView;
@property UILabel* titleLabel;
@property UILabel* subtitleLabel;
@property UILabel* classLabel;
@property UILabel* eventsLabel;

@end

@implementation AXCourseTableViewCell
@synthesize sideImageView, slideView, titleLabel, subtitleLabel, classLabel, eventsLabel;

-(instancetype)init
{
    self = [super init];
    if(self)
    {
//        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        sideImageView = [[UIImageView alloc] init];
//        [sideImageView setImage:[UIImage imageNamed:@"Firework"]];
        [self.view addSubview:sideImageView];
        
        slideView = [[UIView alloc] initWithFrame:self.view.frame];
        slideView.alpha = .9;
        slideView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:slideView];
        
        
        
        titleLabel = [[UILabel alloc] init];
        [titleLabel setContentCompressionResistancePriority:749 forAxis:UILayoutConstraintAxisHorizontal];
        [self.view addSubview:titleLabel];
        
        subtitleLabel = [[UILabel alloc] init];
        [subtitleLabel setContentCompressionResistancePriority:751 forAxis:UILayoutConstraintAxisHorizontal];
        [subtitleLabel setFont:[UIFont systemFontOfSize:12]];
        subtitleLabel.numberOfLines = 0;
        [self.view addSubview:subtitleLabel];
        
        classLabel = [[UILabel alloc] init];
        classLabel.textColor = [UIColor lightGrayColor];
        classLabel.font = [UIFont thinFontOfSize:17];
        [classLabel setContentCompressionResistancePriority:749 forAxis:UILayoutConstraintAxisHorizontal];
        [self.view addSubview:classLabel];
        
        eventsLabel = [[UILabel alloc] init];
        eventsLabel.font = [UIFont systemFontOfSize:10];
        eventsLabel.textColor = [UIColor whiteColor];
        eventsLabel.backgroundColor = [UIColor venueRedColor];
        eventsLabel.text = @"2 EVENTS";
        eventsLabel.textAlignment = NSTextAlignmentCenter;
        eventsLabel.layer.cornerRadius = 8;
        eventsLabel.clipsToBounds = YES;
        [self.view addSubview:eventsLabel];
        
        UIEdgeInsets padding = UIEdgeInsetsMake(10, 10, -10, -10);
        
//        [sideImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.view.mas_left);
//            make.top.equalTo(self.view.mas_top);
//            make.bottom.equalTo(self.view.mas_bottom);
//            make.width.equalTo(@30);
//        }];
        [sideImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        [slideView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).with.offset(3*padding.left);
            make.top.equalTo(self.view.mas_top).with.offset(padding.top);
            make.right.equalTo(self.view.mas_right);
            make.bottom.equalTo(self.view.mas_bottom).with.offset(padding.bottom);
        }];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(slideView.mas_left).with.offset(padding.left);
            //make.top.equalTo(self.view.mas_top).with.offset(padding.top);
            make.right.equalTo(subtitleLabel.mas_left).with.offset(padding.right);
            make.bottom.equalTo(self.view.mas_centerY).with.offset(padding.bottom);
        }];
        
        [classLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(slideView.mas_left).with.offset(padding.left);
            make.top.equalTo(titleLabel.mas_bottom).with.offset(padding.top);
            make.right.equalTo(subtitleLabel.mas_left).with.offset(padding.right);
            //make.bottom.equalTo(self.view.mas_bottom).with.offset(padding.bottom);
        }];
        
        [subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel.mas_right).with.offset(padding.left);
            make.top.equalTo(self.view.mas_top).with.offset(padding.top);
            make.right.equalTo(self.view.mas_right);
        }];
        
//        [eventsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(subtitleLabel.mas_left);
//            make.right.equalTo(subtitleLabel.mas_right);
//            make.bottom.equalTo(self.view.mas_bottom).with.offset(padding.bottom);
//            make.height.equalTo(@16);
//        }];
        
//        CAShapeLayer * maskLayer = [CAShapeLayer layer];
//        maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:slideView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:(CGSize){6.0, 6.0}].CGPath;
//        slideView.layer.mask = maskLayer;

    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

-(void)configureWithCourse:(NSDictionary*)course
{
    titleLabel.text = course[@"name"];
    //subtitleLabel.text = course[@"description"];
    classLabel.text = [NSString stringWithFormat:@"%@-%@", course[@"department"], course[@"courseNumber"]];
    sideImageView.backgroundColor = [UIColor randomColor];
}

-(void)configureWithEvent:(NSDictionary*)event
{
    titleLabel.text = event[@"info"][@"title"];
    //subtitleLabel.text = course[@"description"];
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
        
        [df setDateFormat:@"MM/dd h:mma"];
        NSString* startTime = [df stringFromDate:startDate];
        [df setDateFormat:@"h:mma"];
        NSString* endTime = [df stringFromDate:endDate];
        
        [classLabel setText:[NSString stringWithFormat:@"%@ - %@", startTime, endTime]];
    }
//    classLabel.text = [NSString stringWithFormat:@"%@-%@", event[@"department"], event[@"courseNumber"]];
    sideImageView.backgroundColor = [UIColor randomColor];
}

@end
