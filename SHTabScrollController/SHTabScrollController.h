//
//  SHTabScrollController.h
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


#import <UIKit/UIKit.h>

typedef void(^SHTabIndexHandle)(NSInteger index);
@class SHScrollView;

@interface SHTabScrollController : UIViewController

// default is blackColor
@property (nonatomic, strong) UIColor *normalTitleColor;

// default is redColor
@property (nonatomic, strong) UIColor *selectedTitleColor;

// default is [UIColor colorWithRed:53.f/255.f green:53.f/255.f blue:53.f/255.f alpha:1.f],
// which likes a kind of blackColor
@property (nonatomic, strong) UIColor *normalTabBottomLineColor;

// default is [UIColor colorWithRed:205.f/255.f green:67.f/255.f blue:67.f/255.f alpha:1.f],
// which likes a kind of redColor
@property (nonatomic, strong) UIColor *selectedTabBottomLineColor;

// default is 40.0
@property (nonatomic, assign) CGFloat tabButtonHeight;

// default is nil (system font 17 plain)
@property (nonatomic, strong) UIFont *tabTitleFont;

// default is 0.f height, if you need some custom view, you can implementation this,
@property (nonatomic, strong) UIView *tabBottomView;

// default is 0.f height, if you need some custom view, you can changed this,
@property (nonatomic, assign) CGFloat tabBottomViewHeight;

// default is nil
@property (nonatomic, strong) UIColor *normalTabButtonBackgroundColor;

// default is nil
@property (nonatomic, strong) UIColor *selectedTabButtonbackgroundColor;

// default tabButtonFillScreenWidth = tab button items count <= 3
// if YES, tab button width = screen width / 3.
// if NO, tab button width = title width + tabButtonPadding.
@property (nonatomic, assign) BOOL tabButtonsFillScreenWidth;

// only available if tabButtonsFillScreenWidth = NO; default is 30.f,
@property (nonatomic, assign) CGFloat tabButtonTitlePadding;

// default init method with titles, do not care about switch controllers,
// will auto switch when tap or scroll
+ (SHTabScrollController *)setupTitles:(NSArray *)titles
                           controllers:(NSArray *)controllers;

// if you wanna to get current tab index, you should call this method
+ (SHTabScrollController *)setupTitles:(NSArray *)titles
                           controllers:(NSArray *)controllers
                        tabIndexHandle:(SHTabIndexHandle)tabIndexHandle;

// default init method with images, do not care about switch controllers,
// will auto switch when tap or scroll
+ (SHTabScrollController *)setupNormalImages:(NSArray *)normalImages
                              highlightImages:(NSArray *)highlightImages
                                 controllers:(NSArray *)controllers;

// if you wanna to get current tab index, you should call this method
+ (SHTabScrollController *)setupNormalImages:(NSArray *)normalImages
                             highlightImages:(NSArray *)highlightImages
                                 controllers:(NSArray *)controllers
                              tabIndexHandle:(SHTabIndexHandle)tabIndexHandle;

/*---- bottom method just test ----*/
@property (nonatomic, strong) SHScrollView *contentScrollView;

// default init method with custom button, do not care about switch controllers,
// will auto switch when tap or scroll
// in this method, all tab button change animation will hidden. But will show in next version ^_^.
// if used SHButton, will had a good animation for touch action.
// will auto calculate width in next version if buttonsWidth array is nil.
+ (SHTabScrollController *)setupTabButtons:(NSArray *)tabButtons
                              buttonsWidth:(NSArray *)buttonsWidth // @[@10.f, @20.f, ....];
                               controllers:(NSArray *)controllers;

// if you need custom full tab button, you should call this method
// in this method, all tab button change animation will hidden. But will show in next version ^_^.
// if used SHButton, will had a good animation for touch action.
// will auto calculate width in next version if buttonsWidth array is nil.
+ (SHTabScrollController *)setupTabButtons:(NSArray *)tabButtons
                              buttonsWidth:(NSArray *)buttonsWidth // @[@10.f, @20.f, ....];
                               controllers:(NSArray *)controllers
                            tabIndexHandle:(SHTabIndexHandle)tabIndexHandle;

@end
