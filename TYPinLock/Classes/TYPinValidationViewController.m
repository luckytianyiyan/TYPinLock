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
    _validateErrorText = NSLocalizedStringFromTableInBundle(@"pinlock.pin.error", nil, [NSBundle typ_bundle], nil);
}

- (void)viewDidLoad {
    [super viewDidLoad];
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

@end
