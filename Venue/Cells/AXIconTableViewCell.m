//
//  AXIconTableViewCell.m
//  Venue
//
//  Created by Jim Boulter on 11/7/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import "AXIconTableViewCell.h"
#import <Masonry.h>

@implementation AXIconTableViewCell {
    UILabel* label;
    UIImageView* icon;
}

-(instancetype)init {
    self = [super init];
    if(self) {
        label = [[UILabel alloc] init];
        label.font = [UIFont boldFont];
		label.numberOfLines = 0;
		[self.view addSubview:label];
		
		icon = [[UIImageView alloc] init];
		[self.view addSubview:icon];
    
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(15);
            make.right.equalTo(icon.mas_left).offset(-10);
            make.top.equalTo(self.view).offset(15);
            make.bottom.equalTo(self.view).offset(-15);
        }];
        
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view).offset(-15);
			make.centerY.equalTo(self.view);
			make.height.equalTo(@25);
			make.width.equalTo(@25);
			make.top.greaterThanOrEqualTo(self.view).offset(15);
			make.bottom.lessThanOrEqualTo(self.view).offset(-15);
        }];
    }
    return self;
}

-(void)configureWithText:(NSString *)address mode:(AXIconMode)mode {
	[label setText:address];
	
	if(mode == AXAddressMode) {
		[icon setImage:[UIImage imageNamed:@"NavIcon"]];
	} else { // AXSubmissionMode
		[icon setImage:[UIImage imageNamed:@"BoxPlus"]];
	}
}

@end
