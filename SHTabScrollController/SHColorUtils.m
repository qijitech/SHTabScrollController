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

+ (UIColor *)transitionColors:(CGFloat)animationValue {
    CIColor *normalColor = [SHColorUtils sharedInstance].normalColor;
    CIColor *selectedColor = [SHColorUtils sharedInstance].selectedColor;
    CGFloat redDelta = (selectedColor.red - normalColor.red) * animationValue + normalColor.red;
    CGFloat greenDelta = (selectedColor.green - normalColor.green) * animationValue + normalColor.green;
    CGFloat blueDelta = (selectedColor.blue - normalColor.blue) * animationValue + normalColor.blue;
    CGFloat alphaDelta = (selectedColor.alpha - normalColor.alpha) * animationValue + normalColor.alpha;
    UIColor *currentColor = [UIColor colorWithRed:redDelta green:greenDelta blue:blueDelta alpha:alphaDelta];
    return currentColor;
}


@end
