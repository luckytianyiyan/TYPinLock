//
//  TYPinLockSetupViewController.m
//  Pods
//
//  Created by luckytianyiyan on 17/1/11.
//
//

#import "TYPinLockSetupViewController.h"
#import "NSBundle+TYPinLock.h"
#import <AudioToolbox/AudioToolbox.h>

@interface TYPinLockSetupViewController ()

@property (nonatomic, copy) NSString *enteredPin;

@end

@implementation TYPinLockSetupViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    NSBundle *bundle = [NSBundle typ_bundle];
    _notMatchedText = NSLocalizedStringFromTableInBundle(@"pinlock.error.pin.matched", nil, bundle, nil);
    _confirmationText = NSLocalizedStringFromTableInBundle(@"pinlock.pin.confirmation", nil, bundle, nil);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    self.onOkButtonClicked = ^(NSString *pinCode) {
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf.enteredPin.length < 1) {
            strongSelf.enteredPin = pinCode;
            [strongSelf.lockView updateDetailText:self.confirmationText duration:0.08f completion:nil];
            [self resetAnimated:YES];
        } else {
            if ([pinCode isEqualToString:strongSelf.enteredPin]) {
                if (strongSelf.onSetupSuccess) {
                    strongSelf.onSetupSuccess(pinCode);
                }
            } else {
                [strongSelf.lockView updateDetailText:self.notMatchedText duration:0.08f completion:nil];
                [strongSelf playErrorAnimation];
                [self resetAnimated:YES];
                strongSelf.enteredPin = nil;
                
                if (self.errorVibrateEnabled) {
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                }
            }
        }
    };
    
}

#pragma mark - Helper

- (void)resetAnimated:(BOOL)animated {
    self.lockView.digitsTextField.text = @"";
    [self.lockView setCancelButtonHidden:NO animated:YES completion:nil];
    [self.lockView setOkButtonHidden:YES animated:YES completion:nil];
}

@end
