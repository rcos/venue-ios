//
//  AXEventViewController.m
//  Venue
//
//  Created by Jim Boulter on 1/14/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import "AXEventViewController.h"

@interface AXEventViewController ()

@property UIButton* navButton;

@end

@implementation AXEventViewController
@synthesize navButton;

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        navButton = [[UIButton alloc] init];
        [navButton setImage:[UIImage imageNamed:@"NavIcon"] forState:UIControlStateNormal];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem* barButton = [[UIBarButtonItem alloc] initWithTitle:@"Check In" style:UIBarButtonItemStylePlain target:self action:@selector(checkIn)];
    [self.navigationItem setRightBarButtonItem:barButton];
    
    [self.imageView addSubview:navButton];
    
    UIEdgeInsets padding = UIEdgeInsetsMake(10, 10, -10, -10);
    
    [navButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.blurView.mas_bottom);
        make.right.equalTo(self.view.mas_right).with.offset(padding.right);
        make.bottom.equalTo(self.tableView.mas_top);
    }];
}

#pragma mark - Check In

-(void)checkIn
{
    DBCameraViewController *cameraController = [DBCameraViewController initWithDelegate:self];
    [cameraController setUseCameraSegue:NO];
    
    DBCameraContainerViewController *container = [[DBCameraContainerViewController alloc] initWithDelegate:self cameraSettingsBlock:^(DBCameraView *cameraView, id container) {
        [cameraView.photoLibraryButton setHidden:YES];
    }];
    [container setCameraViewController:cameraController];
    
    [container setFullScreenMode];
    [container setTintColor:[UIColor venueRedColor]];
    
    UINavigationController* cameraVC = [[UINavigationController alloc] initWithRootViewController:container];
    [cameraVC setNavigationBarHidden:YES];
    [self presentViewController:cameraVC animated:YES completion:nil];
}

#pragma mark - DBCameraViewControllerDelegate

-(void)camera:(id)cameraViewController didFinishWithImage:(UIImage *)image withMetadata:(NSDictionary *)metadata
{
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)dismissCamera:(id)cameraViewController
{
    [cameraViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==0)return 0.00001f;
    return 13.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 300;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell* cell =  [tableView dequeueReusableCellWithIdentifier:@"wow"];
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc] init];
    }
    
    return cell;
}

@end
