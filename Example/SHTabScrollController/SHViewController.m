//
//  SHViewController.m
//  SHTabScrollController
//
//  Created by @harushuu on 07/30/2016.
//  Copyright (c) 2016 @harushuu. All rights reserved.
//

#import "SHViewController.h"
#import <SHTabScrollController/SHTabScrollController.h>
#import "SHTableViewController.h"
#import <SHButton/SHButton.h>

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface SHViewController ()
@property (nonatomic, strong) SHButton *topLabelButton;
@property (nonatomic, assign) BOOL onlyImage;
@property (nonatomic, assign) BOOL custom;
@property (nonatomic, strong) NSMutableArray *buttons;

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

- (instancetype)initWithCustom {
    if (self = [super init]) {
        self.custom = YES;
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

- (void)changedButtonAnimation:(NSInteger)index {
    [self.buttons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx != 1 && idx != 3) {
            NSLog(@"index %ld -- button.tag %ld -- selected %d", index, button.tag, button.tag == index);
            UIColor *currentColor = idx == index ? [UIColor blackColor] : [UIColor redColor];
            UIColor *backGroundColor = idx == index ? [UIColor lightGrayColor] : [UIColor whiteColor];
            button.backgroundColor = backGroundColor;
            [button setTitleColor:currentColor forState:UIControlStateNormal];
        }
    }];
}

- (void)setupTabScrollController {
    if (self.custom) {
        self.buttons = [NSMutableArray array];
        NSMutableArray *widths = [NSMutableArray array];
        for (int i = 0; i < 6; i++) {
            SHButton *button = [[SHButton alloc] init];
            button.tag = i;
            [button setTitle:[NSString stringWithFormat:@"tab %d", i] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"tabNormal"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            button.backgroundColor = [UIColor whiteColor];
            self.buttons[i] = button;
            widths[i] = @(50 + i * 30);
        }
        NSArray *controllers = @[[[SHTableViewController alloc] init], [[SHTableViewController alloc] init], [[SHTableViewController alloc] init], [[SHTableViewController alloc] init], [[SHTableViewController alloc] init], [[SHTableViewController alloc] init]];
        __weak SHViewController *weakSelf = self;
        SHTabScrollController *tabScrollController = [SHTabScrollController setupTabButtonTitlePadingInset:15.f tabButtons:self.buttons controllers:controllers tabIndexHandle:^(NSInteger index) {
            NSString *status = [NSString stringWithFormat:@"current tab is %ld", index];
            NSLog(@"%@", status);
            [weakSelf.topLabelButton setTitle:status forState:UIControlStateNormal];
            [weakSelf changedButtonAnimation:index];
        }];
        tabScrollController.contentWidthScale = 0.7;
        tabScrollController.skipControllerIndexs = @[@1, @3];
        [self addChildViewController:tabScrollController];
        tabScrollController.view.frame = CGRectMake(0, CGRectGetMaxY(self.topLabelButton.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(self.topLabelButton.frame));
        [self.view addSubview:tabScrollController.view];
//        tabScrollController.changedTabButtonIndex = 2;
        return;
    }
    if (!self.onlyImage) {
        NSArray *titles = @[@"tab0", @"tab1_tab1", @"tab2", @"tab3_tab3_tab3_tab3", @"tab4", @"tab5_tab5_tab5"];
        NSArray *controllers = @[[[SHTableViewController alloc] init], [[SHTableViewController alloc] init], [[SHTableViewController alloc] init], [[SHTableViewController alloc] init], [[SHTableViewController alloc] init], [[SHTableViewController alloc] init]];
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
        NSArray *controllers = @[[[SHTableViewController alloc] init], [[SHTableViewController alloc] init], [[SHTableViewController alloc] init]];
        SHTabScrollController *tabScrollController = [SHTabScrollController setupNormalImages:normalImages highlightImages:highlightImages controllers:controllers tabIndexHandle:^(NSInteger index) {
            NSString *status = [NSString stringWithFormat:@"current tab is %ld", index];
            NSLog(@"%@", status);
            [self.topLabelButton setTitle:status forState:UIControlStateNormal];
        }];
        tabScrollController.tabBottomViewHeight = 30.f;
        UILabel *detailLabel = [[UILabel alloc] init];
        detailLabel.text = @"you can custom this view, can hidden this yet";
        detailLabel.textAlignment = NSTextAlignmentCenter;
        detailLabel.textColor = [UIColor blackColor];
        detailLabel.backgroundColor = [UIColor lightGrayColor];
        tabScrollController.tabBottomView = detailLabel;
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
