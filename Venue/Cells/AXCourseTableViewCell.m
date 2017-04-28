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
@property UIImageView* disclosureIndicatorView;

@end

@implementation AXCourseTableViewCell
@synthesize sideImageView, slideView, titleLabel, subtitleLabel, disclosureIndicatorView;

- (instancetype)init {
	if ((self = [super init])) {
        self.backgroundColor = [UIColor blackColor];
		
		self.contentView.layer.shouldRasterize = YES;
		self.contentView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
		
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        sideImageView = [[UIImageView alloc] init];
        [sideImageView setContentMode:UIViewContentModeScaleAspectFill];
        [sideImageView setClipsToBounds:YES];
        [self.view addSubview:sideImageView];
        
        UIView *brighter = [[UIView alloc] init];
        brighter.alpha = .15;
        brighter.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:brighter];
        
        slideView = [[UIView alloc] init];
        slideView.alpha = 1;
        slideView.backgroundColor = [UIColor whiteColor];
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:slideView.bounds];
        slideView.layer.masksToBounds = NO;
        slideView.layer.shadowColor = [[UIColor shadowGrayColor] CGColor];
        slideView.layer.shadowOffset = CGSizeMake(0, -2);
        slideView.layer.shadowRadius = 4;
        slideView.layer.shadowPath = shadowPath.CGPath;
		slideView.layer.shouldRasterize = YES;
		slideView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
		
        [self.view insertSubview:slideView aboveSubview:brighter];
        
        titleLabel = [[UILabel alloc] init];
        [titleLabel setContentCompressionResistancePriority:749 forAxis:UILayoutConstraintAxisHorizontal];
        titleLabel.numberOfLines = 0;
        [self.view addSubview:titleLabel];
        
        subtitleLabel = [[UILabel alloc] init];
        subtitleLabel.textColor = [UIColor darkTextColor];
        subtitleLabel.font = [UIFont thinFontOfSize:18];
        [subtitleLabel setContentCompressionResistancePriority:749 forAxis:UILayoutConstraintAxisHorizontal];
        [self.view addSubview:subtitleLabel];
        
        disclosureIndicatorView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DisclosureIndicator"]];
        [self.view addSubview:disclosureIndicatorView];
        
        UIEdgeInsets padding = UIEdgeInsetsMake(10, 10, -10, -10);
        
        [sideImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.bottom.equalTo(slideView.mas_top);
            make.height.equalTo(@120);
        }];
        
        [brighter mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(sideImageView);
        }];
        
        [slideView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left);
            make.top.equalTo(sideImageView.mas_bottom);
            make.right.equalTo(self.view);
            make.bottom.equalTo(self.view);
        }];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(slideView.mas_left).with.offset(padding.left);
            make.top.equalTo(slideView).with.offset(padding.top);
            make.right.equalTo(self.disclosureIndicatorView.mas_left).with.offset(padding.right);
            make.bottom.equalTo(subtitleLabel.mas_top).with.offset(.5*padding.bottom);
        }];
        
        [subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(slideView.mas_left).with.offset(padding.left);
            make.top.equalTo(titleLabel.mas_bottom).with.offset(.5*padding.top);
            make.right.equalTo(titleLabel).with.offset(padding.right*2);
            make.bottom.equalTo(slideView).offset(padding.bottom);
        }];
        
        [disclosureIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(slideView).with.offset(2*padding.right);
            make.centerY.equalTo(slideView);
            make.height.equalTo(@20);
            make.width.equalTo(@10);
        }];
    }
    return self;
}

- (void)configureWithCourse:(AXCourse*)course {
    titleLabel.text = course.name;
    subtitleLabel.text = [NSString stringWithFormat:@"%@-%@", course.department, course.courseNumber];
    [sideImageView setImageWithUnknownPath:course.imageUrl];
}

- (void)configureWithEvent:(AXEvent*)event {
    titleLabel.text = event.name;
    [subtitleLabel setText:[NSString stringWithFormat:@"%@ - %@", event.startTime, event.endTime]];
    [sideImageView setImageWithUnknownPath:event.imageUrl];
}

@end
