//
//  AXDetailViewController.m
//  Venue
//
//  Created by Jim Boulter on 1/9/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import "AXDetailViewController.h"

@implementation AXDetailViewController

@synthesize progressView, emptyLabel;

-(instancetype)init
{
    self = [super init];
    if(self)
    {
//        self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RedRPI"]];
        self.view.backgroundColor = [UIColor backgroundColor];
		
        progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        progressView.backgroundColor = [UIColor backgroundColor];
        progressView.tintColor = [UIColor accentColor];
        
        emptyLabel = [[UILabel alloc] init];
        [emptyLabel setFont:[UIFont italicSystemFontOfSize:17]];
        [emptyLabel setTextColor:[UIColor lightGrayColor]];
        [emptyLabel setTextAlignment:NSTextAlignmentCenter];
        
        self.tableView = [[UITableView alloc] init];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		self.tableView.backgroundColor = [UIColor backgroundColor];
		self.tableView.rowHeight = -1;
		self.tableView.estimatedRowHeight = 100;
        
        self.refreshControl = [[UIRefreshControl alloc] init];
        self.refreshControl.backgroundColor = [UIColor whiteColor];
        self.refreshControl.tintColor = [UIColor accentColor];
        [self.refreshControl addTarget:self
                           action:@selector(refresh)
                 forControlEvents:UIControlEventValueChanged];
        [self.tableView insertSubview:self.refreshControl atIndex:0];
		
		[self.view addSubview:progressView];
		[self.tableView addSubview:emptyLabel];
		[self.view addSubview:self.tableView];
		
        [self refresh];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
    [progressView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@1);
    }];
    
    [emptyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.tableView);
        make.centerY.equalTo(self.tableView);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(progressView.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

#pragma mark - Action

-(void)refresh
{
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==0)return 0.00001f;
    return 13.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00001f;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSAssert(NO, @"cellForRowAtIndexPath: needs to be overridden");
    UITableViewCell* cell =  [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    
    cell.textLabel.text = @"Override cellForRowAtIndexPath";
    
    return cell;
}

@end
