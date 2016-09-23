//
//  SHTabScrollController.m
//  SHTabScrollController
//
//  Created by shuu on 7/30/16.
//  Copyright (c) 2016 @harushuu. All rights reserved.
//
// The MIT License (MIT)
//
// Copyright (c) 2016 @harushuu
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in
// the Software without restriction, including without limitation the rights to
// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
// the Software, and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


#import "SHTabScrollController.h"
#import "SHScrollView.h"
#import "SHTabButton.h"
#import "SHColorUtils.h"
#import <SHButton/SHButton.h>
#import "SHTypeHeader.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface SHTabScrollController () <UIScrollViewDelegate>

@property (nonatomic, copy) SHTabIndexHandle tabIndexHandle;
@property (nonatomic, strong) NSArray *tabButtonTitlesArray;
@property (nonatomic, strong) NSMutableArray *tabButtonsArray;
@property (nonatomic, assign) NSInteger currenTabButtonIndex;
@property (nonatomic, strong) NSArray *controllersArray;
@property (nonatomic, assign) NSInteger currentControllerIndex;
@property (nonatomic, strong) SHScrollView *contentScrollView;
@property (nonatomic, assign, getter=isUserTouched) BOOL userTouched;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) NSArray *normalImagesArray;
@property (nonatomic, strong) NSArray *highlightImagesArray;
@property (nonatomic, assign) SHTabButtonType tabButtonType;

@end

@implementation SHTabScrollController

# pragma mark - initialization

+ (SHTabScrollController *)setupTitles:(NSArray *)titles controllers:(NSArray *)controllers {
    if (titles.count != controllers.count) {
        NSLog(@"Please checkout your dataSource, titles count is %ld, but controllers count is %ld", titles.count, controllers.count);
        return nil;
    }
    SHTabScrollController *tabScrollController = [[SHTabScrollController alloc] init];
    tabScrollController.controllersArray = controllers;
    tabScrollController.tabButtonTitlesArray = titles;
    tabScrollController.tabButtonType = SHTabButtonTypeOnlyTitle;
    return tabScrollController;
}

+ (SHTabScrollController *)setupTitles:(NSArray *)titles controllers:(NSArray *)controllers tabIndexHandle:(SHTabIndexHandle)tabIndexHandle {
    SHTabScrollController *tabScrollController = [SHTabScrollController setupTitles:titles controllers:controllers];
    if (tabIndexHandle) {
        tabScrollController.tabIndexHandle = tabIndexHandle;
    }
    return tabScrollController;
}

+ (SHTabScrollController *)setupNormalImages:(NSArray *)normalImages highlightImages:(NSArray *)highlightImages controllers:(NSArray *)controllers {
    if (normalImages.count != controllers.count) {
        NSLog(@"Please checkout your dataSource, normalImages count is %ld, but controllers count is %ld", normalImages.count, controllers.count);
        return nil;
    }
    if (!highlightImages.count) {
        highlightImages = normalImages;
    }
    if (highlightImages.count != normalImages.count) {
        NSLog(@"Please checkout your dataSource, normalImages count is %ld, but highlightImages count is %ld", normalImages.count, highlightImages.count);
        return nil;
    }
    SHTabScrollController * tabScrollController = [[SHTabScrollController alloc] init];
    tabScrollController.controllersArray = controllers;
    tabScrollController.normalImagesArray = normalImages;
    tabScrollController.highlightImagesArray = highlightImages;
    tabScrollController.tabButtonType = SHTabButtonTypeOnlyImage;
    return tabScrollController;
}

+ (SHTabScrollController *)setupNormalImages:(NSArray *)normalImages highlightImages:(NSArray *)highlightImages controllers:(NSArray *)controllers tabIndexHandle:(SHTabIndexHandle)tabIndexHandle {
    SHTabScrollController *tabScrollController = [SHTabScrollController setupNormalImages:normalImages highlightImages:highlightImages controllers:controllers];
    if (tabIndexHandle) {
        tabScrollController.tabIndexHandle = tabIndexHandle;
    }
    return tabScrollController;
}

- (instancetype)init {
    if (self = [super init]) {
        self.normalTitleColor = [UIColor blackColor];
        self.selectedTitleColor = [UIColor redColor];
        self.tabButtonHeight = 40.f;
        self.tabBottomViewHeight = 0.f;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupChildViewControllers];
    [self setupTabButtons];
    [self setupTabBottomView];
    [self setupScrollView];
}

- (void)viewWillLayoutSubviews {
    self.contentScrollView.frame = CGRectMake(0, self.tabButtonHeight + self.tabBottomViewHeight, SCREEN_WIDTH, self.view.bounds.size.height - self.tabButtonHeight);
    self.contentScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * self.controllersArray.count, self.view.bounds.size.height - self.tabButtonHeight);
}

#pragma mark - Private API

- (void)setupChildViewControllers {
    for (UIViewController *viewController in self.controllersArray) {
        [self addChildViewController:viewController];
    }
}

- (void)setupTabButtons {
    if (self.tabButtonType == SHTabButtonTypeOnlyTitle) {
        __block CGFloat tabButtonWidth = SCREEN_WIDTH / self.tabButtonTitlesArray.count;
        [self.tabButtonTitlesArray enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL * _Nonnull stop) {
            SHTabButton *tabButton = [[SHTabButton alloc] initWithTitle:title normalTitleColor:self.normalTitleColor selectedTitleColor:self.selectedTitleColor];
            if (self.tabTitleFont) {
                tabButton.defaultFont = self.tabTitleFont;
            }
            if (self.normalTabBottomLineColor) {
                tabButton.normalBottomLineColor = self.normalTabBottomLineColor;
            }
            if (self.selectedTabBottomLineColor) {
                tabButton.selectedBottomLineColor = self.selectedTabBottomLineColor;
            }
            tabButton.frame = CGRectMake(tabButtonWidth * idx, 0, tabButtonWidth, self.tabButtonHeight);
            tabButton.tag = idx;
            [tabButton addTarget:self action:@selector(tabButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self.tabButtonsArray addObject:tabButton];
            [self.view addSubview:tabButton];
        }];
    }
    
    if (self.tabButtonType == SHTabButtonTypeOnlyImage) {
        __block CGFloat tabButtonWidth = SCREEN_WIDTH / self.normalImagesArray.count;
        [self.normalImagesArray enumerateObjectsUsingBlock:^(NSString *image, NSUInteger idx, BOOL * _Nonnull stop) {
            SHTabButton *tabButton = [[SHTabButton alloc] initWithNormalImage:image highlightImage:self.highlightImagesArray[idx]];
            tabButton.frame = CGRectMake(tabButtonWidth * idx, 0, tabButtonWidth, self.tabButtonHeight);
            tabButton.tag = idx;
            [tabButton addTarget:self action:@selector(tabButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self.tabButtonsArray addObject:tabButton];
            [self.view addSubview:tabButton];
        }];
    }
    self.currenTabButtonIndex = 0;
    [self.view addSubview:self.lineView];
    [self.tabButtonsArray[0] updateButtonStatus];
}

- (void)setupTabBottomView {
    self.tabBottomView.frame = CGRectMake(0, CGRectGetMaxY([(SHButton *)self.tabButtonsArray[0] frame]), SCREEN_WIDTH, self.tabBottomViewHeight);
    [self.view addSubview:self.tabBottomView];
}

- (void)setupScrollView {
    [self.view addSubview:self.contentScrollView];
    [self.controllersArray enumerateObjectsUsingBlock:^(UIViewController *controller, NSUInteger idx, BOOL * _Nonnull stop) {
        controller.view.frame = CGRectMake(SCREEN_WIDTH * idx, 0, self.contentScrollView.bounds.size.width, self.contentScrollView.bounds.size.height);
        [self.contentScrollView addSubview:controller.view];
    }];
    self.currentControllerIndex = 0;
}

- (void)setNormalTitleColor:(UIColor *)normalTitleColor {
    _normalTitleColor = normalTitleColor;
    [SHColorUtils normalColor:normalTitleColor];
}

- (void)setSelectedTitleColor:(UIColor *)selectedTitleColor {
    _selectedTitleColor = selectedTitleColor;
    [SHColorUtils selectedColor:selectedTitleColor];
}

#pragma mark - Published API

#pragma mark - ScrollViewAnimation

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.userTouched) {
        return;
    }
    self.lineView.hidden = NO;
    CGFloat value = ABS(scrollView.contentOffset.x / scrollView.frame.size.width);
    NSUInteger leftIndex = (int)value;
    NSUInteger rightIndex = leftIndex + 1;
    CGFloat scaleRight = value - leftIndex;
    CGFloat scaleLeft = 1 - scaleRight;
    SHTabButton *leftButton = self.tabButtonsArray[leftIndex];
    leftButton.animationValue = scaleLeft;
    if (rightIndex < self.tabButtonsArray.count && scrollView.contentOffset.x > 0) {
        SHTabButton *buttonRight = self.tabButtonsArray[rightIndex];
        buttonRight.animationValue = scaleRight;
    }
    self.lineView.frame = CGRectMake(scrollView.contentOffset.x / self.tabButtonsArray.count, self.tabButtonHeight - 2, SCREEN_WIDTH / 3, 2);
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    self.lineView.hidden = YES;
    if (self.userTouched) {
        self.userTouched = NO;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.lineView.hidden = YES;
    NSUInteger index = scrollView.contentOffset.x / self.contentScrollView.frame.size.width;
    NSInteger didEndScrollButtonTag = index;
    if (didEndScrollButtonTag == self.currenTabButtonIndex) {
        [self.tabButtonsArray[didEndScrollButtonTag] setupCurrentLineColor];
        return;
    }
    if (self.tabIndexHandle) {
        self.tabIndexHandle(didEndScrollButtonTag);
    }
    [self.tabButtonsArray[self.currenTabButtonIndex] updateButtonStatus];
    [self.tabButtonsArray[didEndScrollButtonTag] updateButtonStatus];
    self.currenTabButtonIndex = didEndScrollButtonTag;
}

#pragma mark - Button Action

- (void)tabButtonPressed:(SHTabButton *)button {
    if (button.tag == self.currenTabButtonIndex) return;
    self.userTouched = YES;
    CGFloat offsetX = button.tag * self.contentScrollView.frame.size.width;
    CGFloat offsetY = self.contentScrollView.contentOffset.y;
    CGPoint offset = CGPointMake(offsetX, offsetY);
    [self.contentScrollView setContentOffset:offset animated:YES];
    [self.tabButtonsArray[self.currenTabButtonIndex] updateButtonStatus];
    [button updateButtonStatus];
    self.currenTabButtonIndex = button.tag;
    if (self.tabIndexHandle) {
        self.tabIndexHandle(button.tag);
    }
}

#pragma mark - Lazyload

- (SHScrollView *)contentScrollView {
    if (!_contentScrollView) {
        _contentScrollView = [[SHScrollView alloc] init];
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.scrollsToTop = NO;
        _contentScrollView.delegate = self;
    }
    return _contentScrollView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.tabButtonHeight - 2, self.view.bounds.size.width / self.tabButtonsArray.count, 2)];
        _lineView.backgroundColor = self.selectedTabBottomLineColor ? :REDCOLOR;
        _lineView.hidden = YES;
    }
    return _lineView;
}

- (NSMutableArray *)tabButtonsArray {
    if (!_tabButtonsArray) {
        _tabButtonsArray = [NSMutableArray array];
    }
    return _tabButtonsArray;
}

- (UIView *)tabBottomView {
    if (!_tabBottomView) {
        _tabBottomView = [[UIView alloc] init];
    }
    return _tabBottomView;
}

@end
