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

@implementation AXContentSelectionToolbar
@synthesize segmentedControl;

-(instancetype)initWithDelegate:(id<AXContentSelectionToolbarDelegate>)delegate
{
    self = [super init];
    if(self)
    {
        self.delegate = delegate;
        
        segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Events", @"Courses"]];
        segmentedControl.selectedSegmentIndex = AXContentModeEvents;
        [segmentedControl setTintColor:[UIColor venueRedColor]];
        [segmentedControl addTarget:self action:@selector(controlValueDidChange:) forControlEvents:UIControlEventValueChanged];
        
        [self addSubview:segmentedControl];
        [segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
        }];
    }
    return self;
}

-(void)controlValueDidChange:(UISegmentedControl*)control
{
    [self.delegate contentModeDidChange:control.selectedSegmentIndex];
}

@end
