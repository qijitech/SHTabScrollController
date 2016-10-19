//
//  SHDemoViewController.m
//  SHTabScrollController
//
//  Created by shuu on 23/09/2016.
//  Copyright © 2016 @harushuu. All rights reserved.
//

#import "SHDemoViewController.h"
#import <SHButton/SHButton.h>
#import "SHViewController.h"

@interface SHDemoViewController ()
@property (nonatomic, strong) SHButton *onlyImageDemoButton;
@property (nonatomic, strong) SHButton *onlyTitleDemoButton;
@property (nonatomic, strong) SHButton *customDemoButton;

@end

@implementation SHDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.onlyTitleDemoButton];
    [self.view addSubview:self.onlyImageDemoButton];
    [self.view addSubview:self.customDemoButton];
}

- (void)pushTabWithImageViewController {
    SHViewController *viewController = [[SHViewController alloc] initWithImage];
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)pushTabWithTitleViewController {
    SHViewController *viewController = [[SHViewController alloc] initWithTitle];
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)pushTabWithCustomViewController {
    SHViewController *viewController = [[SHViewController alloc] initWithCustom];
    [self presentViewController:viewController animated:YES completion:nil];
}

- (SHButton *)onlyImageDemoButton {
    if (!_onlyImageDemoButton) {
        _onlyImageDemoButton = [[SHButton alloc] init];
        [_onlyImageDemoButton setTitle:@"Only Image" forState:UIControlStateNormal];
        [_onlyImageDemoButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _onlyImageDemoButton.bounds = CGRectMake(0, 0, 100.f, 44.f);
        _onlyImageDemoButton.center = CGPointMake(self.view.center.x, self.view.center.y - 50.f);
        [_onlyImageDemoButton addTarget:self action:@selector(pushTabWithImageViewController) forControlEvents:UIControlEventTouchUpInside];
    }
    return _onlyImageDemoButton;
}

- (SHButton *)onlyTitleDemoButton {
    if (!_onlyTitleDemoButton) {
        _onlyTitleDemoButton = [[SHButton alloc] init];
        [_onlyTitleDemoButton setTitle:@"Only Title" forState:UIControlStateNormal];
        [_onlyTitleDemoButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _onlyTitleDemoButton.bounds = CGRectMake(0, 0, 100.f, 44.f);
        _onlyTitleDemoButton.center = CGPointMake(self.view.center.x, self.view.center.y + 50.f);
        [_onlyTitleDemoButton addTarget:self action:@selector(pushTabWithTitleViewController) forControlEvents:UIControlEventTouchUpInside];
    }
    return _onlyTitleDemoButton;
}

- (SHButton *)customDemoButton {
    if (!_customDemoButton) {
        _customDemoButton = [[SHButton alloc] init];
        [_customDemoButton setTitle:@"Custom" forState:UIControlStateNormal];
        [_customDemoButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _customDemoButton.bounds = CGRectMake(0, 0, 100.f, 44.f);
        _customDemoButton.center = CGPointMake(self.view.center.x, self.view.center.y + 150.f);
        [_customDemoButton addTarget:self action:@selector(pushTabWithCustomViewController) forControlEvents:UIControlEventTouchUpInside];
    }
    return _customDemoButton;
}


@end
