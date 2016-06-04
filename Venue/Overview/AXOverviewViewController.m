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
@property UITableView* tableView;
@property AXContentSelectionToolbar* modeToolBar;
@property UIProgressView* progressView;
@property AXContentMode contentMode;
@property UIRefreshControl* refreshControl;

@property NSArray* events;
@property NSArray* courses;
@end

@implementation AXOverviewViewController
@synthesize modeToolBar, progressView, contentMode;

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RPI"]];
        
        self.tableView = [[UITableView alloc] init];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        progressView.tintColor = [UIColor venueRedColor];
        
        modeToolBar = [[AXContentSelectionToolbar alloc] initWithDelegate:self];
    
        contentMode = AXContentModeEvents;
        
        // Initialize the refresh control
        
        self.refreshControl = [[UIRefreshControl alloc] init];
        self.refreshControl.backgroundColor = [UIColor lightGrayColor];
        self.refreshControl.tintColor = [UIColor blackColor];
        [self.refreshControl addTarget:self
                                action:@selector(refresh)
                      forControlEvents:UIControlEventValueChanged];
        [self.tableView insertSubview:self.refreshControl atIndex:0];
        
        [self refresh];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Nav Bar Gear
    UIButton* gear = [UIButton buttonWithType:UIButtonTypeCustom];
    gear.bounds = CGRectMake(0, 0, 22, 22);
    [gear setImage:[UIImage imageNamed:@"Gear"] forState:UIControlStateNormal];
    [gear addTarget:self action:@selector(showSettings) forControlEvents:UIControlEventTouchUpInside];
    [[self navigationItem] setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:gear]];
    
    [self.view addSubview:modeToolBar];
    [self.view bringSubviewToFront:modeToolBar];
    [self.view addSubview:progressView];
    [self.view addSubview:self.tableView];

    [modeToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.right.equalTo(self.view.mas_right);
        make.left.equalTo(self.view.mas_left);
        make.height.equalTo(@44);
    }];
    
    [progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(modeToolBar.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@1);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(modeToolBar.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    
    //Hide the shadow underneath the navigation bar
    for (UIView *view in self.navigationController.navigationBar.subviews) {
        for (UIView *subview in view.subviews) {
            if ([subview isKindOfClass:[UIImageView class]]) {
                subview.alpha = 0;
            }
        }
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - Actions

-(void)refresh
{
    [[AXAPI API] getEventsWithProgressView:progressView completion:^(NSArray * events) {
        self.events = events;
        if(contentMode == AXContentModeEvents)
        {
            [UIView transitionWithView:self.view duration:.3 options:0 animations:^{
                [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
            } completion:^(BOOL finished) {
                [self.refreshControl endRefreshing];
            }];
        }
    }];
    
    [[AXAPI API] getCoursesWithProgressView:nil completion:^(NSArray * courses) {
        self.courses = courses;
        if(contentMode == AXContentModeCourses)
        {
            [UIView transitionWithView:self.view duration:.3 options:0 animations:^{
                [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
            } completion:^(BOOL finished) {
                [self.refreshControl endRefreshing];
            }];
        }
    }];
}

-(void)showSettings
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Log out?"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Log out" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        AppDelegate* del = [[UIApplication sharedApplication] delegate];
        [del setLoggedOut];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UITableView

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.title = @"";
    AXDetailViewController* vc;
    if(!contentMode)
    {
        vc = [[AXEventViewController alloc] initWithEvent:self.events[indexPath.row]];
    }
    else
    {
        vc = [[AXCourseViewController alloc] initWithCourse:self.courses[indexPath.row]];
    }
    [self.navigationController pushViewController:vc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (contentMode ? 100 : 120);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (contentMode ? self.courses.count : self.events.count);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AXCourseTableViewCell* cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:[AXCourseTableViewCell jim_reuseIdentifier]];
    if(!cell)
    {
        cell = [[AXCourseTableViewCell alloc] init];
    }
    
    NSMutableDictionary* object = [[NSMutableDictionary alloc] init];
    [object setObject:@(contentMode) forKey:@"contentMode"];
    
    
    
    if(contentMode == AXContentModeEvents)
    {
        [cell configureWithEvent:self.events[indexPath.row]];
    }
    else
    {
        [cell configureWithCourse:self.courses[indexPath.row]];
    }
    
    return cell;
}

#pragma mark - AXContentSelectionToolbarDelegate

-(void)contentModeDidChange:(AXContentMode)mode
{
    contentMode = mode;
    
    [UIView transitionWithView:self.view duration:.3 options:0 animations:^{
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    } completion:nil];
    
    
}

@end
