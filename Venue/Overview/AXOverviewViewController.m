//
//  AXCoursesViewController.m
//  Venue
//
//  Created by Jim Boulter on 1/4/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import "AXOverviewViewController.h"
#import "AXCourseTableViewCell.h"
#import "AXAppCoordinator.h"
#import "AXAPI.h"
#import "AXEventHeaderView.h"

@interface AXOverviewViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, assign) AXContentMode contentMode;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) UILabel *emptyLabel;

@property (nonatomic, strong) NSArray *events;
@property (nonatomic, strong) NSArray *filteredEvents;
@property (nonatomic, strong) NSArray *courses;
@property (nonatomic, strong) NSArray *filteredCourses;

@property (nonatomic, strong) UISearchController *searchController;
@end

@implementation AXOverviewViewController
@synthesize progressView, contentMode, emptyLabel, searchController;

- (instancetype)init {
	if ((self = [super init])) {
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
		
		[self setContentMode:AXContentModeEvents];

        
        self.refreshControl = [[UIRefreshControl alloc] init];
        self.refreshControl.backgroundColor = [UIColor whiteColor];
        self.refreshControl.tintColor = [UIColor accentColor];
        [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
        [self.tableView insertSubview:self.refreshControl atIndex:0];

        searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        searchController.searchResultsUpdater = self;
        searchController.dimsBackgroundDuringPresentation = false;
		searchController.hidesNavigationBarDuringPresentation = false;
        searchController.searchBar.barTintColor = [UIColor primaryColor];
		searchController.definesPresentationContext = YES;
		
		self.tableView.tableHeaderView = self.searchController.searchBar;
		
		self.extendedLayoutIncludesOpaqueBars = YES;
        self.definesPresentationContext = YES;
        
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
    
    [self.view addSubview:progressView];
	[self.tableView addSubview:emptyLabel];
    [self.view addSubview:self.tableView];

    [progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@1);
    }];
	
	[emptyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(self.tableView.mas_centerX);
		make.centerY.equalTo(self.tableView.mas_centerY);
	}];
	
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(progressView.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
}

#pragma mark - Actions

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    if ([self.searchController.searchBar.text isEqualToString:@""]) {
        self.filteredEvents = self.events;
        self.filteredCourses = self.courses;
    }
	else {
		NSMutableArray *mult = [[NSMutableArray alloc] init];
		
		
		self.filteredEvents = mult;
		
	}
//	else {
//        self.filteredEvents = [self.events filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.name contains %@", self.searchController.searchBar.text]];
//        self.filteredCourses = [self.courses filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.name contains %@", self.searchController.searchBar.text]];
//    }
	
//    [UIView transitionWithView:self.view duration:.3 options:0 animations:^{
//        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
//    } completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	if ([self.events count] > 0)
		return 32.0f;
	else
		return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	if ([self.events count] > 0) {
		AXEventHeaderView *header = [[AXEventHeaderView alloc] init];
	
		AXEvent *evt = self.filteredEvents[section][0];
		
		NSDate *dayDate = [[NSCalendar currentCalendar] startOfDayForDate:evt.startDate];
		
		NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
		[fmt setDateFormat:@"EEEE, MMMM dd, yyyy"];
		NSString *ret = [fmt stringFromDate:dayDate];
		
		[header setDateString:ret];
		
//		[header setDateString:];
	
		return header;
	}
	else {
		return nil;
	}
}

NSDate *dayDateForDate(NSDate *given) {
	return [[NSCalendar currentCalendar] startOfDayForDate:given];
}

- (void)sortEvents:(NSArray *)events {
	
	NSMutableArray *compose = [[NSMutableArray alloc] init];
	
	// this may look confusing, but that's ok. that's what comments are for.
	// this is just an insertion sort based on the date, and tries to put
	// events that are on the same day into buckets.
	
	for (AXEvent *ev in events) {
		NSMutableArray *insertArray = nil;
		
		for (int i = 0; i < [compose count]; i++) {
			NSMutableArray *array = compose[i];
			
			NSDate *radix = dayDateForDate([array[0] startDate]);
			NSDate *date = dayDateForDate([ev startDate]);
			
			if ([date compare:radix] < 0) {
				insertArray = [[NSMutableArray alloc] init];
				[compose insertObject:insertArray atIndex:i];
				
				break;
			}
			else if ([date compare:radix] > 0) {
				continue;
			}
			else {
				insertArray = array;
				break;
			}
		}
		
		if (!insertArray) {
			insertArray = [[NSMutableArray alloc] init];
			[compose addObject:insertArray];
		}
		
		[insertArray addObject:ev];
	}
	
	self.filteredEvents = compose;
	self.events = compose;
}

- (void)refresh {
    [[AXAPI API] getEventsWithProgressView:progressView completion:^(NSArray *events) {
		[self sortEvents:events];
        if (contentMode == AXContentModeEvents) {
			self.emptyLabel.hidden = self.events.count > 0;
			
//            [UIView transitionWithView:self.view duration:.3 options:0 animations:^{
//                [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
//            } completion:^(BOOL finished) {
//                [self.refreshControl endRefreshing];
//            }];
			
			[_tableView reloadData];
        }
    }];
    
    [[AXAPI API] getCoursesWithProgressView:progressView completion:^(NSArray * courses) {
        self.courses = courses;
        if (contentMode == AXContentModeCourses) {
			self.emptyLabel.hidden = self.courses.count > 0;
//            [UIView transitionWithView:self.view duration:.3 options:0 animations:^{
//                [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
//            } completion:^(BOOL finished) {
//                [self.refreshControl endRefreshing];
//            }];
        }
    }];
}

#pragma mark - UITableView

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(!contentMode) {
        [[AXAppCoordinator sharedInstance] navigateToEvent:self.filteredEvents[indexPath.row]];
    }
    else {
        [[AXAppCoordinator sharedInstance] navigateToCourse:self.filteredCourses[indexPath.row]];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (contentMode ? self.filteredCourses.count : [self.filteredEvents[section] count]);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return self.events.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AXCourseTableViewCell* cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:[AXCourseTableViewCell reuseIdentifier]];
    if (!cell) {
        cell = [[AXCourseTableViewCell alloc] init];
    }
    
    NSMutableDictionary* object = [[NSMutableDictionary alloc] init];
    [object setObject:@(contentMode) forKey:@"contentMode"];
    
    if (contentMode == AXContentModeEvents) {
		NSArray *evts = self.filteredEvents[indexPath.section];
		
        [cell configureWithEvent:evts[indexPath.row]];
    }
    else {
        [cell configureWithCourse:self.courses[indexPath.row]];
    }
    
    return cell;
}

#pragma mark - AXNavigationBarDelegate

- (void)contentModeDidChange:(AXContentMode)mode {
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

- (void)setContentMode:(AXContentMode)mode {
	contentMode = mode;
	NSString *contentType = (contentMode == AXContentModeEvents ? @"events" : @"courses");
	
	[emptyLabel setText:[NSString stringWithFormat:@"No %@ yet", contentType]];
}

@end
