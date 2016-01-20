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

-(instancetype)initWithEvent:(NSDictionary*)event
{
    self = [super init];
    if(self)
    {
        [self.detailTitleLabel setText:event[@"info"][@"title"]];
        [self.detailDescriptionTextView setText:event[@"info"][@"description"]];
        
        NSArray* times = event[@"info"][@"times"];
        if(times.count > 0)
        {
            NSDictionary* time = [times firstObject];
            NSString* start = time[@"start"];
            NSString* end = time[@"end"];
            
            NSDateFormatter* df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSz"];
            
            NSDate* startDate = [df dateFromString:start];
            NSDate* endDate = [df dateFromString:end];
            
            [df setDateFormat:@"h:mma"];
            NSString* startTime = [df stringFromDate:startDate];
            NSString* endTime = [df stringFromDate:endDate];
            
            [self.detailSubtitleLabel setNumberOfLines:2];
            [self.detailSubtitleLabel setText:[NSString stringWithFormat:@"%@\n-%@", startTime, endTime]];
        }

        self.tableTitleLabel.attributedText = [[NSAttributedString alloc] initWithString:@"Photos"
                                                                         attributes:@{
                                                                                      NSStrokeColorAttributeName : [UIColor blackColor], NSForegroundColorAttributeName : [UIColor whiteColor], NSStrokeWidthAttributeName : @-1.0 }];
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
