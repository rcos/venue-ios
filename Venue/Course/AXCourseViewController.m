//
//  AXCourseViewController.m
//  Venue
//
//  Created by Jim Boulter on 1/9/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import "AXCourseViewController.h"
#import "AXEventViewController.h"
#import "AXNavigationBar.h"
#import "AXImageTableViewCell.h"
#import "AXTextTableViewCell.h"
#import "AXHeaderFooterView.h"

@interface AXCourseViewController ()
@property AXCourse* course;
@property NSArray* events;

@end

@implementation AXCourseViewController
@synthesize course, events;

-(instancetype)initWithCourse:(AXCourse*)_course
{
	course = _course;
    self = [super init];
    if(self)
    {
        [self refresh];
    }
    return self;
}

#pragma mark - Action

-(void)refresh
{
    [[AXAPI API] getEventsWithSectionId:self.course.courseId progressView:self.progressView completion:^(NSArray *_events) {
        self.events = _events;
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView transitionWithView:self.view duration:.3 options:0 animations:^{
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
            } completion:^(BOOL finished) {
                [self.refreshControl endRefreshing];
            }];
        });
        
    }];
}

#pragma mark - UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	switch (section) {
		case 0:
			return 2;
		case 1:
			return self.events.count;
	}
	return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	if(section == 0) {
		return nil;
	}
	AXHeaderFooterView* view = [[AXHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
	
	switch (section) {
		case 1:
			if([self tableView:tableView numberOfRowsInSection:2] > 0) {
				[view setTitle:@"events".uppercaseString];
			} else {
				[view setTitle:@"no events yet".uppercaseString];
			}
			break;
	}
	
	return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(indexPath.section == 1) {
		AXEventViewController* vc = [[AXEventViewController alloc] initWithEvent:self.events[indexPath.row]];
		[self.navigationController pushViewController:vc animated:YES];
	}
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	AXImageTableViewCell* imgCell;
	AXTextTableViewCell* textCell;
	AXCourseTableViewCell* eventCell;
	UITableViewCell* outCell;
	
	switch (indexPath.section) {
	// Description
		case 0:
			switch (indexPath.row) {
				case 0:
					imgCell = [tableView dequeueReusableCellWithIdentifier:[AXImageTableViewCell reuseIdentifier]];
					if(!imgCell) {
						imgCell = [[AXImageTableViewCell alloc] init];
					}
					[imgCell configureWithImageUrl:course.imageUrl];
					outCell = imgCell;
					break;
				case 1:
					textCell = [tableView dequeueReusableCellWithIdentifier:[AXTextTableViewCell reuseIdentifier]];
					if(!textCell) {
						textCell = [[AXTextTableViewCell alloc] init];
					}
					[textCell configureWithText:course.courseDescription divider:NO];
					outCell = textCell;
					break;
			}
			break;
		case 1:
			eventCell = [tableView dequeueReusableCellWithIdentifier:[AXCourseTableViewCell reuseIdentifier]];
			
			if(!eventCell)
			{
				eventCell = [[AXCourseTableViewCell alloc] init];
			}
			
			[eventCell configureWithEvent:self.events[indexPath.row]];
			outCell = eventCell;
			break;
	}
    
    return outCell;
}

@end
