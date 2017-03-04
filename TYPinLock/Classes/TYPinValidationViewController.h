//
//  TYPinValidationViewController.h
//  Pods
//
//  Created by luckytianyiyan on 17/1/12.
//
//

#import "TYPinLockViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TYPinValidationType) {
    TYPinValidationTypePinCode,
    TYPinValidationTypeTouchID
};

@interface TYPinValidationViewController : TYPinLockViewController

@property (nonatomic, copy) NSString *validateErrorText;
@property (nonatomic, assign) BOOL forgotPasswordEnabled;
@property (nonatomic, copy) NSString *forgotPasswordText;
@property (nonatomic, copy) NSString *touchIDText;

/**
 * @brief if available, use Touch ID
 *
 * default is true
 */
@property (nonatomic, assign) BOOL touchIDEnable;

@property (nonatomic, copy) BOOL (^validatePin)(NSString *pinCode);
@property (nonatomic, copy) void (^forgotPassword)();

@property (nonatomic, copy) void (^onValidateSuccess)( NSString * _Nullable pinCode, TYPinValidationType type);
@property (nonatomic, copy) void (^onValidateError)(NSString *pinCode);

@end

NS_ASSUME_NONNULL_END
