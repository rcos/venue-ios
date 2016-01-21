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
@synthesize imageView, blurView, detailTitleLabel, detailSubtitleLabel, detailDescriptionTextView, tableTitleLabel;

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        imageView = [[UIImageView alloc] init];
        
        blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        [blurView setUserInteractionEnabled:YES];
        
        UITapGestureRecognizer* gr = [[UITapGestureRecognizer alloc] init];
        gr.delegate = self;
        gr.numberOfTapsRequired = 1;
        gr.numberOfTouchesRequired = 1;
        gr.cancelsTouchesInView = NO;
        [blurView addGestureRecognizer:gr];
        
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
    [imageView addSubview:blurView];
    [blurView addSubview:detailTitleLabel];
    [blurView addSubview:detailSubtitleLabel];
    [blurView addSubview:detailDescriptionTextView];
    [imageView addSubview:tableTitleLabel];
    [self.view bringSubviewToFront:tableTitleLabel];
    [self.view addSubview:self.tableView];
    
    UIEdgeInsets padding = UIEdgeInsetsMake(10, 10, -10, -10);
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_centerY);
    }];
    
    [blurView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(blurView.superview.mas_top);
        make.left.equalTo(blurView.superview.mas_left);
        make.right.equalTo(blurView.superview.mas_right);
        make.bottom.equalTo(blurView.superview.mas_bottom).with.offset(-44);
    }];
    
   [detailTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.equalTo(detailTitleLabel.superview.mas_top).with.offset(padding.top);
       make.left.equalTo(detailTitleLabel.superview.mas_left).with.offset(padding.left);
       make.right.equalTo(detailSubtitleLabel.mas_left).with.offset(padding.right);
   }];
    
    [detailSubtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(detailSubtitleLabel.superview.mas_top).with.offset(padding.top);
        make.left.equalTo(detailTitleLabel.mas_right).with.offset(padding.left);
        make.right.equalTo(detailSubtitleLabel.superview.mas_right).with.offset(padding.right);
    }];
    
    [detailDescriptionTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(detailTitleLabel.mas_bottom).with.offset(padding.top);
        make.left.equalTo(detailDescriptionTextView.superview.mas_left).with.offset(padding.left);
        make.right.equalTo(detailDescriptionTextView.superview.mas_right).with.offset(padding.right);
        make.bottom.equalTo(detailDescriptionTextView.superview.mas_bottom).with.offset(padding.bottom);
    }];
    
    [tableTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(blurView.mas_bottom);
        make.left.equalTo(tableTitleLabel.superview.mas_left).with.offset(padding.left);
        make.bottom.equalTo(tableTitleLabel.superview.mas_bottom);
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

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [UIView transitionWithView:blurView duration:.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        blurView.hidden = !blurView.hidden;
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
