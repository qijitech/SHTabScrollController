//
//  SHColorUtils.m
//  SHTabScrollController
//
//  Created by shuu on 8/21/16.
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


#import "SHColorUtils.h"

@interface SHColorUtils ()

@property (nonatomic, strong) CIColor *normalColor;
@property (nonatomic, strong) CIColor *selectedColor;

@property (nonatomic, strong) CIColor *normalBackgroundColor;
@property (nonatomic, strong) CIColor *selectedBackgroundColor;

@end

@implementation SHColorUtils

+ (SHColorUtils *)sharedInstance {
    static SHColorUtils *_sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
    _sharedInstance = [[SHColorUtils alloc] init];
    });
    return _sharedInstance;
}

+ (void)normalColor:(UIColor *)normalColor {
    [SHColorUtils sharedInstance].normalColor = [CIColor colorWithCGColor:normalColor.CGColor];
}

+ (void)selectedColor:(UIColor *)selectedColor {
    [SHColorUtils sharedInstance].selectedColor = [CIColor colorWithCGColor:selectedColor.CGColor];
}

+ (void)normalBackgroundColor:(UIColor *)normalBackgroundColor {
    [SHColorUtils sharedInstance].normalBackgroundColor = [CIColor colorWithCGColor:normalBackgroundColor.CGColor];
}

+ (void)selectedBackgroundColor:(UIColor *)selectedBackgroundColor {
    [SHColorUtils sharedInstance].selectedBackgroundColor = [CIColor colorWithCGColor:selectedBackgroundColor.CGColor];
}

+ (UIColor *)transitionFromColor:(CIColor *)fromColor toColor:(CIColor *)toColor animationValue:(CGFloat)animationValue {
    CGFloat redDelta = (toColor.red - fromColor.red) * animationValue + fromColor.red;
    CGFloat greenDelta = (toColor.green - fromColor.green) * animationValue + fromColor.green;
    CGFloat blueDelta = (toColor.blue - fromColor.blue) * animationValue + fromColor.blue;
    CGFloat alphaDelta = (toColor.alpha - fromColor.alpha) * animationValue + fromColor.alpha;
    UIColor *currentColor = [UIColor colorWithRed:redDelta green:greenDelta blue:blueDelta alpha:alphaDelta];
    return currentColor;
}

+ (UIColor *)transitionColors:(CGFloat)animationValue {
    return [SHColorUtils transitionFromColor:[SHColorUtils sharedInstance].normalColor
                                     toColor:[SHColorUtils sharedInstance].selectedColor
                              animationValue:animationValue];
}

+ (UIColor *)transitionBackgroundColors:(CGFloat)animationValue {
    return [SHColorUtils transitionFromColor:[SHColorUtils sharedInstance].normalBackgroundColor
                                     toColor:[SHColorUtils sharedInstance].selectedBackgroundColor
                              animationValue:animationValue];
}


@end
