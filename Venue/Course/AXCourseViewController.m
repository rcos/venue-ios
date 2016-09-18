//
//  AXCourseViewController.m
//  Venue
//
//  Created by Jim Boulter on 1/9/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import "AXCourseViewController.h"
#import "AXEventViewController.h"
@interface AXCourseViewController ()
@property AXCourse* course;
@property NSArray* events;

@end

@implementation AXCourseViewController
@synthesize course, events;

-(instancetype)initWithCourse:(AXCourse*)_course
{
    self = [super init];
    if(self)
    {
        course = _course;
        
        [self refresh];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self.detailSubtitleLabel setText:[NSString stringWithFormat:@"%@-%@", course.department, course.courseNumber]];
    [self.detailDescriptionTextView setText:course.courseDescription];
    [self.detailTitleLabel setText:course.name];
    [self.imageView setImageWithUnknownPath:course.imageUrl];
    
    self.emptyLabel.hidden = true;
    [self.emptyLabel setText:@"No events yet"];
}

#pragma mark - Action

-(void)refresh
{
    [[AXAPI API] getEventsWithSectionId:self.course.courseId progressView:self.progressView completion:^(NSArray *_events) {
        self.events = _events;
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView transitionWithView:self.view duration:.3 options:0 animations:^{
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
            } completion:^(BOOL finished) {
                [self.refreshControl endRefreshing];
            }];
        });
        
    }];
}

#pragma mark - UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.emptyLabel.hidden = (self.events.count != 0);
    return self.events.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AXEventViewController* vc = [[AXEventViewController alloc] initWithEvent:self.events[indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AXCourseTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:[AXCourseTableViewCell jim_reuseIdentifier]];
    
    if(!cell)
    {
        cell = [[AXCourseTableViewCell alloc] init];
    }
    
    [cell configureWithEvent:self.events[indexPath.row]];
    
    return cell;
}

@end
