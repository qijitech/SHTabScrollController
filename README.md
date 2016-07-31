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
pod 'SHTabScrollController'
```

and run `pod install`, then you're all done!

## How to use

```objc
NSArray *titles = @[@"tab0", @"tab1", @"tab2"];
NSArray *controllers = @[[[YourViewController alloc] init], [[YourViewController alloc] init], [[YourViewController alloc] init]];

SHTabScrollController *tabScrollController = [SHTabScrollController setupTitles:titles controllers:controllers tabIndexHandle:^(NSInteger index) {
    do your code ...
}];
```

## Summary

A simple view controller with tab button and childViewController, inspired by Netease News.

Will add more custom option in next version.

Tab button had had some animation and childViewController can be scroll.

Enjoy yourself.

custom

```objc
// default is 40.0
@property (nonatomic, assign) CGFloat tabButtonHeight;
```


## Requirements

* iOS 8.0+ 
* ARC

## Author

@harushuu, hunter4n@gmail.com

## License

English: SHTabScrollController is available under the MIT license, see the LICENSE file for more information.     

