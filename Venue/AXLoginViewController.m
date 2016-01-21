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
@property UILabel* titleLabel;
@property UIView* textSurroundView;
@property UILabel* loginLabel;
@property UITextField* emailTextField;
@property UITextField* passwordTextField;
@property UIButton* loginButton;

@property UIButton* registerButton;

@property UIActivityIndicatorView* activityIndicatorView;
@end

@implementation AXLoginViewController
@synthesize backgroundImageView, blurView;
@synthesize titleLabel, textSurroundView, loginLabel, emailTextField, passwordTextField, loginButton, registerButton, activityIndicatorView;

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Firework"]];
        blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        
        titleLabel = [[UILabel alloc] init];
        textSurroundView = [[UIView alloc] init];
        loginLabel = [[UILabel alloc] init];
        emailTextField = [[UITextField alloc] init];
        emailTextField.delegate = self;
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
    titleLabel.text = @"Venue";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:24];
    
    loginLabel.text = @"Enter your credentials:";
    loginLabel.font = [UIFont thinFont];
    loginLabel.textColor = [UIColor venueRedColor];
    
    emailTextField.placeholder = @"email";
    emailTextField.text = [[FXKeychain defaultKeychain] objectForKey:kAPIEmail];
//    usernameTextField.font = ;
    emailTextField.layer.cornerRadius = 2;
    emailTextField.returnKeyType = UIReturnKeyNext;
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
    
    registerButton = [[UIButton alloc] init];
    [registerButton setTitle:@"  I need an account  " forState:UIControlStateNormal];
    [registerButton.titleLabel setFont:[UIFont thinFont]];
    [registerButton setBackgroundColor:[UIColor colorWithWhite:100/255.0 alpha:.25]];
    [registerButton.layer setCornerRadius:4];
    
    [registerButton addTarget:self action:@selector(register:) forControlEvents:UIControlEventTouchUpInside];
    
    //setup view heirarchy
    [self.view addSubview:backgroundImageView];
    [backgroundImageView addSubview:blurView];
    [blurView addSubview:titleLabel];
    [textSurroundView addSubview:emailTextField];
    [textSurroundView addSubview:passwordTextField];
    [textSurroundView addSubview:loginLabel];
    [self.view addSubview:loginButton];
    [self.view addSubview:textSurroundView];
    [self.view addSubview:loginButton];
    [self.view addSubview:activityIndicatorView];
    [self.view addSubview:registerButton];
    
    //Set layout constraints
    UIEdgeInsets padding = UIEdgeInsetsMake(10, 10, -10, -10);
    
    [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [blurView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(backgroundImageView);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.blurView.mas_centerX);
        make.top.equalTo(self.blurView.mas_top).with.offset(2*padding.top);
        make.bottom.equalTo(self.textSurroundView.mas_top).with.offset(padding.bottom);
    }];
    
    [loginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textSurroundView.mas_left).with.offset(padding.left);
        make.right.equalTo(textSurroundView.mas_right).with.offset(padding.right);
        make.bottom.equalTo(emailTextField.mas_top).with.offset(padding.bottom);
        make.top.equalTo(textSurroundView.mas_top).with.offset(padding.top);
    }];
    
    [emailTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textSurroundView.mas_left).with.offset(2*padding.left);
        make.right.equalTo(textSurroundView.mas_right).with.offset(2*padding.right);
        make.top.equalTo(loginLabel.mas_bottom).with.offset(padding.top);
        make.height.equalTo(@40);
    }];
    
    [passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textSurroundView.mas_left).with.offset(2*padding.left);
        make.right.equalTo(textSurroundView.mas_right).with.offset(2*padding.right);
        make.top.equalTo(emailTextField.mas_bottom).with.offset(padding.top);
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
    
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(loginButton.mas_bottom).with.offset(padding.top);
        make.height.equalTo(@20);
    }];
    
    [activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(loginButton.mas_centerX);
        make.centerY.equalTo(loginButton.mas_centerY);
        make.height.equalTo(loginButton.mas_height);
        make.width.equalTo(@100);
    }];
    
    //Decide first responder
    if([emailTextField.text isEqualToString:@""])
    {
        [emailTextField becomeFirstResponder];
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
    NSString* email = [AXExec sanitizeNSString:emailTextField.text];
    NSString* password = [AXExec sanitizeNSString:passwordTextField.text];
    if(email.length > 1 && password.length > 1)
    {
        [activityIndicatorView startAnimating];
        loginButton.userInteractionEnabled = NO;
        [[AXAPI API] loginWithEmail:email password:password block:^(BOOL succeeded){
            if(succeeded)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [activityIndicatorView stopAnimating];
                    [[AXExec appDel] setLoggedIn];
                });
            }
        }];
    }
}

- (void)register:(id)sender
{
    //present loginvc with all necessary fields for registration
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.venue.com/register"]];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == emailTextField)
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