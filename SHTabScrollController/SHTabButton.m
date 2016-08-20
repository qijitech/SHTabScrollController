//
//  SHTabButton.m
//  Pods
//
//  Created by shuu on 7/30/16.
//
//

#import "SHTabButton.h"

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
    CIColor *normalCiColor = [CIColor colorWithCGColor:self.normalTitleColor.CGColor];
    CGFloat normalRedColor = normalCiColor.red;
    CGFloat normalGreenColor = normalCiColor.green;
    CGFloat normalBlueColor = normalCiColor.blue;

    CIColor *selectedCiColor = [CIColor colorWithCGColor:self.selectedTitleColor.CGColor];
    CGFloat selectedRedColor = selectedCiColor.red;
    CGFloat selectedGreenColor = selectedCiColor.green;
    CGFloat selectedBlueColor = selectedCiColor.blue;
    
    CGFloat redDelta = (selectedRedColor - normalRedColor) * animationValue + normalRedColor;
    CGFloat greenDelta = (selectedGreenColor - normalGreenColor) * animationValue + normalGreenColor;
    CGFloat blueDelta = (selectedBlueColor - normalBlueColor) * animationValue + normalBlueColor;

    UIColor *currentColor = [UIColor colorWithRed:redDelta green:greenDelta blue:blueDelta alpha:1.f];
    [self setTitleColor:currentColor forState:UIControlStateNormal];
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
