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
@property (nonatomic) AXContentMode contentMode;
@property UIRefreshControl* refreshControl;
@property UILabel* emptyLabel;

@property NSArray* events;
@property NSArray* filteredEvents;
@property NSArray* courses;
@property NSArray* filteredCourses;

@property UISearchController* searchController;
@end

@implementation AXOverviewViewController
@synthesize modeToolBar, progressView, contentMode, emptyLabel, searchController;

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        //self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RedRPI"]];
        
        self.tableView = [[UITableView alloc] init];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = [UIColor backgroundColor];
        self.tableView.estimatedRowHeight = 180;
        self.tableView.rowHeight = -1;
        
        progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        progressView.progressTintColor = [UIColor accentColor];
        progressView.trackTintColor = [UIColor lightGrayColor];
        
		emptyLabel = [[UILabel alloc] init];
		[emptyLabel setFont:[UIFont italicSystemFontOfSize:17]];
		[emptyLabel setTextColor:[UIColor lightGrayColor]];
		[emptyLabel setTextAlignment:NSTextAlignmentCenter];
		
        modeToolBar = [[AXContentSelectionToolbar alloc] initWithDelegate:self];
    
		[self setContentMode:AXContentModeEvents];
		
        // Initialize the refresh control
        
        self.refreshControl = [[UIRefreshControl alloc] init];
        self.refreshControl.backgroundColor = [UIColor whiteColor];
        self.refreshControl.tintColor = [UIColor accentColor];
        [self.refreshControl addTarget:self
                                action:@selector(refresh)
                      forControlEvents:UIControlEventValueChanged];
        [self.tableView insertSubview:self.refreshControl atIndex:0];
        
        // init search controller
        
        searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        searchController.searchResultsUpdater = self;
        searchController.dimsBackgroundDuringPresentation = false;
		searchController.hidesNavigationBarDuringPresentation = false;
        searchController.searchBar.barTintColor = [UIColor primaryColor];
		
		// Hack to keep search bar from moving
		UIView* container = [[UIView alloc] initWithFrame:searchController.searchBar.frame];
		[container addSubview:searchController.searchBar];
		[container setClipsToBounds:YES];
		
        
        self.definesPresentationContext = false;
        
        self.tableView.tableHeaderView = container;
        
        // Watch events and courses to update search on refresh of results from server
        [self.KVOController observe:self keyPath:@"events" options:NSKeyValueObservingOptionInitial block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
            [self updateSearchResultsForSearchController:searchController];
        }];
        
        [self.KVOController observe:self keyPath:@"courses" options:NSKeyValueObservingOptionInitial block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
            [self updateSearchResultsForSearchController:searchController];
        }];
        
        [self refresh];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:modeToolBar];
    [self.view bringSubviewToFront:modeToolBar];
    [self.view addSubview:progressView];
	[self.tableView addSubview:emptyLabel];
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
	
	[emptyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(self.tableView.mas_centerX);
		make.centerY.equalTo(self.tableView.mas_centerY);
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
    self.title = @"Venue";
    [super viewWillAppear:animated];
    UIBarButtonItem* gear = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Gear"] style:UIBarButtonItemStylePlain target:self action:@selector(showSettings)];
    gear.tintColor = [UIColor secondaryColor];
    [[self navigationItem] setLeftBarButtonItem:gear];
}

#pragma mark - Actions

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    if([self.searchController.searchBar.text isEqualToString:@""]) {
        self.filteredEvents = self.events;
        self.filteredCourses = self.courses;
    } else {
        self.filteredEvents = [self.events filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.name contains %@", self.searchController.searchBar.text]];
        self.filteredCourses = [self.courses filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.name contains %@", self.searchController.searchBar.text]];
    }
    
    [UIView transitionWithView:self.view duration:.3 options:0 animations:^{
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    } completion:nil];
}

-(void)refresh
{
    [[AXAPI API] getEventsWithProgressView:progressView completion:^(NSArray * events) {
        self.events = events;
        if(contentMode == AXContentModeEvents)
        {
			self.emptyLabel.hidden = self.events.count > 0;
            [UIView transitionWithView:self.view duration:.3 options:0 animations:^{
                [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
            } completion:^(BOOL finished) {
                [self.refreshControl endRefreshing];
            }];
        }
    }];
    
    [[AXAPI API] getCoursesWithProgressView:progressView completion:^(NSArray * courses) {
        self.courses = courses;
        if(contentMode == AXContentModeCourses)
        {
			self.emptyLabel.hidden = self.courses.count > 0;
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
        AppDelegate* del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
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
        vc = [[AXEventViewController alloc] initWithEvent:self.filteredEvents[indexPath.row]];
    }
    else
    {
        vc = [[AXCourseViewController alloc] initWithCourse:self.filteredCourses[indexPath.row]];
    }
    [self.navigationController pushViewController:vc animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (contentMode ? self.filteredCourses.count : self.filteredEvents.count);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AXCourseTableViewCell* cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:[AXCourseTableViewCell reuseIdentifier]];
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
	[self setContentMode:mode];
	
	emptyLabel.hidden = true;
    [UIView transitionWithView:self.view duration:.3 options:0 animations:^{
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    } completion:^(BOOL finished) {
		if (contentMode == AXContentModeEvents) {
			self.emptyLabel.hidden = self.events.count > 0;
		} else {
			self.emptyLabel.hidden = self.courses.count > 0;
		}
	}];
}

#pragma mark - ContentMode

-(void)setContentMode:(AXContentMode)mode
{
	contentMode = mode;
	NSString* contentType = (contentMode == AXContentModeEvents ? @"events" : @"courses");
	
	[emptyLabel setText:[NSString stringWithFormat:@"No %@ yet", contentType]];
}

@end
