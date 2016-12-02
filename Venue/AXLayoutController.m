//
//  AXLayoutController.m
//  Venue
//
//  Created by Rocco Del Priore on 12/2/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import "AXNavigationBar.h"
#import "AXLayoutController.h"
#import "AXNavigationController.h"

@interface AXLayoutController ()
@property (nonatomic) AXNavigationBar *navigationBar;
@end

@implementation AXLayoutController {
    AXNavigationController *navigationController;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        navigationController = [[AXNavigationController alloc] init];
        self.navigationBar   = [[AXNavigationBar alloc] init];
        
        [navigationController setNavigationBarHidden:YES];
        [navigationController setCustomDelegate:self.navigationBar];
        [self.navigationBar.backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubviews:@[navigationController.view, self.navigationBar]];
        [self.navigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.view);
            make.height.equalTo(@113);
        }];
        [navigationController.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.navigationBar.mas_bottom);
        }];
    }
    return self;
}

- (void)setRootViewController:(UIViewController *)rootViewController {
    [navigationController setViewControllers:@[rootViewController]];
    if ([rootViewController conformsToProtocol:@protocol(AXNavigationBarDelegate)]) {
        [self.navigationBar setDelegate:(id<AXNavigationBarDelegate>)rootViewController];
    }
}

- (void)pushViewController:(UIViewController *)viewController {
    [navigationController pushViewController:viewController animated:YES];
    if ([viewController conformsToProtocol:@protocol(AXNavigationBarDelegate)]) {
        [self.navigationBar setDelegate:(id<AXNavigationBarDelegate>)viewController];
    }
}

- (void)popViewController {
    [navigationController popViewControllerAnimated:YES];
    if ([navigationController.viewControllers.lastObject conformsToProtocol:@protocol(AXNavigationBarDelegate)]) {
        [self.navigationBar setDelegate:(id<AXNavigationBarDelegate>)navigationController.viewControllers.lastObject];
    }
}

@end
