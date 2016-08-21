//
//  SHTabButton.m
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


#import "SHTabButton.h"
#import "SHColorUtils.h"

@interface SHTabButton ()

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIColor *normalTitleColor;
@property (nonatomic, strong) UIColor *selectedTitleColor;
@property (nonatomic, assign, getter=isSelectedStatus) BOOL selectedStatus;

@end

@implementation SHTabButton

- (instancetype)initWithTitle:(NSString *)title normalTitleColor:(UIColor *)normalTitleColor selectedTitleColor:(UIColor *)selectedTitleColor {
    if (self = [super init]) {
        self.normalTitleColor = normalTitleColor;
        self.selectedTitleColor = selectedTitleColor;
        [self setTitleColor:normalTitleColor forState:UIControlStateNormal];
        [self setTitle:title forState:UIControlStateNormal];
        self.maxShadowCircleValue = 1.f;
        self.minShadowCircleValue = 1.1;
        self.smartColor = NO;
        self.normalBottomLineColor = LINECOLOR;
        self.selectedBottomLineColor = REDCOLOR;
        self.lineView.backgroundColor = self.normalBottomLineColor;
        [self addSubview:self.lineView];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.lineView.frame = CGRectMake(0, frame.size.height - 2, frame.size.width, 2);
}

# pragma mark - published API

- (void)setDefaultFont:(UIFont *)defaultFont {
    _defaultFont = defaultFont;
    self.titleLabel.font = defaultFont;
}

- (void)setAnimationValue:(CGFloat)animationValue {
//    NSLog(@"%f", animationValue);
    [self setTitleColor:[SHColorUtils transitionColors:animationValue] forState:UIControlStateNormal];
    self.lineView.backgroundColor = self.normalBottomLineColor;
    if (animationValue == 1.f) {
        self.lineView.backgroundColor = self.selectedBottomLineColor;
    }
}

- (void)setupCurrentLineColor {
    self.lineView.backgroundColor = !self.isSelectedStatus ? self.normalBottomLineColor : self.selectedBottomLineColor;
    [self setTitleColor:!self.isSelectedStatus ? self.normalTitleColor : self.selectedTitleColor forState:UIControlStateNormal];
}

- (void)updateButtonStatus {
    self.selectedStatus = !self.isSelectedStatus;
    [self setupCurrentLineColor];
}

# pragma mark - lazyload

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
    }
    return _lineView;
}


@end
