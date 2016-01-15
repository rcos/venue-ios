//
//  AXLoginViewController.m
//  Venue
//
//  Created by Jim Boulter on 1/15/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import "AXLoginViewController.h"
#import "AXAPI.h"

@interface AXLoginViewController () <UITextFieldDelegate>
@property UIImageView* backgroundImageView;
@property UIVisualEffectView* blurView;
@property UIView* textSurroundView;
@property UILabel* loginLabel;
@property UITextField* usernameTextField;
@property UITextField* passwordTextField;
@property UIButton* loginButton;

@property UIActivityIndicatorView* activityIndicatorView;
@end

@implementation AXLoginViewController
@synthesize backgroundImageView, blurView;
@synthesize textSurroundView, loginLabel, usernameTextField, passwordTextField, loginButton, activityIndicatorView;

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Firework"]];
        blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        
        textSurroundView = [[UIView alloc] init];
        loginLabel = [[UILabel alloc] init];
        usernameTextField = [[UITextField alloc] init];
        usernameTextField.delegate = self;
        passwordTextField = [[UITextField alloc] init];
        passwordTextField.delegate = self;
        
        loginButton = [[UIButton alloc] init];
        [loginButton addTarget:self action:@selector(loginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activityIndicatorView.backgroundColor = [UIColor venueRedColor];
        [activityIndicatorView setHidesWhenStopped:YES];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //configure views
    loginLabel.text = @"Enter your credentials:";
    loginLabel.font = [UIFont thinFont];
    loginLabel.textColor = [UIColor venueRedColor];
    
    usernameTextField.placeholder = @"username";
    usernameTextField.text = [[FXKeychain defaultKeychain] objectForKey:@"username"];
//    usernameTextField.font = ;
    usernameTextField.layer.cornerRadius = 2;
    usernameTextField.returnKeyType = UIReturnKeyNext;
//    usernameTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    usernameTextField.layer.borderWidth = 1;
    
    passwordTextField.secureTextEntry = YES;
    passwordTextField.placeholder = @"password";
//    passwordTextField.font = ;
    passwordTextField.layer.cornerRadius = 2;
    passwordTextField.returnKeyType = UIReturnKeyGo;
    
    textSurroundView.backgroundColor = [UIColor whiteColor];
    textSurroundView.layer.cornerRadius = 2;
    
    [loginButton setTitle:@"Login" forState:UIControlStateNormal];
    [loginButton setBackgroundColor:[UIColor venueRedColor]];
    [loginButton.titleLabel setTextColor:[UIColor whiteColor]];
    [loginButton.layer setCornerRadius:2];
    
    //setup view heirarchy
    [self.view addSubview:backgroundImageView];
    [backgroundImageView addSubview:blurView];
    [textSurroundView addSubview:usernameTextField];
    [textSurroundView addSubview:passwordTextField];
    [textSurroundView addSubview:loginLabel];
    [self.view addSubview:loginButton];
    [self.view addSubview:textSurroundView];
    [self.view addSubview:loginButton];
    [self.view addSubview:activityIndicatorView];
    
    //Set layout constraints
    UIEdgeInsets padding = UIEdgeInsetsMake(10, 10, -10, -10);
    
    [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [blurView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(backgroundImageView);
    }];
    
    [loginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textSurroundView.mas_left).with.offset(padding.left);
        make.right.equalTo(textSurroundView.mas_right).with.offset(padding.right);
        make.bottom.equalTo(usernameTextField.mas_top).with.offset(padding.bottom);
        make.top.equalTo(textSurroundView.mas_top).with.offset(padding.top);
    }];
    
    [usernameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textSurroundView.mas_left).with.offset(2*padding.left);
        make.right.equalTo(textSurroundView.mas_right).with.offset(2*padding.right);
        make.top.equalTo(loginLabel.mas_bottom).with.offset(padding.top);
        make.height.equalTo(@40);
    }];
    
    [passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textSurroundView.mas_left).with.offset(2*padding.left);
        make.right.equalTo(textSurroundView.mas_right).with.offset(2*padding.right);
        make.top.equalTo(usernameTextField.mas_bottom).with.offset(padding.top);
        make.height.equalTo(@40);
    }];
    
    [textSurroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(padding.left);
        make.right.equalTo(self.view.mas_right).with.offset(padding.right);
        make.centerY.equalTo(self.view.mas_centerY).with.offset(-self.view.bounds.size.height/4);
        make.bottom.equalTo(passwordTextField.mas_bottom).with.offset(2*padding.top);
    }];
    
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textSurroundView.mas_bottom).with.offset(padding.top);
        make.left.equalTo(self.view.mas_left).with.offset(padding.left);
        make.right.equalTo(self.view.mas_right).with.offset(padding.right);
        make.height.equalTo(@45);
    }];
    
    [activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(loginButton.mas_centerX);
        make.centerY.equalTo(loginButton.mas_centerY);
        make.height.equalTo(loginButton.mas_height);
        make.width.equalTo(@100);
    }];
    
    //Decide first responder
    if([usernameTextField.text isEqualToString:@""])
    {
        [usernameTextField becomeFirstResponder];
    }
    else [passwordTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

- (void)loginButtonPressed:(id)sender
{
    NSString* username = [AXExec sanitizeNSString:usernameTextField.text];
    NSString* password = [AXExec sanitizeNSString:passwordTextField.text];
    if(username.length > 1 && password.length > 1)
    {
        [activityIndicatorView startAnimating];
        loginButton.userInteractionEnabled = NO;
        [AXAPI loginWithUsername:username password:password block:^(BOOL succeeded){
            [activityIndicatorView stopAnimating];
            [[AXExec appDel] setLoggedIn];
        }];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == usernameTextField)
    {
        [passwordTextField becomeFirstResponder];
    }
    else
    {
        [self loginButtonPressed:loginButton];
    }
    return NO;
}

#pragma mark - Misc

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end