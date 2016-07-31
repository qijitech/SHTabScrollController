//
//  SHViewController.m
//  SHTabScrollController
//
//  Created by @harushuu on 07/30/2016.
//  Copyright (c) 2016 @harushuu. All rights reserved.
//

#import "SHViewController.h"
#import <SHTabScrollController/SHTabScrollController.h>
#import "SHFirstTableViewController.h"
#import "SHSecnodTableViewController.h"
#import "SHThirdTableViewController.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface SHViewController ()
@property (nonatomic, strong) UILabel *topLabel;

@end

@implementation SHViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self setupTabScrollController];
}

- (void)setupViews {
    [self.view addSubview:self.topLabel];
}

- (void)setupTabScrollController {
    NSArray *titles = @[@"tab0", @"tab1", @"tab2"];
    NSArray *controllers = @[[[SHFirstTableViewController alloc] init], [[SHSecnodTableViewController alloc] init], [[SHThirdTableViewController alloc] init]];
    
    SHTabScrollController *tabScrollController = [SHTabScrollController setupTitles:titles controllers:controllers tabIndexHandle:^(NSInteger index) {
        NSString *status = [NSString stringWithFormat:@"current tab is %ld", index];
        NSLog(@"%@", status);
        self.topLabel.text = status;
    }];
    [self addChildViewController:tabScrollController];
     tabScrollController.view.frame = CGRectMake(0, CGRectGetMaxY(self.topLabel.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(self.topLabel.frame));
    [self.view addSubview:tabScrollController.view];
}

- (UILabel *)topLabel {
    if (!_topLabel) {
        _topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
        _topLabel.text = @"Your custom top view";
        _topLabel.textAlignment = NSTextAlignmentCenter;
        _topLabel.backgroundColor = [UIColor lightGrayColor];
        _topLabel.layer.borderWidth = 1.f;
        _topLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    return _topLabel;
}

@end
