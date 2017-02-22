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
#import "AXTextTableViewCell.h"
#import "AXMapTableViewCell.h"
#import "AXImageTableViewCell.h"
#import "AXIconTableViewCell.h"
#import "SCLAlertView.h"
#import "NSString+Venue.h"
#import "AXHeaderFooterView.h"

@interface AXEventViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property NSArray* submissions;
@property AXEvent* event;


@end

@implementation AXEventViewController
@synthesize event;

-(instancetype)initWithEvent:(AXEvent*)_event
{
	event = _event;
    self = [super init];
    if(self)
    {
//        [self checkIfSubmittedBefore];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem* barButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"CheckinFull"] style:UIBarButtonItemStylePlain target:self action:@selector(checkIn)];
    [self.navigationItem setRightBarButtonItem:barButton];
}

#pragma mark - Action

-(void)refresh
{
    [self fetchSubmissions];
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

- (void)fetchSubmissions {
    [[AXAPI API] getSubmissionsWithEventId:event.eventId progressView:self.progressView completion:^(NSArray *submissions) {
        self.submissions = submissions;
//        self.emptyLabel.hidden = self.submissions.count > 0;
		
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView transitionWithView:self.view duration:.3 options:0 animations:^{
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationFade];
            } completion:^(BOOL finished) {
                [self.refreshControl endRefreshing];
            }];
        });
    }];
}

- (void)checkIn {
    UIImagePickerController *camera = [[UIImagePickerController alloc] init];
    camera.sourceType = ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera] == YES) ? UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypePhotoLibrary;
    camera.delegate = self;
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        switch (status) {
            case PHAuthorizationStatusAuthorized:
                [self presentViewController:camera animated:YES completion:nil];
                break;
            default:
				[self presentErrorDialogue];
                break;
        }
    }];
}

- (void)presentErrorDialogue {
	UIAlertController *altc = [[UIAlertController alloc] init];
	[altc setTitle:@"Unauthorized :("];
	[altc setMessage:@"I'm unauthorized to access your photo or camera. Please change this in Settings."];
	[altc addAction:[UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		[altc dismissViewControllerAnimated:YES completion:NULL];
	}]];
	
	[self presentViewController:altc animated:YES completion:NULL];
}

#pragma mark - UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	[self.presentedViewController dismissViewControllerAnimated:YES completion:^{
		UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
		[self attemptSubmissionWithImage:image];
	}];
}

-(void)attemptSubmissionWithImage:(UIImage *)image {
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
			//.subTitle([error description])
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
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	switch (section) {
		// description
		case 0:
			return 2;
		// location
		case 1:
			return 2;
		// submit
		case 2:
			return 1 + !event.submissionInstructions.isEmpty;
		// submission history
		case 3:
			return _submissions.count;
		default:
			return 0;
	}
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	switch (section) {
			// description
		case 0:
			return nil;
			// location
		case 1:
			return @"Location";
			// submit
		case 2:
			return @"Submission";
			// submission history
		case 3:
			return @"History";
		default:
			return nil;
	}

}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	if(section == 0) {
		return nil;
	}
	AXHeaderFooterView* view = [[AXHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
	
	switch (section) {
		case 1:
			[view setTitle:@"location".uppercaseString];
			break;
			// submit
		case 2:
			[view setTitle:@"submission".uppercaseString];
			break;
			// submission history
		case 3:
            if ([self tableView:tableView numberOfRowsInSection:section] == 0) {
                [view setTitle:@"no history".uppercaseString];
            }
            else {
                [view setTitle:@"history".uppercaseString];
			}
			break;
		default:
			break;
	}
	
	return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if(indexPath.section == 1) {
		[self navButtonPressed];
	} else if(indexPath.section == 2 && indexPath.row == 0) {
		[self checkIn];
	}
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITableViewCell* outCell;
	AXSubmissionTableViewCell* subCell;
	AXImageTableViewCell* imgCell;
	AXTextTableViewCell* textCell;
	AXMapTableViewCell* mapCell;
	AXIconTableViewCell* iconCell;
	
	switch (indexPath.section) {
		// Description
		case 0:
			switch (indexPath.row) {
				case 0:
					imgCell = [tableView dequeueReusableCellWithIdentifier:[AXImageTableViewCell reuseIdentifier]];
					if(!imgCell) {
						imgCell = [[AXImageTableViewCell alloc] init];
					}
					[imgCell configureWithImageUrl:event.imageUrl];
					outCell = imgCell;
					break;
				case 1:
					textCell = [tableView dequeueReusableCellWithIdentifier:[AXTextTableViewCell reuseIdentifier]];
					if(!textCell) {
						textCell = [[AXTextTableViewCell alloc] init];
					}
					[textCell configureWithText:event.eventDescription divider:NO];
					outCell = textCell;
					break;
				default:
					outCell = [[AXTableViewCell alloc] init];
					break;
			}
			break;
			
		// Location
		case 1:
			switch (indexPath.row) {
				case 0:
					mapCell = [tableView dequeueReusableCellWithIdentifier:[AXMapTableViewCell reuseIdentifier]];
					if(!mapCell) {
						mapCell = [[AXMapTableViewCell alloc] init];
					}
					[mapCell configureWithEvent:event];
					outCell = mapCell;
					break;
				case 1:
					iconCell = [tableView dequeueReusableCellWithIdentifier:[AXIconTableViewCell reuseIdentifier]];
					if(!iconCell) {
						iconCell = [[AXIconTableViewCell alloc] init];
					}
					[iconCell configureWithText:event.address mode:AXAddressMode];
					outCell = iconCell;
					break;
				default:
					break;
			}
            [outCell setSelectionStyle:UITableViewCellSelectionStyleNone];
			break;
			
		// Submit
		case 2:
			switch (indexPath.row) {
				case 0:
					iconCell = [tableView dequeueReusableCellWithIdentifier:[AXIconTableViewCell reuseIdentifier]];
					if(!iconCell) {
						iconCell = [[AXIconTableViewCell alloc] init];
					}
					[iconCell configureWithText:@"Add new submission" mode:AXSubmissionMode];
					outCell = iconCell;
					break;
				case 1:
					textCell = [tableView dequeueReusableCellWithIdentifier:[AXTextTableViewCell reuseIdentifier]];
					if(!textCell) {
						textCell = [[AXTextTableViewCell alloc] init];
					}
					[textCell configureWithText:event.submissionInstructions divider:YES];
					outCell = textCell;
					break;
				default:
					break;
			}
			break;
			
		// Submissions History
		case 3:
			subCell = [tableView dequeueReusableCellWithIdentifier:[AXSubmissionTableViewCell reuseIdentifier]];
			if(!subCell)
			{
				subCell = [[AXSubmissionTableViewCell alloc] initWithSubmission:self.submissions[indexPath.row]];
			}
			outCell = subCell;
			break;
		default:
			outCell = [[AXTableViewCell alloc] init];
			break;
	}
    
    return outCell;
}

@end
