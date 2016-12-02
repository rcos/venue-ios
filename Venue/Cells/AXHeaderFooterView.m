//
//  AXHeaderFooterView.m
//  Venue
//
//  Created by Jim Boulter on 12/1/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import "AXHeaderFooterView.h"
#import <Masonry.h>

@interface AXHeaderFooterView () {
	UILabel* label;
}
@end

@implementation AXHeaderFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		label = [[UILabel alloc] init];
		
		[label setFont:[UIFont boldFontOfSize:12]];
		[label setTextColor:[UIColor darkTextColor]];
		
		[self addSubview:label];
		[label mas_makeConstraints:^(MASConstraintMaker *make) {
			make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 20, 0, 20));
		}];
	}
	return self;
}

-(void)setTitle:(NSString *)title {
	_title = title;
	[label setText:title];
}

@end
