//
//  TYPinSetupViewController.h
//  Pods
//
//  Created by luckytianyiyan on 17/1/11.
//
//

#import "TYPinLockViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TYPinSetupViewController : TYPinLockViewController

@property (nonatomic, copy, nullable) void (^onSetupSuccess)(NSString *pinCode);
@property (nonatomic, assign) BOOL errorVibrateEnabled;

@property (nonatomic, copy) NSString *notMatchedText;
@property (nonatomic, strong) NSString *confirmationText;

@end

NS_ASSUME_NONNULL_END
