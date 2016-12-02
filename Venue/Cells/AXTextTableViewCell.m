//
//  AXTextTableViewCell.m
//  Venue
//
//  Created by Jim Boulter on 11/7/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import "AXTextTableViewCell.h"
#import <Masonry.h>

@implementation AXTextTableViewCell {
    UILabel* label;
    UIView* divider;
}

-(instancetype)init {
    self = [super init];
    if(self) {
        label   = [[UILabel alloc] init];
        divider = [[UIView alloc] init];
        
        label.font          = [UIFont regularFont];
        label.numberOfLines = 0;
		[divider setBackgroundColor:[UIColor backgroundColor]];
        
        [self.view addSubviews:@[label, divider]];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(20, 20, 20, 20));
        }];
        [divider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.left.equalTo(self.view).offset(30);
            make.right.equalTo(self.view).offset(-30);
            make.height.equalTo(@1);
        }];
    }
    return self;
}

-(void)configureWithText:(NSString*)text divider:(BOOL)divided {
	label.text = text;
	divider.hidden = !divided;
}

@end
