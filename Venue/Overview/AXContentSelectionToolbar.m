//
//  AXContentSelectionToolbar.m
//  Venue
//
//  Created by Jim Boulter on 1/5/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import "AXContentSelectionToolbar.h"

@interface AXContentSelectionToolbar ()

@property UISegmentedControl* segmentedControl;
@property id<AXContentSelectionToolbarDelegate> delegate;

@end

static const int kSegmentedControlOffset = 30;

@implementation AXContentSelectionToolbar
@synthesize segmentedControl;

-(instancetype)initWithDelegate:(id<AXContentSelectionToolbarDelegate>)delegate
{
    self = [super init];
    if(self)
    {
        self.delegate = delegate;
        
        self.backgroundColor = [UIColor venueRedColor];
        
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.bounds];
        self.layer.masksToBounds = NO;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
        self.layer.shadowOpacity = 0.5f;
        self.layer.shadowPath = shadowPath.CGPath;
        
        segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Events", @"Courses"]];
        segmentedControl.selectedSegmentIndex = AXContentModeEvents;
        [segmentedControl setTintColor:[UIColor whiteColor]];
        [segmentedControl addTarget:self action:@selector(controlValueDidChange:) forControlEvents:UIControlEventValueChanged];
        
        [self addSubview:segmentedControl];
        [segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(kSegmentedControlOffset);
            make.right.equalTo(self).offset(-kSegmentedControlOffset);
        }];
    }
    return self;
}

-(void)controlValueDidChange:(UISegmentedControl*)control
{
    [self.delegate contentModeDidChange:control.selectedSegmentIndex];
}

@end
