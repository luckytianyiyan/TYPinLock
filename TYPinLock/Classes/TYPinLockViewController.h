//
//  TYPinLockViewController.h
//  Tyblr
//
//  Created by luckytianyiyan on 17/1/1.
//  Copyright © 2017年 luckytianyiyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYPinLockView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TYPinLockViewController : UIViewController

@property (nonatomic, strong, readonly) TYPinLockView *lockView;

@property (nonatomic, assign) NSRange pinCodeLengthRange;
@property (nonatomic, assign) BOOL tapSoundEnabled;
@property (nonatomic, assign) BOOL cancelEnabled;

@property (nonatomic, assign) CGFloat animationDuration;

@property (nonatomic, copy, nullable) void (^onOkButtonClick)(NSString *pinCode);
@property (nonatomic, copy, nullable) void (^onCancelButtonClick)(void);

- (void)playErrorAnimation;
- (void)playErrorAnimationWithCompletion:(nullable void (^)(BOOL finished))completion;

- (void)updateButtonsHidden;

@end

NS_ASSUME_NONNULL_END
