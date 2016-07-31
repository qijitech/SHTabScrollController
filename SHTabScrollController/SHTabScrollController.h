//
//  SHTabScrollController.h
//  Pods
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

@interface SHTabScrollController : UIViewController

// default is blackColor, not support custom yet, will add cutom animation in next version.
@property (nonatomic, strong, readonly) UIColor *normalTitleColor;

// default is redColor , not support custom yet, will add cutom animation in next version.
@property (nonatomic, strong, readonly) UIColor *selectedTitleColor;

// default is 40.0
@property (nonatomic, assign) CGFloat tabButtonHeight;

+ (SHTabScrollController *)setupTitles:(NSArray *)titles controllers:(NSArray *)controllers tabIndexHandle:(SHTabIndexHandle)tabIndexHandle;



@end
