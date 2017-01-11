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
#import "NSBundle+TYPinLock.h"
#import <AudioToolbox/AudioToolbox.h>

@interface TYPinLockViewController ()

@property (nonatomic, strong, readwrite) TYPinLockView *lockView;

@end

@implementation TYPinLockViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initPinLock];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self initPinLock];
    }
    return self;
}

- (void)initPinLock {
    _cancelEnabled = YES;
    _tapSoundEnabled = YES;
    _animationDuration = 0.08f;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSBundle *bundle = [NSBundle typ_bundle];
    
    self.view.backgroundColor = [UIColor colorWithRed:54 / 255.f green:70 / 255.f blue:92 / 255.f alpha:1];
    _lockView = ({
        TYPinLockView *view = [[TYPinLockView alloc] init];
        view.detailLabel.text = NSLocalizedStringFromTableInBundle(@"pinlock.detail", nil, bundle, nil);
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [view setCancelButtonHidden:!_cancelEnabled animated:YES completion:nil];
        [view.okButton addTarget:self action:@selector(onOkButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [view.cancelButton addTarget:self action:@selector(onCancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [view.deleteButton addTarget:self action:@selector(onDeleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        __weak typeof(self) weakSelf = self;
        view.onNumberSelected = ^(NSInteger number) {
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf.pinCodeMaxLength == 0 || strongSelf.lockView.pinCode.length < strongSelf.pinCodeMaxLength) {
                strongSelf.lockView.pinCode = [NSString stringWithFormat:@"%@%ld", strongSelf.lockView.pinCode, number];
            }
            [strongSelf updateButtonsHidden];
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
    NSBundle *bundle = [NSBundle typ_bundle];
    [self.lockView playErrorAnimation:self.animationDuration direction:-35.f];
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
    
    [self updateButtonsHidden];
}

#pragma mark - Setter / Getter

- (void)setPinCodeMinLength:(NSInteger)pinCodeMinLength {
    _pinCodeMinLength = pinCodeMinLength;
    if (self.lockView.pinCode.length >= pinCodeMinLength) {
        [self.lockView setOkButtonHidden:NO animated:NO completion:nil];
    }
}

- (void)setCancelEnabled:(BOOL)cancelEnabled {
    _cancelEnabled = cancelEnabled;
    [self updateButtonsHidden];
}

#pragma mark - Helper

- (void)updateButtonsHidden {
    BOOL hasCode = self.lockView.pinCode.length < 1;
    [self.lockView setDeleteButtonHidden:hasCode animated:YES completion:nil];
    if (self.cancelEnabled) {
        [self.lockView setCancelButtonHidden:!hasCode animated:YES completion:nil];
    }
    
    BOOL okShouldShow = (self.pinCodeMinLength == 0 && self.lockView.pinCode.length > 0) || self.lockView.pinCode.length >= self.pinCodeMinLength;
    [self.lockView setOkButtonHidden:!okShouldShow animated:YES completion:nil];
}

@end
