//
//  UIView+Venue.m
//  Venue
//
//  Created by Rocco Del Priore on 12/1/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import "UIView+Venue.h"

@implementation UIView (Venue)

- (void)addSubviews:(NSArray <UIView *> *)views {
    for (UIView *view in views) {
        [self addSubview:view];
    }
}

@end

@implementation UIStackView (Venue)

- (void)addArrangedSubviews:(NSArray <UIView *> *)views {
    for (UIView *view in views) {
        [self addArrangedSubview:view];
    }
}

@end
