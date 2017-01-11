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
#import <TYPinLock/TYPinSetupViewController.h>
#import <TYPinLock/TYPinValidationViewController.h>

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
    TYPinSetupViewController *viewController = [[TYPinSetupViewController alloc] init];
    viewController.pinCodeLengthRange = NSMakeRange(4, 3);
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
    
    TYPinValidationViewController *viewController = [[TYPinValidationViewController alloc] init];
    viewController.pinCodeLengthRange = NSMakeRange(4, 3);
    viewController.cancelEnabled = NO;
    __weak typeof(self) weakSelf = self;
    viewController.validatePin = ^(NSString *pinCode) {
        __strong typeof(self) strongSelf = weakSelf;
        return [strongSelf.pinCode isEqualToString:pinCode];
    };
    __weak typeof(viewController) weakViewController = viewController;
    viewController.onValidateSuccess = ^(NSString *pinCode) {
        __strong typeof(viewController) strongViewController = weakViewController;
        [strongViewController dismissViewControllerAnimated:YES completion:nil];
    };
    viewController.onValidateError = ^(NSString *pinCode) {
        NSLog(@"PinCode Error");
    };
    viewController.forgotPassword = ^{
        // do something...
        NSLog(@"Forgot Password");
        self.pinCode = @"";
        __strong typeof(viewController) strongViewController = weakViewController;
        [strongViewController dismissViewControllerAnimated:YES completion:nil];
    };

    [self presentViewController:viewController animated:YES completion:nil];
}

@end
