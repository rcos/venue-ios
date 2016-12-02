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
		
		UIView* container = [[UIView alloc] init];
		
		imageView = [[UIImageView alloc] init];
		imageView.layer.masksToBounds = YES;
		[imageView setContentMode:UIViewContentModeScaleAspectFill];
		
		[self.view addSubview:container];
		[container addSubview:imageView];
		[container mas_makeConstraints:^(MASConstraintMaker *make) {
			make.edges.equalTo(self.view);
			make.height.equalTo(@150);
		}];
		[imageView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.edges.equalTo(container);
		}];
	}
	return self;
}

-(void)configureWithImageUrl:(NSString*)urlString {
	[imageView setImageWithUnknownPath:urlString];
}

@end
