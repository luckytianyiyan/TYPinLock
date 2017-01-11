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
#import <TYPinLock/TYPinLockSetupViewController.h>

@interface TYViewController ()

@property (nonatomic, strong) UIButton *setupButton;
@property (nonatomic, strong) UIButton *lockButton;

@property (nonatomic, copy) NSString *pinCode;

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
    TYPinLockSetupViewController *viewController = [[TYPinLockSetupViewController alloc] init];
    viewController.pinCodeMinLength = 4;
    viewController.pinCodeMaxLength = 6;
    viewController.errorVibrateEnabled = YES;
    viewController.tapSoundEnabled = YES;
    __weak typeof(viewController) weakViewController = viewController;
    viewController.onCancelButtonClicked = ^{
        __strong typeof(viewController) strongViewController = weakViewController;
        [strongViewController dismissViewControllerAnimated:YES completion:nil];
    };
    viewController.onSetupSuccess = ^(NSString *pinCode) {
        NSLog(@"pin code: %@", pinCode);
        // Save Pin Code
        self.pinCode = pinCode;
        __strong typeof(viewController) strongViewController = weakViewController;
        [strongViewController dismissViewControllerAnimated:YES completion:nil];
    };
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)onLockButtonClicked:(UIButton *)sender {
    if (self.pinCode.length < 1) {
        return;
    }
    
    TYPinLockViewController *viewController = [[TYPinLockViewController alloc] init];
    viewController.pinCodeMinLength = 4;
    viewController.pinCodeMaxLength = 6;
    viewController.cancelEnabled = NO;
    __weak typeof(viewController) weakViewController = viewController;
    viewController.onCancelButtonClicked = ^{
        __strong typeof(viewController) strongViewController = weakViewController;
        [strongViewController dismissViewControllerAnimated:YES completion:nil];
    };
    viewController.onOkButtonClicked = ^(NSString *pinCode) {
        __strong typeof(viewController) strongViewController = weakViewController;
        // Validate Pin Code
        if ([self.pinCode isEqualToString:pinCode]) {
            [strongViewController dismissViewControllerAnimated:YES completion:nil];
            return;
        }
        [strongViewController playErrorAnimation];
    };
    [self presentViewController:viewController animated:YES completion:nil];
}

@end
