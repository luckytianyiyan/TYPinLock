//
//  TYPinValidationViewController.m
//  Pods
//
//  Created by luckytianyiyan on 17/1/12.
//
//

#import "TYPinValidationViewController.h"
#import "NSBundle+TYPinLock.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface TYPinValidationViewController ()

@property (nonatomic, strong) UIButton *forgotButton;

@end

@implementation TYPinValidationViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initPinValidation];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self initPinValidation];
    }
    return self;
}

- (void)initPinValidation {
    NSBundle *bundle = [NSBundle typ_bundle];
    _forgotPasswordText = NSLocalizedStringFromTableInBundle(@"pinlock.pin.forgot", nil, bundle, nil);
    _validateErrorText = NSLocalizedStringFromTableInBundle(@"pinlock.pin.validate.error", nil, bundle, nil);
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    _touchIDText = [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"pinlock.pin.validate.touchid", nil, bundle, nil), appName];
    _touchIDEnable = YES;
    _forgotPasswordEnabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _forgotButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.hidden = !self.forgotPasswordEnabled;
        [button setTitle:self.forgotPasswordText forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onForgotPasswordButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self.view addSubview:_forgotButton];
    
    _forgotButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_forgotButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0]];
    NSLayoutConstraint *bottomConstraint;
    if (@available(iOS 11, *)) {
        bottomConstraint = [NSLayoutConstraint constraintWithItem:_forgotButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view.safeAreaLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.f constant:-24.f];
    } else {
        bottomConstraint = [NSLayoutConstraint constraintWithItem:_forgotButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.f constant:-24.f];
    }
    [self.view addConstraint:bottomConstraint];
    
    __weak typeof(self) weakSelf = self;
    self.onOkButtonClick = ^(NSString *pinCode) {
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf.validatePin ? strongSelf.validatePin(pinCode) : YES) {
            if (strongSelf.onValidateSuccess) {
                strongSelf.onValidateSuccess(pinCode, TYPinValidationTypePinCode);
            }
        } else {
            [strongSelf.lockView updateDetailText:strongSelf.validateErrorText duration:strongSelf.animationDuration completion:nil];
            [strongSelf playErrorAnimationWithCompletion:^(BOOL finished) {
                if (strongSelf.onValidateError) {
                    strongSelf.onValidateError(pinCode);
                }
            }];
        }
    };
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!_touchIDEnable) {
        return;
    }
    LAContext *laContext = [[LAContext alloc] init];
    if ([laContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil]) {
        [laContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:_touchIDText reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                if (self.onValidateSuccess) {
                    self.onValidateSuccess(nil, TYPinValidationTypeTouchID);
                }
            }
        }];
    }
}

#pragma mark - Action

- (void)onForgotPasswordButtonClick:(UIButton *)sender {
    if (self.forgotPassword) {
        self.forgotPassword();
    }
}

#pragma mark - Setter / Getter

- (void)setForgotPasswordText:(NSString *)forgotPasswordText {
    _forgotPasswordText = forgotPasswordText;
    [self.forgotButton setTitle:forgotPasswordText forState:UIControlStateNormal];
}

- (void)setForgotPasswordEnabled:(BOOL)forgotPasswordEnabled {
    _forgotPasswordEnabled = forgotPasswordEnabled;
    self.forgotButton.hidden = !forgotPasswordEnabled;
}

@end
