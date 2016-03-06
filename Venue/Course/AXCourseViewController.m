//
//  AXCourseViewController.m
//  Venue
//
//  Created by Jim Boulter on 1/9/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import "AXCourseViewController.h"
@interface AXCourseViewController ()

@property NSString* courseId;
@property NSArray* events;

@end

@implementation AXCourseViewController
@synthesize courseId, events;

-(instancetype)initWithCourse:(NSDictionary*)course
{
    self = [super init];
    if(self)
    {
        courseId = course[@"_id"];
        
        [self.detailSubtitleLabel setText:[NSString stringWithFormat:@"%@-%@", course[@"department"], course[@"courseNumber"]]];
        [self.detailDescriptionTextView setText:course[@"description"]];
        [self.detailTitleLabel setText:course[@"name"]];
        [self.imageView setImage:[UIImage imageNamed:@"Firework"]];
        
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
    
    UITableViewCell* cell =  [tableView dequeueReusableCellWithIdentifier:[AXEventTableViewCell reuseIdentifier]];
    
    if(!cell)
    {
        cell = [[AXEventTableViewCell alloc] init];
    }
    
    return cell;
}

@end
