//
//  AXOverViewNavigationBarPage.m
//  Venue
//
//  Created by Rocco Del Priore on 12/2/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import "AXOverViewNavigationBarPage.h"
#import "AXAppCoordinator.h"

@interface AXOverViewNavigationBarPage ()
@property (nonatomic) UISegmentedControl *segmentedControl;
@end

@implementation AXOverViewNavigationBarPage {
    UILabel *title;
    UIButton *settings;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        title                 = [[UILabel alloc] initWithFrame:CGRectZero];
        settings                = [[UIButton alloc] initWithFrame:CGRectZero];
        self.segmentedControl = [[UISegmentedControl alloc] initWithFrame:CGRectZero];
        
        [title setText:@"Venue"];
        [title setTextColor:[UIColor whiteColor]];
        [title setFont:[UIFont boldFontOfSize:22]];
        [title setTextAlignment:NSTextAlignmentCenter];
        [settings setImage:[UIImage imageNamed:@"Gear"] forState:UIControlStateNormal];
        [settings addTarget:self action:@selector(showSettings) forControlEvents:UIControlEventTouchUpInside];
        [self.segmentedControl insertSegmentWithTitle:@"Events" atIndex:0 animated:NO];
        [self.segmentedControl insertSegmentWithTitle:@"Courses" atIndex:1 animated:NO];
        [self.segmentedControl setTintColor:[UIColor secondaryColor]];
        [self.segmentedControl setSelectedSegmentIndex:0];
        
        [self addSubviews:@[self.segmentedControl, title, settings]];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.right.equalTo(self).offset(-15);
            make.top.equalTo(self).offset(20);
            make.height.equalTo(@25);
        }];
        [settings mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(18);
            make.top.equalTo(self).offset(28);
            make.height.equalTo(@28);
            make.width.equalTo(@30);
        }];
        [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self).offset(-15);
            make.height.equalTo(@29);
            make.width.equalTo(@282);
        }];
    }
    return self;
}

- (instancetype)init {
    self = [self initWithFrame:CGRectZero];
    return self;
}

- (void)showSettings {
    [[AXAppCoordinator sharedInstance] navigateToSettings];
}

@end
