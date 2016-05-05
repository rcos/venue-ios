//
//  AXCourseViewController.m
//  Venue
//
//  Created by Jim Boulter on 1/9/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import "AXCourseViewController.h"
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
        [self.detailSubtitleLabel setText:[NSString stringWithFormat:@"%@-%@", course.department, course.courseNumber]];
        [self.detailDescriptionTextView setText:course.courseDescription];
        [self.detailTitleLabel setText:course.name];
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:course.imageUrl]];
        
        [self.emptyLabel setText:@"No events yet"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
