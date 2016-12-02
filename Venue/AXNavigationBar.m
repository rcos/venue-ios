//
//  AXNavigationBar.m
//  Venue
//
//  Created by Jim Boulter on 11/27/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import "AXNavigationBar.h"
#import <Masonry.h>

@interface AXNavigationBar () {
	UIStackView* stackView;
    
    UILabel *title;
    UISegmentedControl *segmentedControl;
    
    UIView *pageOne;
    UIView *pageTwo;
}
@property (strong, nonatomic) UILabel* topLabel;
@property (strong, nonatomic) UILabel* midLabel;
@property (strong, nonatomic) UILabel* bottomLabel;
@property (strong, nonatomic) UIButton *backButton;

@end

@implementation AXNavigationBar

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
        pageOne = [[UIView alloc] initWithFrame:CGRectZero];
        pageTwo = [[UIView alloc] initWithFrame:CGRectZero];
        
        self.backButton  = [[UIButton alloc] initWithFrame:CGRectZero];
        self.topLabel    = [[UILabel alloc] init];
        self.midLabel    = [[UILabel alloc] init];
        self.bottomLabel = [[UILabel alloc] init];
        title            = [[UILabel alloc] initWithFrame:CGRectZero];
        segmentedControl = [[UISegmentedControl alloc] initWithFrame:CGRectZero];
        stackView        = [[UIStackView alloc] init];
        
        [self setBackgroundColor:[UIColor venueBlackColor]];
        [title setText:@"Venue"];
        [title setTextColor:[UIColor whiteColor]];
        [title setFont:[UIFont boldFontOfSize:22]];
        [title setTextAlignment:NSTextAlignmentCenter];
        [segmentedControl addTarget:self action:@selector(controlValueDidChange:) forControlEvents:UIControlEventValueChanged];
        [segmentedControl insertSegmentWithTitle:@"Events" atIndex:0 animated:NO];
        [segmentedControl insertSegmentWithTitle:@"Courses" atIndex:1 animated:NO];
        [segmentedControl setTintColor:[UIColor secondaryColor]];
        [segmentedControl setSelectedSegmentIndex:0];
        [stackView setAxis:UILayoutConstraintAxisVertical];
        [stackView addArrangedSubviews:@[self.topLabel, self.midLabel, self.bottomLabel]];
        for (UILabel *label in stackView.arrangedSubviews) {
            [label setTextColor:[UIColor secondaryColor]];
            [label setTextAlignment:NSTextAlignmentCenter];
            [label setNumberOfLines:1];
        }
        [self.topLabel setFont:[UIFont boldFontOfSize:18]];
        [self.topLabel setAdjustsFontSizeToFitWidth:YES];
        [self.topLabel setNumberOfLines:2];
        [self.midLabel setFont:[UIFont boldFontOfSize:14]];
        [self.bottomLabel setFont:[UIFont boldFontOfSize:14]];
        [self.backButton setImage:[UIImage imageNamed:@"Back"] forState:UIControlStateNormal];
        [self.backButton setAlpha:0];
        
        [pageOne addSubviews:@[title, segmentedControl]];
        [pageTwo addSubviews:@[stackView]];
        [self addSubviews:@[pageOne, pageTwo, self.backButton]];
        
        [pageOne mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.left.top.equalTo(self);
        }];
        [pageTwo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.left.top.equalTo(self);
        }];
        [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@12.5);
            make.height.equalTo(@21);
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(15);
        }];

        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(pageOne).offset(15);
            make.right.equalTo(pageOne).offset(-15);
            make.top.equalTo(pageOne).offset(20);
            make.height.equalTo(@25);
        }];
        [segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(pageOne);
            make.bottom.equalTo(pageOne).offset(-15);
            make.height.equalTo(@29);
            make.width.equalTo(@282);
        }];
        [stackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(pageTwo).offset(10);
            make.bottom.equalTo(pageTwo).offset(-10);
            make.left.equalTo(pageTwo).offset(30);
            make.right.equalTo(pageTwo).offset(-30);
        }];
        
        [pageTwo setUserInteractionEnabled:NO];
	}
	return self;
}

#pragma mark - Actions

-(void)controlValueDidChange:(UISegmentedControl*)control {
    [self.delegate contentModeDidChange:control.selectedSegmentIndex];
}

- (void)setEvent:(AXEvent *)event {
    self.topLabel.text = event.name;
    
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateStyle:NSDateFormatterMediumStyle];
    NSString* date = [df stringFromDate:event.startDate];
    self.midLabel.text = [NSString stringWithFormat:@"%@", date];
    
    self.bottomLabel.text = [NSString stringWithFormat:@"%@ - %@", event.startTime, event.endTime];
}

- (void)setCourse:(AXCourse *)course {
    
}

#pragma mark - AXNavigationControllerDelegate

- (void)didPopViewController:(UINavigationController *)navigationController {
    if (navigationController.viewControllers.count == 1) {
        [pageOne setAlpha:1];
        [UIView animateKeyframesWithDuration:standardAnimationDuration delay:0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
            [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.5 animations:^{
                [pageTwo setAlpha:0];
                [self.backButton setAlpha:0];
            }];
            [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:1.0 animations:^{
                [pageOne setAlpha:1];
            }];
        } completion:nil];
    }
}

- (void)didPushViewController:(UINavigationController *)navigationController {
    [pageTwo setAlpha:0];
    [UIView animateKeyframesWithDuration:standardAnimationDuration delay:0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.5 animations:^{
            [pageTwo setAlpha:1];
            [self.backButton setAlpha:1];
        }];
        [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:1.0 animations:^{
            [pageOne setAlpha:0];
        }];
    } completion:nil];
}

@end
