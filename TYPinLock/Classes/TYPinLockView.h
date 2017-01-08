//
//  TYPinLockView.h
//  Tyblr
//
//  Created by luckytianyiyan on 17/1/2.
//  Copyright © 2017年 luckytianyiyan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYPinLockView : UIView

@property (nonatomic, copy) NSString *pinCode;

@property (nonatomic, strong, readonly) UITextField *digitsTextField;
@property (nonatomic, strong, readonly) UILabel *enterPasscodeLabel;
@property (nonatomic, strong, readonly) UILabel *detailLabel;

@property (nonatomic, strong, readonly) UIButton *okButton;
@property (nonatomic, strong, readonly) UIButton *deleteButton;
@property (nonatomic, strong, readonly) UIButton *cancelButton;

@property (nonatomic, assign) BOOL cancelEnabled;

@property (nonatomic, copy) void (^onNumberSelected)(NSInteger number);

@property (nonatomic, strong) UIColor *labelColor UI_APPEARANCE_SELECTOR;

- (void)playErrorAnimation:(CGFloat)duration direction:(CGFloat)direction;

- (void)setDeleteButtonHidden:(BOOL)hidden animated:(BOOL)animated completion:(nullable void (^)(BOOL finished))completion;
- (void)setOkButtonHidden:(BOOL)hidden animated:(BOOL)animated completion:(nullable void (^)(BOOL finished))completion;

@end

NS_ASSUME_NONNULL_END
