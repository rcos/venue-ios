//
//  AXImageTableViewCell.m
//  Venue
//
//  Created by Jim Boulter on 11/27/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import "AXImageTableViewCell.h"
#import <Masonry.h>
#import "UIImageView+Venue.h"

@interface AXImageTableViewCell () {
	UIImageView* imageView;
}

@end

@implementation AXImageTableViewCell

- (instancetype)init
{
	self = [super init];
	if (self) {
		imageView = [[UIImageView alloc] init];
		[self addSubview:imageView];
		
		[imageView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.edges.equalTo(self.view);
		}];
	}
	return self;
}

-(void)configureWithImageUrl:(NSString*)urlString {
	[imageView setImageWithUnknownPath:urlString];
}

@end
