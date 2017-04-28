//
//  AXWebLoginViewController.m
//  Venue
//
//  Created by Jim Boulter on 8/6/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import "AXWebLoginViewController.h"

@implementation AXWebLoginViewController
@synthesize webView, activityView;

-(instancetype)init {
    self = super.self;
    if(self) {
        webView = [[UIWebView alloc] init];
        activityView = [[UIActivityIndicatorView alloc] init];
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor rpiRedColor];
    
    webView.backgroundColor = [UIColor rpiRedColor];
    webView.delegate = self;
    
    activityView.hidesWhenStopped = true;
    
    [self.view addSubview:webView];
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset([[UIApplication sharedApplication] statusBarFrame].size.height);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    [self.view addSubview:activityView];
    [activityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(@50);
        make.height.equalTo(@50);
    }];
    
    [self startLogin];
}

-(void)startLogin {
    NSURLRequest* request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://venue.cs.rpi.edu/auth/cas?mobile=true"]];
    [webView loadRequest:request];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    AXLog(@"URL: %@", request.URL);
    
    if([request.URL.absoluteString containsString:@"jsessionid="] || [request.URL.absoluteString containsString:@"ticket="]) {
        [activityView startAnimating];
        [[AXAPI API] loginWithCASRequest:request block:^(BOOL success) {
            [activityView stopAnimating];
            if(success) {
                [[AXExec appDel] setLoggedIn];
            } else {
                //uh oh failure
                UIAlertController* avc = [UIAlertController alertControllerWithTitle:@"Login Error" message:@"We've had some issue with login.  Please try again." preferredStyle:UIAlertControllerStyleAlert];
                [avc addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self startLogin];
                }]];
            }
        }];
        return false;
    }
    
//    if([request.URL.absoluteString containsString:@"https://venue.cs.rpi.edu"]) {
//        NSHTTPCookie* cookie;
//        NSHTTPCookieStorage* cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//        NSArray* cookies = [cookieJar cookies];
//        //[cookieJar cookiesForURL:[NSURL URLWithString:@"venue.cs.rpi.edu"]];
//        for(cookie in cookies) {
//            if([cookie.name isEqualToString:@"connect.sid" ]) {
//                [[AXAPI API].requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", cookie.value] forHTTPHeaderField:@"Authorization"];
//                [[AXExec appDel] setLoggedIn];
//            }
//        }
//    }
    
    return true;
}
@end
