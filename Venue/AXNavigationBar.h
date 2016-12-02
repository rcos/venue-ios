//
//  AXNavigationBar.h
//  Venue
//
//  Created by Jim Boulter on 11/27/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AXContentMode){
    AXContentModeEvents,
    AXContentModeCourses,
};

@protocol AXNavigationBarDelegate <NSObject>
-(void)contentModeDidChange:(AXContentMode)mode;
@end

@interface AXNavigationBar : UINavigationBar
@property (strong, nonatomic) id<AXNavigationBarDelegate> customDelegate;
@property (strong, nonatomic) UILabel* topLabel;
@property (strong, nonatomic) UILabel* midLabel;
@property (strong, nonatomic) UILabel* bottomLabel;
@end
