//
//  TYPinLockViewController.h
//  Tyblr
//
//  Created by luckytianyiyan on 17/1/1.
//  Copyright © 2017年 luckytianyiyan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYPinLockViewController : UIViewController

@property (nonatomic, assign) NSInteger pinCodeMinLength;
@property (nonatomic, assign) NSInteger pinCodeMaxLength;
@property (nonatomic, assign) BOOL tapSoundEnabled;

@property (nonatomic, copy, nullable) void (^onOkButtonClicked)(NSString *pinCode);
@property (nonatomic, copy, nullable) void (^onCancelButtonClicked)();

- (void)playErrorAnimation;

@end

NS_ASSUME_NONNULL_END
