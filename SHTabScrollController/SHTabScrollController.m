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

#define SH_DEFAULT_WIDTH (self.width ? : [UIScreen mainScreen].bounds.size.width)
#define SH_DEFAULT_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SH_CONTENT_WIDTH SH_DEFAULT_WIDTH * self.contentWidthScale

@interface SHTabScrollController () <UIScrollViewDelegate>

@property (nonatomic, copy) SHTabIndexHandle tabIndexHandle;
@property (nonatomic, strong) NSArray *tabButtonTitlesArray;
@property (nonatomic, strong, readwrite) NSMutableArray *tabButtonsArray;
@property (nonatomic, assign) NSInteger currenTabButtonIndex;
@property (nonatomic, strong) NSArray *controllersArray;
@property (nonatomic, assign) NSInteger currentControllerIndex;
@property (nonatomic, assign, getter=isUserTouched) BOOL userTouched;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) NSArray *normalImagesArray;
@property (nonatomic, strong) NSArray *highlightImagesArray;
@property (nonatomic, assign) SHTabButtonType tabButtonType;

@property (nonatomic, strong) NSMutableArray<NSNumber *> *tabButtonWidthArray;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *tabButtonTagArray;

@property (nonatomic, assign) NSInteger startSelectedIndex; /// 初始化选中tab

@end

@implementation SHTabScrollController

# pragma mark - initialization

+ (SHTabScrollController *)setupTitles:(NSArray *)titles controllers:(NSArray *)controllers {
    if (titles.count != controllers.count) {
        NSLog(@"Please checkout your dataSource, titles count is %ld, but controllers count is %ld", titles.count, controllers.count);
        return nil;
    }
    SHTabScrollController *tabScrollController = [[SHTabScrollController alloc] init];
    tabScrollController.tabButtonsFillScreenWidth = titles.count <= 3;
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
    tabScrollController.tabButtonsFillScreenWidth = normalImages.count <= 3;
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

+ (SHTabScrollController *)setupTabButtons:(NSArray *)tabButtons buttonsWidth:(NSArray *)buttonsWidth controllers:(NSArray *)controllers {
    if (buttonsWidth.count != controllers.count) {
        NSLog(@"Please checkout your dataSource, buttonsWidth count is %ld, but controllers count is %ld", buttonsWidth.count, controllers.count);
        return nil;
    }
    SHTabScrollController * tabScrollController = [[SHTabScrollController alloc] init];
    tabScrollController.tabButtonsFillScreenWidth = NO;
    tabScrollController.controllersArray = controllers;
    tabScrollController.tabButtonsArray = [tabButtons isKindOfClass:[NSArray class]] ? tabButtons.mutableCopy : tabButtons;
    tabScrollController.tabButtonWidthArray = [buttonsWidth isKindOfClass:[NSArray class]] ? buttonsWidth.mutableCopy : buttonsWidth;
    tabScrollController.tabButtonType = SHTabButtonTypeCustom;
    return tabScrollController;
}

+ (SHTabScrollController *)setupTabButtonTitlePadingInset:(CGFloat)padingInset
                                               tabButtons:(NSArray *)tabButtons
                                              controllers:(NSArray *)controllers
                                           tabIndexHandle:(SHTabIndexHandle)tabIndexHandle {
    NSMutableArray *buttonsWidth = @[].mutableCopy;
    for (UIButton *button in tabButtons) {
        CGSize titleSize = [button.titleLabel systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        CGSize imageSize = [button.imageView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        [buttonsWidth addObject:@(padingInset + titleSize.width + imageSize.width)];
    }
    return [SHTabScrollController setupTabButtons:tabButtons buttonsWidth:buttonsWidth controllers:controllers tabIndexHandle:tabIndexHandle];
}

+ (SHTabScrollController *)setupTabButtons:(NSArray *)tabButtons buttonsWidth:(NSArray *)buttonsWidth controllers:(NSArray *)controllers tabIndexHandle:(SHTabIndexHandle)tabIndexHandle {
    SHTabScrollController *tabScrollController = [SHTabScrollController setupTabButtons:tabButtons buttonsWidth:buttonsWidth controllers:controllers];
    if (tabIndexHandle) {
        tabScrollController.tabIndexHandle = tabIndexHandle;
    }
    return tabScrollController;
}

+ (SHTabScrollController *)setupTabButtons:(NSArray *)tabButtons
                              buttonsWidth:(NSArray *)buttonsWidth
                               controllers:(NSArray *)controllers
                             selectedIndex:(NSInteger)index
                            tabIndexHandle:(SHTabIndexHandle)tabIndexHandle {
    SHTabScrollController *tabScrollController = [SHTabScrollController setupTabButtons:tabButtons buttonsWidth:buttonsWidth controllers:controllers];
    tabScrollController.startSelectedIndex = index;
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
        self.tabButtonTitlePadding = 30.f;
        self.contentWidthScale = 1.f;
    }
    return self;
}

#pragma mark - Life Circle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupBackgroundViews];
    [self setupChildViewControllers];
    [self setupTabButtons];
    [self setupTabBottomView];
    [self setupScrollView];
    [self.view layoutIfNeeded];
    [self.view setNeedsLayout];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewWillLayoutSubviews {
    self.contentScrollView.frame = CGRectMake(0, CGRectGetMaxY(self.tabBottomView.frame), SH_CONTENT_WIDTH, self.view.bounds.size.height - _tabButtonHeight - _tabBottomViewHeight);
    self.contentScrollView.contentSize = CGSizeMake(SH_CONTENT_WIDTH * self.controllersArray.count, self.view.bounds.size.height - _tabButtonHeight - _tabBottomViewHeight);
    self.backgroundView.frame = self.view.bounds;
    self.contentBackgroundView.frame = CGRectMake(0, CGRectGetMaxY(self.tabBottomView.frame), SH_DEFAULT_WIDTH, self.view.bounds.size.height - self.tabButtonHeight);
    self.tabButtonBackgroundView.frame = CGRectMake(0, 0, SH_DEFAULT_WIDTH, CGRectGetMaxY(self.tabBottomView.frame));
    
    if (_startSelectedIndex > 0) {
        [self setChangedTabButtonIndex:_startSelectedIndex];
    }
}

#pragma mark - Setup Tab Button

- (void)setupTabButtons {
    self.tabButtonScrollView.frame = CGRectMake(0, 0, SH_DEFAULT_WIDTH, self.tabButtonHeight);
    [self.view addSubview:self.tabButtonScrollView];
    if (self.tabButtonType == SHTabButtonTypeOnlyTitle) {
        [self setupTabButtonsOnlyTitles];
    }
    if (self.tabButtonType == SHTabButtonTypeOnlyImage) {
        [self setupTabButtonsOnlyImages];
    }
    if (self.tabButtonType == SHTabButtonTypeCustom) {
        [self setupTabButtonsCustom];
    }
    self.currenTabButtonIndex = 0;
    if (self.tabButtonType == SHTabButtonTypeCustom) {
        return;
    }
    [self.tabButtonScrollView addSubview:self.lineView];
    [self.tabButtonsArray[0] updateButtonStatus];
}

- (void)setupTabButtonsOnlyTitles {
    __block CGFloat tabButtonFillWidth = SH_DEFAULT_WIDTH / self.tabButtonTitlesArray.count;
    __block CGFloat tabButtonScrollViewContentSizeWidth = 0;
    [self.tabButtonTitlesArray enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL * _Nonnull stop) {
        SHTabButton *tabButton = [[SHTabButton alloc] initWithTitle:title normalTitleColor:self.normalTitleColor selectedTitleColor:self.selectedTitleColor];
        if (self.tabTitleFont) {
            tabButton.defaultFont = self.tabTitleFont;
        }
        [self setupTabButtonColors:tabButton];
        CGFloat tabButtonWidth = 0;
        if (self.tabButtonsFillScreenWidth) {
            tabButtonWidth = tabButtonFillWidth;
        } else {
            tabButtonWidth = [tabButton systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].width + self.tabButtonTitlePadding;
        }
        self.tabButtonWidthArray[idx] = @(tabButtonWidth);
        tabButton.frame = CGRectMake(tabButtonScrollViewContentSizeWidth, 0, tabButtonWidth, self.tabButtonHeight);
        tabButton.tag = idx;
        [tabButton addTarget:self action:@selector(tabButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabButtonsArray addObject:tabButton];
        [self.tabButtonScrollView addSubview:tabButton];
        tabButtonScrollViewContentSizeWidth += tabButtonWidth;
    }];
    self.tabButtonScrollView.contentSize = CGSizeMake(tabButtonScrollViewContentSizeWidth, self.tabButtonHeight);
}

- (void)setupTabButtonsOnlyImages {
    __block CGFloat tabButtonFillWidth = SH_DEFAULT_WIDTH / self.normalImagesArray.count;
    __block CGFloat tabButtonScrollViewContentSizeWidth = 0;
    [self.normalImagesArray enumerateObjectsUsingBlock:^(NSString *image, NSUInteger idx, BOOL * _Nonnull stop) {
        SHTabButton *tabButton = [[SHTabButton alloc] initWithNormalImage:image highlightImage:self.highlightImagesArray[idx]];
        [self setupTabButtonColors:tabButton];
        CGFloat tabButtonWidth = 0;
        if (self.tabButtonsFillScreenWidth) {
            tabButtonWidth = tabButtonFillWidth;
        } else {
            tabButtonWidth = [tabButton systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].width + self.tabButtonTitlePadding;
        }
        self.tabButtonWidthArray[idx] = @(tabButtonWidth);
        tabButton.frame = CGRectMake(tabButtonScrollViewContentSizeWidth, 0, tabButtonWidth, self.tabButtonHeight);
        tabButton.tag = idx;
        [tabButton addTarget:self action:@selector(tabButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabButtonsArray addObject:tabButton];
        [self.tabButtonScrollView addSubview:tabButton];
        tabButtonScrollViewContentSizeWidth += tabButtonWidth;
    }];
    self.tabButtonScrollView.contentSize = CGSizeMake(tabButtonScrollViewContentSizeWidth, self.tabButtonHeight);
}

- (void)setupTabButtonsCustom {
    __block CGFloat tabButtonScrollViewContentSizeWidth = 0;
    if (self.skipControllerIndexs.count) {
        __block NSInteger skipCount = 0;
        [self.tabButtonsArray enumerateObjectsUsingBlock:^(SHButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([self.skipControllerIndexs containsObject:@(idx)]) {
                button.enabled = NO;
                skipCount++;
            } else {
                [button addTarget:self action:@selector(tabButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            }
            button.tag = idx - skipCount;
            CGFloat width = ((NSNumber *)self.tabButtonWidthArray[idx]).floatValue;
            button.frame =  CGRectMake(tabButtonScrollViewContentSizeWidth, 0, width, self.tabButtonHeight);
            [self.tabButtonScrollView addSubview:button];
            tabButtonScrollViewContentSizeWidth += width;
        }];
        
        NSMutableArray *needSkipButtons = @[].mutableCopy;
        for (NSNumber *skipIdx in self.skipControllerIndexs) {
            [needSkipButtons addObject:self.tabButtonsArray[skipIdx.integerValue]];
        }
        NSMutableArray *tempButtons = self.tabButtonsArray.mutableCopy;
        [tempButtons removeObjectsInArray:needSkipButtons];
        // self.tabButtonsArray = tempButtons;
        
        [self.skipControllerIndexs enumerateObjectsUsingBlock:^(NSNumber *skipIdx, NSUInteger idx, BOOL * _Nonnull stop) {
            if (skipIdx.integerValue) {
                NSInteger mergeWidth = self.tabButtonWidthArray[skipIdx.integerValue].integerValue + self.tabButtonWidthArray[skipIdx.integerValue - 1].integerValue;
                self.tabButtonWidthArray[skipIdx.integerValue - 1] = @(mergeWidth);
            }
        }];

        BOOL needMergeFirstTabButton = !self.skipControllerIndexs[0].integerValue;
        NSInteger firstTabButtonWidth;
        if (needMergeFirstTabButton) {
            firstTabButtonWidth = self.tabButtonWidthArray[0].integerValue;
        }
        
        NSMutableArray *needSkipButtonWidths = @[].mutableCopy;
        for (NSNumber *skipIdx in self.skipControllerIndexs) {
            [needSkipButtonWidths addObject:self.tabButtonWidthArray[skipIdx.integerValue]];
        }
        NSMutableArray<NSNumber *> *tempButtonWidths = self.tabButtonWidthArray.mutableCopy;
        [tempButtonWidths removeObjectsInArray:needSkipButtonWidths];

        if (needMergeFirstTabButton) {
            if (tempButtons.count == 1) {
                tempButtonWidths[0] = @(firstTabButtonWidth);
            } else {
                tempButtonWidths[0] = @(tempButtonWidths[0].integerValue + firstTabButtonWidth);
            }
        }
        
        for (int i = 0; i < self.tabButtonWidthArray.count; i++) {
            [self.tabButtonTagArray addObject:@(i)];
        }
        [self.tabButtonTagArray removeObjectsInArray:self.skipControllerIndexs];
        
        self.tabButtonWidthArray = tempButtonWidths;
        
    } else {
        [self.tabButtonsArray enumerateObjectsUsingBlock:^(SHButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
            button.tag = idx;
            CGFloat width = ((NSNumber *)self.tabButtonWidthArray[idx]).floatValue;
            button.frame =  CGRectMake(tabButtonScrollViewContentSizeWidth, 0, width, self.tabButtonHeight);
            [button addTarget:self action:@selector(tabButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self.tabButtonScrollView addSubview:button];
            tabButtonScrollViewContentSizeWidth += width;
        }];
    }
    self.tabButtonScrollView.contentSize = CGSizeMake(tabButtonScrollViewContentSizeWidth, self.tabButtonHeight);
}

- (void)setupTabButtonColors:(SHTabButton *)tabButton {
    if (self.normalTabBottomLineColor) {
        tabButton.normalBottomLineColor = self.normalTabBottomLineColor;
    }
    if (self.selectedTabBottomLineColor) {
        tabButton.selectedBottomLineColor = self.selectedTabBottomLineColor;
    }
    if (self.normalTabButtonBackgroundColor) {
        tabButton.normalBackgroundColor = self.normalTabButtonBackgroundColor;
    }
    if (self.selectedTabButtonbackgroundColor) {
        tabButton.selectedbackgroundColor = self.selectedTabButtonbackgroundColor;
    }
}

#pragma mark - Private API

- (void)setupBackgroundViews {
    [self.view addSubview:self.backgroundView];
    [self.backgroundView addSubview:self.contentBackgroundView];
    [self.backgroundView addSubview:self.tabButtonBackgroundView];
}

- (void)setupChildViewControllers {
    for (UIViewController *viewController in self.controllersArray) {
        [self addChildViewController:viewController];
    }
}

- (void)setupTabBottomView {
    self.tabBottomView.frame = CGRectMake(0, CGRectGetMaxY([(SHButton *)self.tabButtonsArray[0] frame]), SH_DEFAULT_WIDTH, self.tabBottomViewHeight);
    [self.view addSubview:self.tabBottomView];
}

- (void)setupScrollView {
    [self.view addSubview:self.contentScrollView];
    [self.controllersArray enumerateObjectsUsingBlock:^(UIViewController *controller, NSUInteger idx, BOOL * _Nonnull stop) {
        controller.view.frame = CGRectMake(SH_CONTENT_WIDTH * idx, 0, self.contentScrollView.bounds.size.width, self.contentScrollView.bounds.size.height);
        [self.contentScrollView addSubview:controller.view];
    }];
    self.currentControllerIndex = 0;
}

#pragma mark - Published API

- (void)setSkipControllerIndexs:(NSArray *)skipControllerIndexs {
    _skipControllerIndexs = skipControllerIndexs;
    if (!skipControllerIndexs.count) {
        return;
    }
    [self.skipControllerIndexs sortedArrayUsingComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
        return obj1.integerValue < obj2.integerValue;
    }];
    NSMutableArray *needSkipControllers = @[].mutableCopy;
    for (NSNumber *skipIdx in self.skipControllerIndexs) {
        [needSkipControllers addObject:self.controllersArray[skipIdx.integerValue]];
    }
    NSMutableArray *tempControllers = self.controllersArray.mutableCopy;
    [tempControllers removeObjectsInArray:needSkipControllers];
    self.controllersArray = tempControllers;
}

- (void)setNormalTitleColor:(UIColor *)normalTitleColor {
    _normalTitleColor = normalTitleColor;
    [SHColorUtils normalColor:normalTitleColor];
}

- (void)setSelectedTitleColor:(UIColor *)selectedTitleColor {
    _selectedTitleColor = selectedTitleColor;
    [SHColorUtils selectedColor:selectedTitleColor];
}

- (void)setNormalTabButtonBackgroundColor:(UIColor *)normalTabButtonBackgroundColor {
    _normalTabButtonBackgroundColor = normalTabButtonBackgroundColor;
    [SHColorUtils normalBackgroundColor:normalTabButtonBackgroundColor];
}

- (void)setSelectedTabButtonbackgroundColor:(UIColor *)selectedTabButtonbackgroundColor {
    _selectedTabButtonbackgroundColor = selectedTabButtonbackgroundColor;
    [SHColorUtils selectedBackgroundColor:selectedTabButtonbackgroundColor];
}

- (void)setChangedTabButtonIndex:(NSInteger)changedTabButtonIndex {
    if (changedTabButtonIndex == self.changedTabButtonIndex ||
        changedTabButtonIndex >= self.tabButtonsArray.count) {
        return;
    }
    _changedTabButtonIndex = changedTabButtonIndex;
    [self tabButtonPressed:self.tabButtonsArray[changedTabButtonIndex]];
}

#pragma mark - ScrollViewAnimation

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView != self.contentScrollView) {
        if (scrollView.contentOffset.x < -10.f) {
            scrollView.contentOffset = CGPointMake(-10.f, 0);
        }
        CGFloat maxContentOffsetX = self.tabButtonScrollView.contentSize.width - scrollView.frame.size.width + 10.f;
        if (scrollView.contentOffset.x > maxContentOffsetX) {
            scrollView.contentOffset = CGPointMake(maxContentOffsetX, 0);
        }
        return;
    }
    if (self.userTouched) {
        return;
    }
    self.lineView.hidden = NO;
    CGFloat value = ABS(scrollView.contentOffset.x / scrollView.frame.size.width);
    NSUInteger leftIndex = (int)value;
    NSUInteger rightIndex = leftIndex + 1;
    CGFloat scaleRight = value - leftIndex;
    CGFloat scaleLeft = 1 - scaleRight;
    if (self.tabButtonType != SHTabButtonTypeCustom) {
        SHTabButton *leftButton = self.tabButtonsArray[leftIndex];
        leftButton.animationValue = scaleLeft;
        if (rightIndex < self.tabButtonsArray.count && scrollView.contentOffset.x > 0) {
            SHTabButton *buttonRight = self.tabButtonsArray[rightIndex];
            buttonRight.animationValue = scaleRight;
        }
    }
    __block CGFloat leftTabWidth = 0.f;
    __block CGFloat delta = 0.f;
    __block CGFloat currentTabX = 0.f;
    __block CGFloat currentWidth = 0.f;
    __block CGFloat currentTabWidth = 0.f;
    [self.tabButtonWidthArray enumerateObjectsUsingBlock:^(NSNumber *width, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < leftIndex) {
            leftTabWidth += width.floatValue;
        }
        if (idx == leftIndex) {
            delta = (scrollView.contentOffset.x - scrollView.frame.size.width * leftIndex) / scrollView.frame.size.width;
            currentTabX = width.floatValue * delta + leftTabWidth;
            currentTabWidth = width.floatValue;
            if (idx == self.tabButtonWidthArray.count - 1) {
                currentWidth = width.floatValue * (1 - delta);
            } else {
                currentWidth = (width.floatValue - [(NSNumber *)self.tabButtonWidthArray[idx + 1] floatValue]) * (1 - delta) + [(NSNumber *)self.tabButtonWidthArray[idx + 1] floatValue];
            }
            *stop = YES;
        }
    }];
    if (self.tabButtonScrollView.contentOffset.x > leftTabWidth) {
        self.tabButtonScrollView.contentOffset = CGPointMake(leftTabWidth, 0);
    }
    if (self.tabButtonScrollView.contentOffset.x + self.tabButtonScrollView.frame.size.width < leftTabWidth + currentTabWidth) {
        self.tabButtonScrollView.contentOffset = CGPointMake(leftTabWidth + currentTabWidth - self.tabButtonScrollView.frame.size.width, 0);
    }
    if (self.tabButtonType != SHTabButtonTypeCustom) {
        self.lineView.frame = CGRectMake(currentTabX, self.tabButtonHeight - 2, currentWidth, 2);
    }
    if (currentTabX + currentWidth > self.tabButtonScrollView.frame.size.width) {
        self.tabButtonScrollView.contentOffset = CGPointMake(currentTabX + currentWidth - self.tabButtonScrollView.frame.size.width, 0);
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (scrollView != self.contentScrollView) {
        return;
    }
    if (self.tabButtonType != SHTabButtonTypeCustom) {
        self.lineView.hidden = YES;
    }
    if (self.userTouched) {
        self.userTouched = NO;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView != self.contentScrollView) {
        return;
    }
    if (self.tabButtonType != SHTabButtonTypeCustom) {
        self.lineView.hidden = YES;
    }
    
    CGFloat indexF = scrollView.contentOffset.x / self.contentScrollView.frame.size.width;
    NSInteger index = roundf(indexF);
    
    NSInteger didEndScrollButtonTag = index;
    if (didEndScrollButtonTag == self.currenTabButtonIndex && self.tabButtonType != SHTabButtonTypeCustom) {
        [self.tabButtonsArray[didEndScrollButtonTag] setupCurrentLineColor];
        return;
    }
    if (self.tabIndexHandle) {
        if (self.skipControllerIndexs.count) {
            self.tabIndexHandle(self.tabButtonTagArray[didEndScrollButtonTag].integerValue);
        } else {
            self.tabIndexHandle(didEndScrollButtonTag);
        }
    }
    if (self.tabButtonType != SHTabButtonTypeCustom) {
        [self.tabButtonsArray[self.currenTabButtonIndex] updateButtonStatus];
        [self.tabButtonsArray[didEndScrollButtonTag] updateButtonStatus];
    }
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
    if (self.tabButtonType != SHTabButtonTypeCustom) {
        [self.tabButtonsArray[self.currenTabButtonIndex] updateButtonStatus];
        [button updateButtonStatus];
    }
    self.currenTabButtonIndex = button.tag;
    if (self.tabIndexHandle) {
        if (self.skipControllerIndexs.count) {
            self.tabIndexHandle(self.tabButtonTagArray[button.tag].integerValue);
        } else {
            self.tabIndexHandle(button.tag);
        }
    }
    if (self.tabButtonsFillScreenWidth) {
        return;
    }
    __block CGFloat leftTabWidth = 0.f;
    __block CGFloat currentTabWidth = 0.f;
    [self.tabButtonWidthArray enumerateObjectsUsingBlock:^(NSNumber *width, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < button.tag) {
            leftTabWidth += width.floatValue;
        }
        if (idx == button.tag) {
            currentTabWidth = width.floatValue;
            *stop = YES;
        }
    }];
    if (self.tabButtonScrollView.contentOffset.x > leftTabWidth) {
        self.tabButtonScrollView.contentOffset = CGPointMake(leftTabWidth, 0);
    }
    if (self.tabButtonScrollView.contentOffset.x + self.tabButtonScrollView.frame.size.width < leftTabWidth + currentTabWidth) {
        self.tabButtonScrollView.contentOffset = CGPointMake(leftTabWidth + currentTabWidth - self.tabButtonScrollView.frame.size.width, 0);
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

- (SHScrollView *)tabButtonScrollView {
    if (!_tabButtonScrollView) {
        _tabButtonScrollView = [[SHScrollView alloc] init];
        _tabButtonScrollView.pagingEnabled = NO;
        _tabButtonScrollView.scrollsToTop = NO;
        _tabButtonScrollView.delegate = self;
    }
    return _tabButtonScrollView;
}

- (NSMutableArray *)tabButtonWidthArray {
    if (!_tabButtonWidthArray) {
        _tabButtonWidthArray = [NSMutableArray array];
    }
    return _tabButtonWidthArray;
}

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
    }
    return _backgroundView;
}

- (UIView *)contentBackgroundView {
    if (!_contentBackgroundView) {
        _contentBackgroundView = [[UIView alloc] init];
    }
    return _contentBackgroundView;
}

- (UIView *)tabButtonBackgroundView {
    if (!_tabButtonBackgroundView) {
        _tabButtonBackgroundView = [[UIView alloc] init];
    }
    return _tabButtonBackgroundView;
}

- (NSMutableArray<NSNumber *> *)tabButtonTagArray {
    if (!_tabButtonTagArray) {
        _tabButtonTagArray = @[].mutableCopy;
    }
    return _tabButtonTagArray;
}

@end
