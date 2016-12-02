//
//  AXNavigationBar.m
//  Venue
//
//  Created by Jim Boulter on 11/27/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import "AXNavigationBar.h"
#import "AXOverViewNavigationBarPage.h"
#import "AXDetailViewNavigationBarPage.h"

@interface AXNavigationBar () {
    AXOverViewNavigationBarPage *pageOne;
    AXDetailViewNavigationBarPage *pageTwo;
}
@property (strong, nonatomic) UIButton *backButton;

@end

@implementation AXNavigationBar

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
        pageOne         = [[AXOverViewNavigationBarPage alloc] initWithFrame:CGRectZero];
        pageTwo         = [[AXDetailViewNavigationBarPage alloc] initWithFrame:CGRectZero];
        self.backButton = [[UIButton alloc] initWithFrame:CGRectZero];
        
        [self setBackgroundColor:[UIColor venueBlackColor]];
        [self.backButton setAlpha:0];
        [self.backButton setImage:[UIImage imageNamed:@"Back"] forState:UIControlStateNormal];
        [pageOne.segmentedControl addTarget:self action:@selector(controlValueDidChange:) forControlEvents:UIControlEventValueChanged];
        [pageTwo setUserInteractionEnabled:NO];
        
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
	}
	return self;
}

#pragma mark - Actions

-(void)controlValueDidChange:(UISegmentedControl*)control {
    [self.delegate contentModeDidChange:control.selectedSegmentIndex];
}

- (void)setEvent:(AXEvent *)event {
    [pageTwo setEvent:event];
}

- (void)setCourse:(AXCourse *)course {
    [pageTwo setCourse:course];
}

#pragma mark - AXNavigationControllerDelegate

- (void)didPopViewController:(UINavigationController *)navigationController {
    if (navigationController.viewControllers.count == 1) {
        [pageOne setAlpha:0];
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
    [self.backButton setAlpha:0];
    [UIView animateKeyframesWithDuration:standardAnimationDuration delay:0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.5 animations:^{
            [pageOne setAlpha:0];
        }];
        [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:1.0 animations:^{
            [pageTwo setAlpha:1];
            [self.backButton setAlpha:1];
        }];
    } completion:nil];
}

@end
