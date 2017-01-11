//
//  TYPinLockView.m
//  Tyblr
//
//  Created by luckytianyiyan on 17/1/2.
//  Copyright © 2017年 luckytianyiyan. All rights reserved.
//

#import "TYPinLockView.h"
#import "TYPinButton.h"
#import "NSBundle+TYPinLock.h"

static CGFloat const TYPinLockViewAnimationLength = 0.15f;

@interface TYPinLockView()

@property (nonatomic, strong, readwrite) UILabel *enterPasscodeLabel;
@property (nonatomic, strong, readwrite) UILabel *detailLabel;
@property (nonatomic, strong, readwrite) UITextField *digitsTextField;
@property (nonatomic, strong, readwrite) UIButton *okButton;
@property (nonatomic, strong, readwrite) UIButton *deleteButton;
@property (nonatomic, strong, readwrite) UIButton *cancelButton;

@property (nonatomic, strong) NSArray<TYPinButton *> *buttons;

@end

@implementation TYPinLockView

+ (void)initialize {
    if (self != [TYPinLockView class]) {
        return;
    }
    
    TYPinLockView *appearance = [self appearance];
    appearance.labelColor = [UIColor whiteColor];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        NSBundle *bundle = [NSBundle typ_bundle];
        _enterPasscodeLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = NSLocalizedStringFromTableInBundle(@"pinlock.title", nil, bundle, nil);
            label;
        });
        [self addSubview:_enterPasscodeLabel];
        
        _okButton = ({
            UIButton *button = [[UIButton alloc] init];
            [button setTitle:NSLocalizedString(@"ok", nil) forState:UIControlStateNormal];
            button.alpha = 0;
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            button;
        });
        [self addSubview:_okButton];
        
        _deleteButton = ({
            UIButton *button = [[UIButton alloc] init];
            [button setTitle:NSLocalizedString(@"delete", @"") forState:UIControlStateNormal];
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            button.alpha = 0;
            button;
        });
        [self addSubview:_deleteButton];
        
        _cancelEnabled = YES;
        
        _cancelButton = ({
            UIButton *button = [[UIButton alloc] init];
            [button setTitle:NSLocalizedString(@"cancel", nil) forState:UIControlStateNormal];
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            button;
        });
        [self addSubview:_cancelButton];
        
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_detailLabel];
        
        _digitsTextField = ({
            UITextField *textField = [[UITextField alloc] init];
            textField.enabled = NO;
            textField.secureTextEntry = YES;
            textField.textAlignment = NSTextAlignmentCenter;
            textField.borderStyle = UITextBorderStyleNone;
            textField.layer.borderWidth = 1.0f;
            textField.layer.cornerRadius = 5.0f;
            textField;
        });
        [self addSubview:_digitsTextField];
        
        NSArray *buttonsLetters = @[@"", @" ", @"ABC", @"DEF", @"GHI", @"JKL", @"MNO", @"PQRS", @"TUV", @"WXYZ"];
        
        NSMutableArray *buttons = [NSMutableArray arrayWithCapacity:buttonsLetters.count];
        for (NSInteger i = 0; i < buttonsLetters.count; ++i) {
            TYPinButton *button = [TYPinButton buttonWithNumber:i letters:buttonsLetters[i]];
            button.tag = i;
            button.clipsToBounds = YES;
            [button addTarget:self action:@selector(onNumberButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [buttons addObject:button];
            [self addSubview:button];
        }
        _buttons = buttons;
        _digitsTextField.layer.borderColor = [TYPinButton appearance].borderColor.CGColor;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat fullWidth = CGRectGetWidth(self.bounds);
    CGFloat contentWidth = fullWidth * .8f;
    CGFloat marginHorizontal = (fullWidth - contentWidth) / 2.f;
    CGFloat buttonMargin = marginHorizontal / 2.f;
    CGFloat buttonSize = (contentWidth - buttonMargin * 2) / 3.f;
    
    CGFloat top = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 80.f : 65.f;
    
    self.enterPasscodeLabel.frame = CGRectMake(fullWidth / 2.f - 150.f, top, 300.f, 23.f);
    
    CGFloat pinSelectionTop = self.enterPasscodeLabel.frame.origin.y + self.enterPasscodeLabel.frame.size.height + 17.5;
    
    CGFloat textFieldWidth = 152.f;
    self.digitsTextField.frame = CGRectMake((fullWidth / 2.f) - (textFieldWidth / 2), pinSelectionTop - 7.5f, textFieldWidth, 30);
    
    self.detailLabel.frame = CGRectMake(fullWidth / 2.f - 150.f, pinSelectionTop + 30.f, 300.f, 23.f);
    
    CGFloat topRowTop = CGRectGetMaxY(self.detailLabel.frame) + 15.f;
    
    [self.buttons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger row;
        NSInteger colum;
        if (idx == 0) {
            row = 1;
            colum = 3;
        } else {
            row = (idx - 1) % 3;
            colum = floor((idx - 1) / 3);
        }
        
        obj.frame = CGRectMake(marginHorizontal + row * (buttonSize + buttonMargin), topRowTop + colum * (buttonSize + buttonMargin), buttonSize, buttonSize);
        obj.layer.cornerRadius = buttonSize / 2.f;
    }];
    
    self.okButton.frame = CGRectMake(CGRectGetMinX(self.buttons[7].frame), CGRectGetMinY(self.buttons[0].frame), buttonSize, buttonSize);
    
    self.deleteButton.frame = CGRectMake(CGRectGetMinX(self.buttons[9].frame), CGRectGetMinY(self.buttons[0].frame), buttonSize, buttonSize);
    self.cancelButton.frame = _deleteButton.frame;
}

#pragma mark - Event

- (void)onNumberButtonClicked:(UIButton *)sender {
    NSInteger number = sender.tag;
    if (_onNumberSelected) {
        _onNumberSelected(number);
    }
}

#pragma mark - Animation

- (void)setOkButtonHidden:(BOOL)hidden animated:(BOOL)animated completion:(nullable void (^)(BOOL finished))completion {
    [self setButton:self.okButton hidden:hidden animated:animated completion:completion];
}

- (void)setDeleteButtonHidden:(BOOL)hidden animated:(BOOL)animated completion:(nullable void (^)(BOOL finished))completion {
    [self setButton:self.deleteButton hidden:hidden animated:animated completion:completion];
    if (_cancelEnabled) {
        [self setButton:self.cancelButton hidden:!hidden animated:animated completion:completion];
    }
}

- (void)updateDetailText:(NSString *)text duration:(CGFloat)duration completion:(nullable void (^)(BOOL finished))completion {
    CATransition *animation = [CATransition animation];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionFade;
    animation.duration = duration;
    [self.detailLabel.layer addAnimation:animation forKey:@"kCATransitionFade"];
    
    self.detailLabel.text = text;
}

- (void)playErrorAnimation:(CGFloat)duration direction:(CGFloat)direction {
    [UIView animateWithDuration:duration animations:^{
        CGAffineTransform transform = CGAffineTransformMakeTranslation(direction, 0);
        self.digitsTextField.layer.affineTransform = transform;
    } completion:^(BOOL finished) {
        if(fabs(direction) < 1) {
            self.digitsTextField.layer.affineTransform = CGAffineTransformIdentity;
            return;
        }
        [self playErrorAnimation:duration direction:-1 * direction / 2];
    }];
}

#pragma mark - Setter / Getter

- (void)setLabelColor:(UIColor *)labelColor {
    if (_labelColor == labelColor) {
        return;
    }
    _labelColor = labelColor;
    self.enterPasscodeLabel.textColor = labelColor;
    self.detailLabel.textColor = labelColor;
    
    [self.okButton setTitleColor:labelColor forState:UIControlStateNormal];
    [self.deleteButton setTitleColor:labelColor forState:UIControlStateNormal];
    self.digitsTextField.textColor = labelColor;
}

- (void)setPinCode:(NSString *)pinCode {
    self.digitsTextField.text = pinCode;
}

- (NSString *)pinCode {
    return self.digitsTextField.text;
}

- (void)setCancelEnabled:(BOOL)cancelEnabled {
    if (_cancelEnabled == cancelEnabled) {
        return;
    }
    _cancelEnabled = cancelEnabled;
    if (cancelEnabled) {
        [self addSubview:self.cancelButton];
    } else {
        [self.cancelButton removeFromSuperview];
    }
}

#pragma mark - Helper

- (void)setButton:(nonnull UIButton *)button hidden:(BOOL)hidden animated:(BOOL)animated completion:(void (^)(BOOL))completion {
    [UIView animateWithDuration:animated ? TYPinLockViewAnimationLength : 0 delay:0.0f options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         button.alpha = hidden ? 0 : 1.f;
                     } completion:completion];
}

@end
