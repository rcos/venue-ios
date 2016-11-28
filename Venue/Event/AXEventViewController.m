//
//  AXEventViewController.m
//  Venue
//
//  Created by Jim Boulter on 1/14/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import <Photos/Photos.h>

#import "AXEventViewController.h"
#import "AXAPI.h"
#import "AXSubmissionTableViewCell.h"
#import "SCLAlertView.h"

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
        [navButton addTarget:self action:@selector(navButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
        [self fetchSubmissions];
        [self checkIfSubmittedBefore];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem* barButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"CheckinFull"] style:UIBarButtonItemStylePlain target:self action:@selector(checkIn)];
    [self.navigationItem setRightBarButtonItem:barButton];
    
    mapView.showsUserLocation = YES;
    [mapView addAnnotation:anno];
    [mapView setRegion:MKCoordinateRegionMake(event.coords, MKCoordinateSpanMake(.1, .1)) animated:YES];
    
    [self.view insertSubview:mapView atIndex:0];
    [self.view insertSubview:navButton aboveSubview:self.detailContainerView];
    
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

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self loadNavBar];
}

-(void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self clearNavBar];
}

#pragma mark - Action

-(void)refresh
{
    [self fetchSubmissions];
}

-(void)loadNavBar {
	AXNavigationBar* navBar = (AXNavigationBar*)self.navigationController.navigationBar;
	navBar.topLabel.text = event.name;
	
	NSDateFormatter* df = [[NSDateFormatter alloc] init];
	[df setDateStyle:NSDateFormatterMediumStyle];
	NSString* date = [df stringFromDate:event.startDate];
	navBar.midLabel.text = [NSString stringWithFormat:@"%@", date];
	
	navBar.bottomLabel.text = [NSString stringWithFormat:@"%@ - %@", event.startTime, event.endTime];

}

-(void)clearNavBar {
	AXNavigationBar* navBar = (AXNavigationBar*)self.navigationController.navigationBar;
	navBar.topLabel.text = nil;
	
	navBar.midLabel.text = nil;
	
	navBar.bottomLabel.text = nil;
}

#pragma mark - Navigation

- (void)navButtonPressed
{
    NSString* link = [NSString stringWithFormat:@"http://maps.apple.com/?daddr=%@&dirflg=d", [event.address stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:link]];
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
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView transitionWithView:self.view duration:.3 options:0 animations:^{
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
            } completion:^(BOOL finished) {
                [self.refreshControl endRefreshing];
            }];
        });
    }];
}

-(void)checkIn
{
    UIImagePickerController *camera = [[UIImagePickerController alloc] init];
    camera.sourceType = ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera] == YES) ? UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypePhotoLibrary;
    camera.delegate = self;
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        switch (status) {
            case PHAuthorizationStatusAuthorized:
                [self presentViewController:camera animated:YES completion:nil];
                break;
                
            default:
                break;
        }
    }];}

#pragma mark - UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	[self.presentedViewController dismissViewControllerAnimated:YES completion:^{
		UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
		[self attemptSubmissionWithImage:image];
	}];
}

-(void)attemptSubmissionWithImage:(UIImage*)image
{
	SCLAlertViewBuilder *builder = [SCLAlertViewBuilder new];
	SCLAlertViewShowBuilder *showBuilder = [SCLAlertViewShowBuilder new]
	.style(Waiting)
	.title(@"Verifying Submission")
	.subTitle(@"We're checking your attendance, please wait.")
	.duration(0);
	[showBuilder showAlertView:builder.alertView onViewController:self];
	
	NSLog(@"Start submission");
	[[AXAPI API] verifySubmissionForEventId:event.eventId withImage:image withProgressView:nil completion:^(BOOL success, NSError* error) {
		
		dispatch_async(dispatch_get_main_queue(), ^{
			[builder.alertView hideView];
		});
		
		if(success)
		{
			NSLog(@"Finish successful submission");
			dispatch_async(dispatch_get_main_queue(), ^{
				SCLAlertViewBuilder *successBuilder = [SCLAlertViewBuilder new];
				SCLAlertViewShowBuilder *successShowBuilder = [SCLAlertViewShowBuilder new]
				.style(Success)
				.title(@"Submission Verified");
				successBuilder.addButtonWithActionBlock(@"Close", ^{
					[self fetchSubmissions];
				});
				[successShowBuilder showAlertView:successBuilder.alertView onViewController:self];
			});
		}
		else
		{
			SCLAlertViewBuilder *failureBuilder = [SCLAlertViewBuilder new];
			SCLAlertViewShowBuilder *failureShowBuilder = [SCLAlertViewShowBuilder new]
			.style(Error)
			.title(@"Submission Failed")
            .subTitle([error description])
			.closeButtonTitle(@"Close");
			failureBuilder.addButtonWithActionBlock(@"Retry", ^{
				dispatch_async(dispatch_get_main_queue(), ^{
					[self attemptSubmissionWithImage:image];
				});
			});
			
			dispatch_async(dispatch_get_main_queue(), ^{
				[failureShowBuilder showAlertView:failureBuilder.alertView onViewController:self];
			});
		}
		
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
    
    AXSubmissionTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:[AXSubmissionTableViewCell reuseIdentifier]];
    
    if(!cell)
    {
        cell = [[AXSubmissionTableViewCell alloc] initWithSubmission:self.submissions[indexPath.row]];
    }
    
    return cell;
}

@end
