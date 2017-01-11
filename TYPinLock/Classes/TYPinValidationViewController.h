//
//  TYPinValidationViewController.h
//  Pods
//
//  Created by luckytianyiyan on 17/1/12.
//
//

#import "TYPinLockViewController.h"

@interface TYPinValidationViewController : TYPinLockViewController

@property (nonatomic, copy) NSString *validateErrorText;

@property (nonatomic, copy) BOOL (^validatePin)(NSString *pinCode);

@property (nonatomic, copy) void (^onValidateSuccess)(NSString *pinCode);
@property (nonatomic, copy) void (^onValidateError)(NSString *pinCode);

@end
