//
//  TYPinLockSetupViewController.h
//  Pods
//
//  Created by luckytianyiyan on 17/1/11.
//
//

#import "TYPinLockViewController.h"

@interface TYPinLockSetupViewController : TYPinLockViewController

@property (nonatomic, copy, nullable) void (^onSetupSuccess)(NSString *pinCode);
@property (nonatomic, assign) BOOL errorVibrateEnabled;

@property (nonatomic, copy) NSString *notMatchedText;
@property (nonatomic, strong) NSString *confirmationText;

@end
