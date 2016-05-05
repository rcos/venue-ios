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
@property AXEvent* event;

@property MKMapView* mapView;
@property MKPointAnnotation* anno;


@end

@implementation AXEventViewController
@synthesize navButton, mapView, anno, event;

-(instancetype)initWithEvent:(AXEvent*)_event
{
    self = [super init];
    if(self)
    {
        self.title = @"Venue_x";
        event = _event;
        
        mapView = [[MKMapView alloc] init];
        
        anno = [[MKPointAnnotation alloc] init];
        anno.coordinate = event.coords;
        anno.title = event.name;
        
        [self.emptyLabel setText:@"No submissions yet"];
        
        [self.detailTitleLabel setText:event.name];
        [self.detailDescriptionTextView setText:event.eventDescription];
        
        [self.detailSubtitleLabel setNumberOfLines:2];
        [self.detailSubtitleLabel setText:[NSString stringWithFormat:@"%@\n-%@", event.startTime, event.endTime]];

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
    [mapView setRegion:MKCoordinateRegionMake(event.coords, MKCoordinateSpanMake(.1, .1)) animated:YES];
    
    [self.view insertSubview:mapView belowSubview:self.detailContainerView];
    [self.view insertSubview:navButton aboveSubview:self.tapButton];
    
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
    [[AXAPI API] getMySubmissionsWithEventId:event.eventId progressView:nil completion:^(NSArray *submissions) {
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
    [[AXAPI API] getSubmissionsWithEventId:event.eventId progressView:self.progressView completion:^(NSArray *submissions) {
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
    
    [[AXAPI API] verifySubmissionForEventId:event.eventId WithImage:image completion:^(BOOL success) {
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
