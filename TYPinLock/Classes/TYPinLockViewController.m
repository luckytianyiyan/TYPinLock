//
//  TYPinLockViewController.m
//  Tyblr
//
//  Created by luckytianyiyan on 17/1/1.
//  Copyright © 2017年 luckytianyiyan. All rights reserved.
//

#import "TYPinLockViewController.h"
#import "TYPinButton.h"
#import "TYPinLockView.h"
#import <AudioToolbox/AudioToolbox.h>

@interface TYPinLockViewController ()

@property (nonatomic, strong) TYPinLockView *lockView;

@end

@implementation TYPinLockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:54 / 255.f green:70 / 255.f blue:92 / 255.f alpha:1];
    _lockView = ({
        TYPinLockView *view = [[TYPinLockView alloc] init];
        view.detailLabel.text = NSLocalizedString(@"You need a PIN to continue", nil);
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [view.okButton addTarget:self action:@selector(onOkButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [view.cancelButton addTarget:self action:@selector(onCancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [view.deleteButton addTarget:self action:@selector(onDeleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        __weak typeof(self) weakSelf = self;
        view.onNumberSelected = ^(NSInteger number) {
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf.pinCodeMaxLength == 0 || strongSelf.lockView.pinCode.length < strongSelf.pinCodeMaxLength) {
                strongSelf.lockView.pinCode = [NSString stringWithFormat:@"%@%ld", strongSelf.lockView.pinCode, number];
            }
            [strongSelf.lockView setDeleteButtonHidden:NO animated:YES completion:nil];
            
            if ((strongSelf.pinCodeMinLength == 0 && strongSelf.lockView.pinCode.length > 0) ||
                strongSelf.lockView.pinCode.length >= strongSelf.pinCodeMinLength) {
                [strongSelf.lockView setOkButtonHidden:NO animated:YES completion:nil];
            }
            if (strongSelf.tapSoundEnabled) {
                AudioServicesPlaySystemSound(1105);
            }
        };
        view;
    });
    [self.view addSubview:_lockView];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_lockView]|" options:NSLayoutFormatAlignAllLeft metrics:nil views:NSDictionaryOfVariableBindings(_lockView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_lockView]|" options:NSLayoutFormatAlignAllLeft metrics:nil views:NSDictionaryOfVariableBindings(_lockView)]];
}

#pragma mark - Animate

- (void)playErrorAnimation {
    [self.lockView playErrorAnimation:0.08f direction:-35.f];
}

#pragma mark - Event

- (void)onOkButtonClicked:(UIButton *)sender {
    if (self.onOkButtonClicked) {
        self.onOkButtonClicked(self.lockView.pinCode);
    }
}

- (void)onCancelButtonClicked:(UIButton *)sender {
    if (self.onCancelButtonClicked) {
        self.onCancelButtonClicked();
    }
}

- (void)onDeleteButtonClicked:(UIButton *)sender {
    
    if (self.lockView.pinCode.length > 0) {
        self.lockView.pinCode = [self.lockView.pinCode substringWithRange:NSMakeRange(0, self.lockView.pinCode.length - 1)];
    }

    if (self.lockView.pinCode.length < 1) {
        [self.lockView setDeleteButtonHidden:YES animated:YES completion:nil];
        if (self.pinCodeMinLength < 1) {
            [self.lockView setOkButtonHidden:YES animated:YES completion:nil];
            return;
        }
    }
    if (self.lockView.pinCode.length < self.pinCodeMinLength) {
        [self.lockView setOkButtonHidden:YES animated:YES completion:nil];
    }
}

#pragma mark - Setter

- (void)setPinCodeMinLength:(NSInteger)pinCodeMinLength {
    _pinCodeMinLength = pinCodeMinLength;
    if (self.lockView.pinCode.length >= pinCodeMinLength) {
        [self.lockView setOkButtonHidden:NO animated:NO completion:nil];
    }
}

@end