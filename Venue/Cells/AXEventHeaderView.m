//
//  AXEventHeaderView.m
//  Venue
//
//  Created by Max Shavrick on 3/7/17.
//  Copyright © 2017 JimBoulter. All rights reserved.
//

#import "AXEventHeaderView.h"
#import "UIColor+Venue.h"

@implementation AXEventHeaderView {
	UILabel *dateLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		dateLabel = [[UILabel alloc] init];
		[self addSubview:dateLabel];
		
		[self setBackgroundColor:[UIColor paleGrayColor]];
	}
	
	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	[dateLabel setFrame:CGRectMake(10, 5, self.frame.size.width - 20, self.frame.size.height - 2 * 5)];
}

- (void)setDateString:(NSString *)str {
	[dateLabel setText:str];
}

@end
