//
//  TYPinValidationViewController.m
//  Pods
//
//  Created by luckytianyiyan on 17/1/12.
//
//

#import "TYPinValidationViewController.h"
#import "NSBundle+TYPinLock.h"

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
    _forgotPasswordEnabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _forgotButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.hidden = !self.forgotPasswordEnabled;
        [button setTitle:self.forgotPasswordText forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onForgotPasswordButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self.view addSubview:_forgotButton];
    
    _forgotButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_forgotButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_forgotButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.f constant:-24.f]];
    
    __weak typeof(self) weakSelf = self;
    self.onOkButtonClicked = ^(NSString *pinCode) {
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf.validatePin ? strongSelf.validatePin(pinCode) : YES) {
            if (strongSelf.onValidateSuccess) {
                strongSelf.onValidateSuccess(pinCode);
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

#pragma mark - Action

- (void)onForgotPasswordButtonClicked:(UIButton *)sender {
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
