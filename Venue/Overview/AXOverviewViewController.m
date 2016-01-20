//
//  AXCoursesViewController.m
//  Venue
//
//  Created by Jim Boulter on 1/4/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import "AXOverviewViewController.h"
#import "AXCourseTableViewCell.h"
#import "AXCourseViewController.h"
#import "AXEventViewController.h"
#import "AXAPI.h"

@interface AXOverviewViewController ()
@property UITableView* courseTableView;
@property UITableView* eventTableView;
@property AXContentSelectionToolbar* modeToolBar;
@property AXContentMode contentMode;

@property NSArray* events;
@property NSArray* courses;
@end

@implementation AXOverviewViewController
@synthesize modeToolBar, contentMode;

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        self.eventTableView = [[UITableView alloc] init];
        self.eventTableView.delegate = self;
        self.eventTableView.dataSource = self;
        
        self.courseTableView = [[UITableView alloc] init];
        self.courseTableView.delegate = self;
        self.courseTableView.dataSource = self;
        self.courseTableView.hidden = YES;
        
        modeToolBar = [[AXContentSelectionToolbar alloc] initWithDelegate:self];
        
        contentMode = AXContentModeEvents;
        
        [[AXAPI API] getEventsWithProgressView:nil completion:^(NSArray * events) {
            self.events = events;
            [self.eventTableView reloadData];
        }];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:modeToolBar];
    [self.view bringSubviewToFront:modeToolBar];
    [self.view addSubview:self.eventTableView];
    [self.view addSubview:self.courseTableView];

    [modeToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.right.equalTo(self.view.mas_right);
        make.left.equalTo(self.view.mas_left);
        make.height.equalTo(@44);
    }];
    
    [self.eventTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(modeToolBar.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    
    [self.courseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(modeToolBar.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title = @"Venue_x";
}

#pragma mark - UITableView

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.title = @"";
    AXDetailViewController* vc;
    if(tableView == self.eventTableView)
    {
        vc = [[AXEventViewController alloc] init];
    }
    else
    {
        vc = [[AXCourseViewController alloc] init];
    }
    [self.navigationController pushViewController:vc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AXTableViewCell* cell;
    
    if(tableView == self.eventTableView)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:[AXEventTableViewCell reuseIdentifier]];
        if(!cell)
        {
            cell = [[AXEventTableViewCell alloc] init];
        }
        
        AXEventTableViewCell* eCell = (AXEventTableViewCell*) cell;
        [eCell configureWithEvent:self.events[indexPath.row]];
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:[AXCourseTableViewCell reuseIdentifier]];
        if(!cell)
        {
            cell = [[AXCourseTableViewCell alloc] init];
        }
        
        NSMutableDictionary* object = [[NSMutableDictionary alloc] init];
        [object setObject:@(contentMode) forKey:@"contentMode"];
        
        AXCourseTableViewCell* cCell = (AXCourseTableViewCell*) cell;
        [cCell configureWithDictionary:object];
    }
    
    return cell;
}

#pragma mark - AXContentSelectionToolbarDelegate

-(void)contentModeDidChange:(AXContentMode)mode
{
    contentMode = mode;
    
    [UIView transitionWithView:self.view duration:.25 options:0 animations:^{
        self.eventTableView.hidden = !(contentMode == AXContentModeEvents);
        self.courseTableView.hidden = (contentMode == AXContentModeEvents);
    } completion:nil];
    
}

@end
