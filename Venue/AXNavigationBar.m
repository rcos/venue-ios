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
}

@end

@implementation AXNavigationBar

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self setBarStyle:UIBarStyleBlack];
		
		self.topLabel = [[UILabel alloc] init];
		[self.topLabel setFont:[UIFont boldFontOfSize:18]];
		[self.topLabel setAdjustsFontSizeToFitWidth:YES];
		[self.topLabel setTextColor:[UIColor secondaryColor]];
		[self.topLabel setNumberOfLines:2];
		[self.topLabel setTextAlignment:NSTextAlignmentCenter];
		[self addSubview:self.topLabel];
		
		self.midLabel = [[UILabel alloc] init];
		[self.midLabel setFont:[UIFont boldFontOfSize:14]];
		[self.midLabel setTextColor:[UIColor secondaryColor]];
		[self.midLabel setNumberOfLines:1];
		[self.midLabel setTextAlignment:NSTextAlignmentCenter];
		[self addSubview:self.midLabel];
		
		self.bottomLabel = [[UILabel alloc] init];
		[self.bottomLabel setFont:[UIFont boldFontOfSize:14]];
		[self.bottomLabel setTextColor:[UIColor secondaryColor]];
		[self.bottomLabel setNumberOfLines:1];
		[self.bottomLabel setTextAlignment:NSTextAlignmentCenter];
		[self addSubview:self.bottomLabel];
		
		stackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.topLabel, self.midLabel, self.bottomLabel]];
		[stackView setAxis:UILayoutConstraintAxisVertical];
		[self addSubview:stackView];
		
		[stackView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self).offset(10);
			make.bottom.equalTo(self).offset(-10);
			make.left.equalTo(self).offset(30);
			make.right.equalTo(self).offset(-30);
		}];
	}
	return self;
}

-(CGSize)sizeThatFits:(CGSize)size {
	CGSize s = [super sizeThatFits:size];
	s.height = 113;
	return s;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
