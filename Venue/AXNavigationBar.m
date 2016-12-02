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
    UIScrollView *scrollView;
	UIStackView* stackView;
    
    UILabel *title;
    UISegmentedControl *segmentedControl;
}

@end

@implementation AXNavigationBar

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
//        self.topLabel    = [[UILabel alloc] init];
//        self.midLabel    = [[UILabel alloc] init];
//        self.bottomLabel = [[UILabel alloc] init];
//        stackView        = [[UIStackView alloc] init];
//
//		[self setBarStyle:UIBarStyleBlack];
//        [stackView setAxis:UILayoutConstraintAxisVertical];
//        [stackView addArrangedSubviews:@[self.topLabel, self.midLabel, self.bottomLabel]];
//        for (UILabel *label in stackView.arrangedSubviews) {
//            [label setTextColor:[UIColor secondaryColor]];
//            [label setTextAlignment:NSTextAlignmentCenter];
//            [label setNumberOfLines:1];
//        }
//		
//		[self.topLabel setFont:[UIFont boldFontOfSize:18]];
//		[self.topLabel setAdjustsFontSizeToFitWidth:YES];
//		[self.topLabel setNumberOfLines:2];
//		[self.midLabel setFont:[UIFont boldFontOfSize:14]];
//		[self.bottomLabel setFont:[UIFont boldFontOfSize:14]];
//        
//		[self addSubview:stackView];
//		[stackView mas_makeConstraints:^(MASConstraintMaker *make) {
//			make.top.equalTo(self).offset(10);
//			make.bottom.equalTo(self).offset(-10);
//			make.left.equalTo(self).offset(30);
//			make.right.equalTo(self).offset(-30);
//		}];
        
        UIView *pageOne = [[UIView alloc] initWithFrame:CGRectZero];
        UIView *pageTwo = [[UIView alloc] initWithFrame:CGRectZero];
        
        scrollView       = [[UIScrollView alloc] initWithFrame:CGRectZero];
        title            = [[UILabel alloc] initWithFrame:CGRectZero];
        segmentedControl = [[UISegmentedControl alloc] initWithFrame:CGRectZero];
        
        [title setText:@"Venue"];
        [title setTextColor:[UIColor whiteColor]];
        [title setFont:[UIFont boldFontOfSize:22]];
        [title setTextAlignment:NSTextAlignmentCenter];
        [segmentedControl addTarget:self action:@selector(controlValueDidChange:) forControlEvents:UIControlEventValueChanged];
        [segmentedControl insertSegmentWithTitle:@"Events" atIndex:0 animated:NO];
        [segmentedControl insertSegmentWithTitle:@"Courses" atIndex:1 animated:NO];
        [segmentedControl setTintColor:[UIColor secondaryColor]];
        [segmentedControl setSelectedSegmentIndex:0];
        
        [pageOne addSubviews:@[title, segmentedControl]];
        [scrollView addSubviews:@[pageOne, pageTwo]];
        [self addSubview:scrollView];
        
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [pageOne mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.left.top.equalTo(scrollView);
        }];
        [pageTwo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.top.equalTo(scrollView);
            make.left.equalTo(pageOne.mas_right);
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
        
	}
	return self;
}

-(CGSize)sizeThatFits:(CGSize)size {
	CGSize newSize = [super sizeThatFits:size];
	newSize.height = 113;
	return newSize;
}

-(void)controlValueDidChange:(UISegmentedControl*)control {
    [self.customDelegate contentModeDidChange:control.selectedSegmentIndex];
}

@end
