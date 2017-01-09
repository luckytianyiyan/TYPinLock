//
//  TYViewController.m
//  TYPinLock
//
//  Created by luckytianyiyan on 01/09/2017.
//  Copyright (c) 2017 luckytianyiyan. All rights reserved.
//

#import "TYViewController.h"
#import <Masonry/Masonry.h>
#import <TYPinLock/TYPinLockViewController.h>

@interface TYViewController ()

@property (nonatomic, strong) UIButton *setupButton;
@property (nonatomic, strong) UIButton *lockButton;

@end

@implementation TYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _setupButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_setupButton setTitle:@"Set Pin" forState:UIControlStateNormal];
    [_setupButton addTarget:self action:@selector(onSetupButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_setupButton];
    
    _lockButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_lockButton setTitle:@"Lock" forState:UIControlStateNormal];
    [_lockButton addTarget:self action:@selector(onLockButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_lockButton];
    
    [_setupButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    
    [_lockButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_setupButton.mas_bottom).offset(20.f);
        make.centerX.equalTo(_setupButton);
    }];
}

#pragma mark - Actions

- (void)onSetupButtonClicked:(UIButton *)sender {
    TYPinLockViewController *viewController = [[TYPinLockViewController alloc] init];
    viewController.pinCodeMinLength = 4;
    viewController.pinCodeMaxLength = 6;
    __weak typeof(viewController) weakViewController = viewController;
    viewController.onCancelButtonClicked = ^{
        __strong typeof(viewController) strongViewController = weakViewController;
        [strongViewController dismissViewControllerAnimated:YES completion:nil];
    };
    viewController.onOkButtonClicked = ^(NSString *pinCode) {
        // Save Pin Code
        __strong typeof(viewController) strongViewController = weakViewController;
        [strongViewController dismissViewControllerAnimated:YES completion:nil];
    };
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)onLockButtonClicked:(UIButton *)sender {
    
}

@end