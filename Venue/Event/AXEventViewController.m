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

@interface AXEventViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property UIButton* navButton;
@property NSArray* submissions;
@property NSString* eventId;

@property MKMapView* mapView;
@property MKPointAnnotation* anno;
@property CLLocationCoordinate2D coords;


@end

@implementation AXEventViewController
@synthesize navButton, mapView, coords, anno, eventId;

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
        
        [self.emptyLabel setText:@"No submissions yet"];
        
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
        [self checkIfSubmittedBefore];
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
    
    [self.view insertSubview:mapView belowSubview:self.detailContainerView];
    [self.view insertSubview:navButton aboveSubview:mapView];
    
    UIEdgeInsets padding = UIEdgeInsetsMake(10, 10, -10, -10);
    
    [mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.imageView);
    }];
    
    [navButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.blurView.mas_bottom);
        make.right.equalTo(self.view.mas_right).with.offset(padding.right);
        make.bottom.equalTo(self.tableView.mas_top).with.offset(padding.bottom);
    }];
}

#pragma mark - Check In

-(void)checkIfSubmittedBefore
{
    [[AXAPI API] getMySubmissionsWithEventId:eventId progressView:nil completion:^(NSArray *submissions) {
        if(submissions.count == 0)
        {
            //No submissions from us.
        }
        else
        {
            //We've submitted before.
        }
    }];
}

-(void)fetchSubmissions
{
    [[AXAPI API] getSubmissionsWithEventId:eventId progressView:self.progressView completion:^(NSArray *submissions) {
        self.submissions = submissions;
        self.emptyLabel.hidden = self.submissions.count > 0;
        [self.tableView reloadData];
    }];
}

-(void)checkIn
{
    UIImagePickerController *camera = [[UIImagePickerController alloc] init];
    camera.sourceType = ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera] == YES) ? UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypePhotoLibrary;
    camera.delegate = self;
    [self presentViewController:camera animated:YES completion:nil];
}

#pragma mark - UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    
    NSData *imageData = UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerOriginalImage"], 0.05f);
    UIImage *image = [UIImage imageWithData:imageData];
    
    [[AXAPI API] verifySubmissionForEventId:eventId WithImage:image completion:^(BOOL success) {
        [self fetchSubmissions];
    }];
}

#pragma mark - UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.emptyLabel.hidden = (self.submissions.count != 0);
    return self.submissions.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 300;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AXSubmissionTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:[AXSubmissionTableViewCell jim_reuseIdentifier]];
    
    if(!cell)
    {
        cell = [[AXSubmissionTableViewCell alloc] initWithSubmission:self.submissions[indexPath.row]];
    }
    
    return cell;
}

@end
