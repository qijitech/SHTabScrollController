# SHTabScrollController

[![CI Status](http://img.shields.io/travis/@harushuu/SHTabScrollController.svg?style=flat)](https://travis-ci.org/@harushuu/SHTabScrollController)
[![Version](https://img.shields.io/cocoapods/v/SHTabScrollController.svg?style=flat)](http://cocoapods.org/pods/SHTabScrollController)
[![License](https://img.shields.io/cocoapods/l/SHTabScrollController.svg?style=flat)](http://cocoapods.org/pods/SHTabScrollController)
[![Platform](https://img.shields.io/cocoapods/p/SHTabScrollController.svg?style=flat)](http://cocoapods.org/pods/SHTabScrollController)

## Screenshots
![image](https://github.com/harushuu/SHTabScrollController/raw/master/Screenshots.gif)

## Installation
 
With [CocoaPods](http://cocoapods.org/), add this line to your `Podfile`.

```
pod 'SHTabScrollController', '~> 0.4.16'
```

and run `pod install`, then you're all done!

## How to use

```objc

// init with title

NSArray *titles = @[@"tab0", @"tab1", @"tab2"];
NSArray *controllers = @[[[YourViewController alloc] init], 
                         [[YourViewController alloc] init], 
                         [[YourViewController alloc] init]];

// default init method, do not care about switch controllers, 
// will auto switch current controller when tap or scroll
SHTabScrollController *tabScrollController = [SHTabScrollController setupTitles:titles 
                                                                    controllers:controllers];


// init with image

NSArray *normalImages = @[@"tabNormal", @"tabNormal", @"tabNormal"];
NSArray *highlightImages = @[@"tabHighlight", @"tabHighlight", @"tabHighlight"];
NSArray *controllers = @[[[YourViewController alloc] init], 
                        [[YourViewController alloc] init], 
                        [[YourViewController alloc] init]];

// default init method with images, do not care about switch controllers,
// will auto switch when tap or scroll
+ (SHTabScrollController *)setupNormalImages:(NSArray *)normalImages
                             highlightImages:(NSArray *)highlightImages
                                 controllers:(NSArray *)controllers;

```

## Summary

A simple view controller with tab button and childViewController

Tab button has some animation and childViewController can be scroll.

Will support scroll tab button in next version.

Enjoy yourself!

###custom

```objc
// init with title

// if you wanna to get current tab index, you should call this method
+ (SHTabScrollController *)setupTitles:(NSArray *)titles 
                           controllers:(NSArray *)controllers 
                        tabIndexHandle:(SHTabIndexHandle)tabIndexHandle;

// init with image

// if you wanna to get current tab index, you should call this method
+ (SHTabScrollController *)setupNormalImages:(NSArray *)normalImages
                             highlightImages:(NSArray *)highlightImages
                                 controllers:(NSArray *)controllers
                              tabIndexHandle:(SHTabIndexHandle)tabIndexHandle;

// the background view will be automatically resized to track the size of the view. this will be placed as a subview of the view behind all subViews.  default may be non-nil for some devices.
@property (nonatomic, strong) UIView *contentBackgroundView;
@property (nonatomic, strong) UIView *tabButtonBackgroundView;
@property (nonatomic, strong) UIView *backgroundView;

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

// only available if tabButtonsFillScreenWidth = NO; default is 40.f,
@property (nonatomic, assign) CGFloat tabButtonTitlePadding;

// default is nil, equal to self.view.frame.size.width
@property (nonatomic, assign) CGFloat width;

// default is nil, set this property if you wanna changed selected TabButton
@property (nonatomic, assign) NSInteger changedTabButtonIndex;



/*---- bottom method just test ----*/
@property (nonatomic, strong) SHScrollView *contentScrollView;
@property (nonatomic, strong) SHScrollView *tabButtonScrollView;

// just test, only support custom tabButtons
// invoke this method after init;
// setup skip controler index, like @[@0, @2];
@property (nonatomic, strong) NSArray *skipControllerIndexs;

// just test, only reset controller.view.width
// invoke this method after init, please;
@property (nonatomic, assign) CGFloat contentWidthScale;

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

```

## Requirements

* iOS 8.0+ 
* ARC

## Author

@harushuu, hunter4n@gmail.com

## License

English: SHTabScrollController is available under the MIT license, see the LICENSE file for more information.     

