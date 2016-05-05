//
//  AXDetailViewController.m
//  Venue
//
//  Created by Jim Boulter on 1/9/16.
//  Copyright © 2016 JimBoulter. All rights reserved.
//

#import "AXDetailViewController.h"

@interface AXDetailViewController ()

@end

@implementation AXDetailViewController

@synthesize imageView, detailContainerView, blurView, tapButton, detailTitleLabel, detailSubtitleLabel, detailDescriptionTextView, tableTitleLabel, progressView, emptyLabel;

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        imageView = [[UIImageView alloc] init];
        
        detailContainerView = [[UIView alloc] init];
        
        blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        [blurView setUserInteractionEnabled:YES];
        
        tapButton = [[UIButton alloc] init];
        [tapButton addTarget:self action:@selector(blurViewTapped) forControlEvents:UIControlEventTouchUpInside];
        [tapButton setBackgroundColor:[UIColor clearColor]];
        
        detailTitleLabel = [[UILabel alloc] init];
        [detailTitleLabel setTextColor:[UIColor whiteColor]];
        [detailTitleLabel setNumberOfLines:0];
        [detailTitleLabel setContentHuggingPriority:1000 forAxis:UILayoutConstraintAxisVertical];
        
        detailSubtitleLabel = [[UILabel alloc] init];
        [detailSubtitleLabel setTextColor:[UIColor lightGrayColor]];
        [detailSubtitleLabel setFont:[UIFont thinFontOfSize:16]];
        [detailSubtitleLabel setTextAlignment:NSTextAlignmentRight];
        [detailSubtitleLabel setContentCompressionResistancePriority:800 forAxis:UILayoutConstraintAxisHorizontal];
        
        detailDescriptionTextView = [[UITextView alloc] init];
        detailDescriptionTextView.backgroundColor = [UIColor clearColor];
        [detailDescriptionTextView setTextColor:[UIColor whiteColor]];
        
        tableTitleLabel = [[UILabel alloc] init];
        tableTitleLabel.attributedText = [[NSAttributedString alloc] initWithString:@"Events"
                                                                         attributes:@{
                                                                       NSStrokeColorAttributeName : [UIColor blackColor], NSForegroundColorAttributeName : [UIColor whiteColor], NSStrokeWidthAttributeName : @-1.0 }];
        
        progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        progressView.backgroundColor = [UIColor lightGrayColor];
        progressView.tintColor = [UIColor venueRedColor];
        
        emptyLabel = [[UILabel alloc] init];
        [emptyLabel setFont:[UIFont italicSystemFontOfSize:17]];
        [emptyLabel setTextColor:[UIColor lightGrayColor]];
        [emptyLabel setTextAlignment:NSTextAlignmentCenter];
        
        self.tableView = [[UITableView alloc] init];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor venueRedColor];
    
    [self.view addSubview:imageView];
    [self.view addSubview:detailContainerView];
    [self.view addSubview:tapButton];
    [detailContainerView addSubview:blurView];
    [detailContainerView insertSubview:detailTitleLabel aboveSubview:blurView];
    [detailContainerView insertSubview:detailSubtitleLabel aboveSubview:blurView];
    [detailContainerView insertSubview:detailDescriptionTextView aboveSubview:blurView];
//    [self.view addSubview:tableTitleLabel];
//    [self.view bringSubviewToFront:tableTitleLabel];
    [self.view addSubview:progressView];
    [self.tableView addSubview:emptyLabel];
    [self.view addSubview:self.tableView];
    
    UIEdgeInsets padding = UIEdgeInsetsMake(10, 10, -10, -10);
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_centerY);
    }];
    
    [detailContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(imageView);
    }];
    
    [blurView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_top);
        make.left.equalTo(self.imageView.mas_left);
        make.right.equalTo(self.imageView.mas_right);
        make.bottom.equalTo(self.imageView).with.offset(-44);
    }];
    
    [tapButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(imageView);
    }];
    
   [detailTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.equalTo(detailContainerView.mas_top).with.offset(padding.top);
       make.left.equalTo(detailContainerView.mas_left).with.offset(padding.left);
       make.right.equalTo(detailSubtitleLabel.mas_left).with.offset(padding.right);
   }];
    
    [detailSubtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(detailContainerView.mas_top).with.offset(padding.top);
        make.left.equalTo(detailTitleLabel.mas_right).with.offset(padding.left);
        make.right.equalTo(detailContainerView.mas_right).with.offset(padding.right);
    }];
    
    [detailDescriptionTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(detailTitleLabel.mas_bottom).with.offset(padding.top);
        make.left.equalTo(detailContainerView.mas_left).with.offset(padding.left);
        make.right.equalTo(detailContainerView.mas_right).with.offset(padding.right);
        make.bottom.equalTo(detailContainerView.mas_bottom).with.offset(padding.bottom);
    }];
    
//    [tableTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.top.equalTo(detailContainerView.mas_bottom);
//        make.left.equalTo(self.view.mas_left).with.offset(padding.left);
//        make.bottom.equalTo(self.tableView.mas_top).with.offset(padding.bottom);
//    }];
    
    [progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@1);
    }];
    
    [emptyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.tableView.mas_centerX);
        make.centerY.equalTo(self.tableView.mas_centerY);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIGestureRecognizer

-(void)blurViewTapped
{
    NSLog(@"Blur Tapped");
    [UIView transitionWithView:detailContainerView duration:.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        detailContainerView.hidden = !detailContainerView.hidden;
    } completion:nil];
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
