//
//  AXCoursesViewController.m
//  Venue
//
//  Created by Jim Boulter on 1/4/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import "AXCoursesViewController.h"

@interface AXCoursesViewController ()
@property UITableView* tableview;
@property UIToolbar* modeToolBar;
@end

@implementation AXCoursesViewController
@synthesize tableview, modeToolBar;

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        tableview = [[UITableView alloc] init];
        tableview.delegate = self;
        tableview.dataSource = self;
        
        modeToolBar = [[UIToolbar alloc] init];
        modeToolBar.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:modeToolBar];
    [self.view addSubview:tableview];

//    [modeToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view.mas_top);
//        make.right.equalTo(self.view.mas_right);
//        make.left.equalTo(self.view.mas_left);
//    }];
    [tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView

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
    return [[UITableViewCell alloc] init];
}

@end
