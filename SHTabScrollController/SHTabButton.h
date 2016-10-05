//
//  SHTabButton.h
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


#import <SHButton/SHButton.h>

#define LINECOLOR [UIColor colorWithRed:53.f/255.f green:53.f/255.f blue:53.f/255.f alpha:1.f]
#define REDCOLOR [UIColor colorWithRed:205.f/255.f green:67.f/255.f blue:67.f/255.f alpha:1.f]

@interface SHTabButton : SHButton

@property (nonatomic, assign) CGFloat animationValue;
@property (nonatomic, strong) UIFont *defaultFont;
@property (nonatomic, strong) UIColor *normalBottomLineColor;
@property (nonatomic, strong) UIColor *selectedBottomLineColor;
@property (nonatomic, strong) UIColor *normalBackgroundColor;
@property (nonatomic, strong) UIColor *selectedbackgroundColor;

- (instancetype)initWithTitle:(NSString *)title
             normalTitleColor:(UIColor *)normalTitleColor
           selectedTitleColor:(UIColor *)selectedTitleColor;

- (instancetype)initWithNormalImage:(NSString *)normalImage
                     highlightImage:(NSString *)highlightImage;


- (void)updateButtonStatus;
- (void)setupCurrentLineColor;

@end
