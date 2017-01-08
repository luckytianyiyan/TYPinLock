//
//  TYPinButton.h
//  Tyblr
//
//  Created by luckytianyiyan on 17/1/1.
//  Copyright © 2017年 luckytianyiyan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYPinButton : UIButton

+ (instancetype)buttonWithNumber:(NSInteger)number letters:(nullable NSString *)letters;

@property (nonatomic, copy, nullable) NSString *numberText;
@property (nonatomic, copy, nullable) NSString *lettersText;

@property (nonatomic, strong) UIFont *numberLabelFont UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont *letterLabelFont UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIColor *textColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *hightlightedTextColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *selectedColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *borderColor UI_APPEARANCE_SELECTOR;

@end

NS_ASSUME_NONNULL_END
