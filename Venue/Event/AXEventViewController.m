//
//  AXEventViewController.m
//  Venue
//
//  Created by Jim Boulter on 1/14/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import "AXEventViewController.h"
#import "AXAPI.h"
#import "AXSubmissionTableViewCell.h"

@interface AXEventViewController ()

@property UIButton* navButton;
@property NSArray* submissions;
@property NSString* eventId;

@property MKMapView* mapView;
@property MKPointAnnotation* anno;
@property CLLocationCoordinate2D coords;

@property UIProgressView* progressView;
@property UILabel* emptyLabel;

@end

@implementation AXEventViewController
@synthesize navButton, mapView, coords, anno, eventId, progressView, emptyLabel;

-(instancetype)initWithEvent:(NSDictionary*)event
{
    self = [super init];
    if(self)
    {
        self.title = @"Venue_x";
        eventId = event[@"_id"];
        
        mapView = [[MKMapView alloc] init];

        CLLocationDegrees lat = [event[@"info"][@"location"][@"geo"][@"coordinates"][1] doubleValue];
        CLLocationDegrees lon = [event[@"info"][@"location"][@"geo"][@"coordinates"][0] doubleValue];
        coords = CLLocationCoordinate2DMake(lat, lon);
        
        anno = [[MKPointAnnotation alloc] init];
        anno.coordinate = coords;
        anno.title = event[@"info"][@"title"];
        
        progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        progressView.backgroundColor = [UIColor lightGrayColor];
        progressView.tintColor = [UIColor venueRedColor];
        
        emptyLabel = [[UILabel alloc] init];
        [emptyLabel setFont:[UIFont italicSystemFontOfSize:17]];
        [emptyLabel setTextColor:[UIColor lightGrayColor]];
        [emptyLabel setText:@"No submissions yet"];
        [emptyLabel setTextAlignment:NSTextAlignmentCenter];
        
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
        
        [self fetchSubmissions];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem* barButton = [[UIBarButtonItem alloc] initWithTitle:@"Check In" style:UIBarButtonItemStylePlain target:self action:@selector(checkIn)];
    [self.navigationItem setRightBarButtonItem:barButton];
    
    mapView.showsUserLocation = YES;
    [mapView addAnnotation:anno];
    [mapView setRegion:MKCoordinateRegionMake(coords, MKCoordinateSpanMake(.1, .1)) animated:YES];
    
    [self.imageView addSubview:mapView];
    [self.imageView bringSubviewToFront:self.blurView];
    [self.imageView addSubview:navButton];
    [self.view addSubview:progressView];
    [self.tableView addSubview:emptyLabel];
    
    UIEdgeInsets padding = UIEdgeInsetsMake(10, 10, -10, -10);
    
    [mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.imageView);
    }];
    
    [progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@1);
    }];
    
    [emptyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.tableView.mas_centerX);
        make.centerY.equalTo(self.tableView.mas_centerY);
    }];
    
    [navButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.blurView.mas_bottom);
        make.right.equalTo(self.view.mas_right).with.offset(padding.right);
        make.bottom.equalTo(self.tableView.mas_top);
    }];
}

#pragma mark - Check In

-(void)fetchSubmissions
{
    [[AXAPI API] getSubmissionsWithEventId:eventId progressView:progressView completion:^(NSArray *submissions) {
        self.submissions = submissions;
        emptyLabel.hidden = self.submissions.count > 0;
        [self.tableView reloadData];
    }];
}

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
    [[AXAPI API] verifySubmissionForEventId:eventId WithImage:image completion:^(BOOL success) {
        [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
        [self fetchSubmissions];
    }];
}

-(void)dismissCamera:(id)cameraViewController
{
    [cameraViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDelegate

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if(section==0)return 0.00001f;
//    return 13.0f;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 0;
//}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    emptyLabel.hidden = (self.submissions.count != 0);
    return self.submissions.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 300;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AXSubmissionTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:[AXSubmissionTableViewCell reuseIdentifier]];
    
    if(!cell)
    {
        cell = [[AXSubmissionTableViewCell alloc] initWithSubmission:self.submissions[indexPath.row]];
    }
    
    return cell;
}

@end