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
#import <SHButton/SHButton.h>

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface SHViewController ()
@property (nonatomic, strong) SHButton *topLabelButton;
@property (nonatomic, assign) BOOL onlyImage;

@end

@implementation SHViewController

- (instancetype)initWithTitle {
    if (self = [super init]) {
        self.onlyImage = NO;
    }
    return self;
}

- (instancetype)initWithImage {
    if (self = [super init]) {
        self.onlyImage = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self setupTabScrollController];
}

- (void)setupViews {
    [self.view addSubview:self.topLabelButton];
}

- (void)setupTabScrollController {
    if (!self.onlyImage) {
        NSArray *titles = @[@"tab0", @"tab1", @"tab2"];
        NSArray *controllers = @[[[SHFirstTableViewController alloc] init], [[SHSecnodTableViewController alloc] init], [[SHThirdTableViewController alloc] init]];
        
        SHTabScrollController *tabScrollController = [SHTabScrollController setupTitles:titles controllers:controllers tabIndexHandle:^(NSInteger index) {
            NSString *status = [NSString stringWithFormat:@"current tab is %ld", index];
            NSLog(@"%@", status);
            [self.topLabelButton setTitle:status forState:UIControlStateNormal];
        }];
        tabScrollController.tabTitleFont = [UIFont systemFontOfSize:15.f];
        tabScrollController.normalTitleColor = [UIColor purpleColor];
        tabScrollController.selectedTitleColor = [UIColor orangeColor];
        tabScrollController.normalTabBottomLineColor = [UIColor darkGrayColor];
        tabScrollController.selectedTabBottomLineColor = [UIColor orangeColor];
        [self addChildViewController:tabScrollController];
        tabScrollController.view.frame = CGRectMake(0, CGRectGetMaxY(self.topLabelButton.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(self.topLabelButton.frame));
        [self.view addSubview:tabScrollController.view];
    } else {
        NSArray *normalImages = @[@"tabNormal", @"tabNormal", @"tabNormal"];
        NSArray *highlightImages = @[@"tabHighlight", @"tabHighlight", @"tabHighlight"];
        NSArray *controllers = @[[[SHFirstTableViewController alloc] init], [[SHSecnodTableViewController alloc] init], [[SHThirdTableViewController alloc] init]];
        SHTabScrollController *tabScrollController = [SHTabScrollController setupNormalImages:normalImages highlightImages:highlightImages controllers:controllers tabIndexHandle:^(NSInteger index) {
            NSString *status = [NSString stringWithFormat:@"current tab is %ld", index];
            NSLog(@"%@", status);
            [self.topLabelButton setTitle:status forState:UIControlStateNormal];
        }];
        [self addChildViewController:tabScrollController];
        tabScrollController.view.frame = CGRectMake(0, CGRectGetMaxY(self.topLabelButton.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(self.topLabelButton.frame));
        [self.view addSubview:tabScrollController.view];
    }
}

- (void)dismissViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (SHButton *)topLabelButton {
    if (!_topLabelButton) {
        _topLabelButton = [[SHButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
        [_topLabelButton setTitle:@"Your custom top view" forState:UIControlStateNormal];
        [_topLabelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _topLabelButton.showShadowAnimation = NO;
        _topLabelButton.backgroundColor = [UIColor lightGrayColor];
        _topLabelButton.layer.borderWidth = 1.f;
        _topLabelButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [_topLabelButton addTarget:self action:@selector(dismissViewController) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topLabelButton;
}

@end
