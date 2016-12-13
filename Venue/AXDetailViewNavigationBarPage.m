//
//  AXDetailViewNavigationBarPage.m
//  Venue
//
//  Created by Rocco Del Priore on 12/2/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import "AXDetailViewNavigationBarPage.h"
#import "AXCourse.h"
#import "AXEvent.h"

@implementation AXDetailViewNavigationBarPage {
    UILabel *top;
    UILabel *middle;
    UILabel *bottom;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIStackView *stackView = [[UIStackView alloc] initWithFrame:CGRectZero];
        
        top    = [[UILabel alloc] initWithFrame:CGRectZero];
        middle = [[UILabel alloc] initWithFrame:CGRectZero];
        bottom = [[UILabel alloc] initWithFrame:CGRectZero];
        
        [stackView setAxis:UILayoutConstraintAxisVertical];
        [stackView addArrangedSubviews:@[top, middle, bottom]];
        for (UILabel *label in stackView.arrangedSubviews) {
            [label setTextColor:[UIColor secondaryColor]];
            [label setTextAlignment:NSTextAlignmentCenter];
            [label setNumberOfLines:1];
        }
        [top setFont:[UIFont boldFontOfSize:18]];
        [top setAdjustsFontSizeToFitWidth:YES];
        [top setNumberOfLines:2];
        [top setFont:[UIFont boldFontOfSize:14]];
        [bottom setFont:[UIFont boldFontOfSize:14]];
        
        [self addSubview:stackView];
        [stackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(10);
            make.bottom.equalTo(self).offset(-10);
            make.left.equalTo(self).offset(30);
            make.right.equalTo(self).offset(-30);
        }];
    }
    return self;
}

- (instancetype)init {
    self = [self init];
    return self;
}

- (void)setEvent:(AXEvent *)event {
    top.text = event.name;
    
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateStyle:NSDateFormatterMediumStyle];
    NSString* date = [df stringFromDate:event.startDate];
    middle.text = [NSString stringWithFormat:@"%@", date];
    
    bottom.text = [NSString stringWithFormat:@"%@ - %@", event.startTime, event.endTime];
}

- (void)setCourse:(AXCourse *)course {
    top.text    = course.name;
    middle.text = [NSString stringWithFormat:@"%@-%@", course.department, course.courseNumber];
    
    //TODO: Make this real
    if (course.sections.count) {
		long first = [course.sections.firstObject integerValue];
        bottom.text = [NSString stringWithFormat:@"Section %li", first];
    }
    else {
        bottom.text = @"";
    }
}

@end
