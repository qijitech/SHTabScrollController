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
        [self addSubview:self.lineView];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.lineView.frame = CGRectMake(0, frame.size.height - 2, frame.size.width, 2);
}

# pragma mark - published API

- (void)setAnimationValue:(CGFloat)animationValue {
    [self setTitleColor:[UIColor colorWithRed:animationValue green:0.0 blue:0.0 alpha:1] forState:UIControlStateNormal];
    self.lineView.backgroundColor = LINECOLOR;
}

- (void)setupCurrentLineColor {
    self.lineView.backgroundColor = !self.isSelectedStatus ? LINECOLOR : REDCOLOR;
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
        _lineView.backgroundColor = LINECOLOR;
    }
    return _lineView;
}


@end
