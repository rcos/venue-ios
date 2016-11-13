//
//  AXIconTableViewCell.m
//  Venue
//
//  Created by Jim Boulter on 11/7/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import "AXLocationTableViewCell.h"
#import <Masonry.h>

@implementation AXIconTableViewCell {
    UILabel* label;
    UIImageView* icon;
}

-(instancetype)initWithText:(NSString*)address mode:(AXIconMode)mode {
    self = [super init];
    if(self) {
        label = [[UILabel alloc] init];
        label.font = [UIFont regularFont];
        [label setText:address];
        
        icon = [[UIImageView alloc] init];
        if(mode == AXAddressMode) {
            [icon setImage:[UIImage imageNamed:@"NavIcon"]];
        } else { // AXSubmissionMode
            [icon setImage:[UIImage imageNamed:@"BoxPlus"]];
        }
    
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(15);
            make.right.equalTo(icon.mas_left).offset(10);
            make.top.equalTo(self.view).offset(15);
            make.bottom.equalTo(self.view).offset(15);
        }];
        
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view).offset(15);
            make.top.equalTo(self.view).offset(15);
            make.bottom.equalTo(self.view).offset(15);
        }];
    }
    return self;
}

@end
