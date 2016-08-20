//
//  SHTabButton.h
//  Pods
//
//  Created by shuu on 7/30/16.
//
//

#import <SHButton/SHButton.h>

#define LINECOLOR [UIColor colorWithRed:53.f/255.f green:53.f/255.f blue:53.f/255.f alpha:1.f]
#define REDCOLOR [UIColor colorWithRed:205.f/255.f green:67.f/255.f blue:67.f/255.f alpha:1.f]

@interface SHTabButton : SHButton
@property (nonatomic, assign) CGFloat animationValue;
@property (nonatomic, strong) UIFont *defaultFont;
@property (nonatomic, strong) UIColor *normalBottomLineColor;
@property (nonatomic, strong) UIColor *selectedBottomLineColor;

- (instancetype)initWithTitle:(NSString *)title normalTitleColor:(UIColor *)normalTitleColor selectedTitleColor:(UIColor *)selectedTitleColor;

- (void)updateButtonStatus;

- (void)setupCurrentLineColor;

@end
