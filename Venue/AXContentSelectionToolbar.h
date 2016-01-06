//
//  AXContentSelectionToolbar.h
//  Venue
//
//  Created by Jim Boulter on 1/5/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"

typedef NS_ENUM(NSInteger, AXContentMode){
    AXContentModeEvents,
    AXContentModeCourses,
};

@protocol AXContentSelectionToolbarDelegate <NSObject>

-(void)contentModeDidChange:(AXContentMode)mode;

@end

@interface AXContentSelectionToolbar : UIView

-(instancetype)initWithDelegate:(id<AXContentSelectionToolbarDelegate>)delegate;

@end
