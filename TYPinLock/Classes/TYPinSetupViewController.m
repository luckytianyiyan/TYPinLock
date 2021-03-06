//
//  TYPinSetupViewController.m
//  Pods
//
//  Created by luckytianyiyan on 17/1/11.
//
//

#import "TYPinSetupViewController.h"
#import "NSBundle+TYPinLock.h"
#import <AudioToolbox/AudioToolbox.h>

@interface TYPinSetupViewController ()

@property (nonatomic, copy) NSString *enteredPin;

@end

@implementation TYPinSetupViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initSetupPinLock];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self initSetupPinLock];
    }
    return self;
}

- (void)initSetupPinLock {
    NSBundle *bundle = [NSBundle typ_bundle];
    _notMatchedText = NSLocalizedStringFromTableInBundle(@"pinlock.error.pin.matched", nil, bundle, nil);
    _confirmationText = NSLocalizedStringFromTableInBundle(@"pinlock.pin.confirmation", nil, bundle, nil);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    self.onOkButtonClick = ^(NSString *pinCode) {
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf.enteredPin.length < 1) {
            strongSelf.enteredPin = pinCode;
            [strongSelf.lockView updateDetailText:strongSelf.confirmationText duration:strongSelf.animationDuration completion:nil];
            [strongSelf resetAnimated:YES];
        } else {
            if ([pinCode isEqualToString:strongSelf.enteredPin]) {
                if (strongSelf.onSetupSuccess) {
                    strongSelf.onSetupSuccess(pinCode);
                }
            } else {
                [strongSelf.lockView updateDetailText:strongSelf.notMatchedText duration:strongSelf.animationDuration completion:nil];
                [strongSelf playErrorAnimation];
                [strongSelf resetAnimated:YES];
                strongSelf.enteredPin = nil;
                
                if (strongSelf.errorVibrateEnabled) {
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                }
            }
        }
    };
    
}

#pragma mark - Helper

- (void)resetAnimated:(BOOL)animated {
    self.lockView.digitsTextField.text = @"";
    [self updateButtonsHidden];
}

@end
