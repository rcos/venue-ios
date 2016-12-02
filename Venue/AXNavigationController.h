//
//  AXNavigationController.h
//  Venue
//
//  Created by Rocco Del Priore on 12/1/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AXNavigationControllerDelegate <NSObject>
- (void)didPushViewController:(UINavigationController *)navigationController;
- (void)didPopViewController:(UINavigationController *)navigationController;
@optional
- (void)didPresentViewController:(UIViewController *)viewController fromNavigationController:(UINavigationController *)navigationController;
@end

@interface AXNavigationController : UINavigationController
@property (nonatomic) id<AXNavigationControllerDelegate> customDelegate;
@end
