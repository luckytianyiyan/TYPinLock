//
//  TYPinButton.m
//  Tyblr
//
//  Created by luckytianyiyan on 17/1/1.
//  Copyright © 2017年 luckytianyiyan. All rights reserved.
//

#import "TYPinButton.h"

CGFloat const TYPinButtonAnimationDuration = 0.15f;

@interface TYPinButton()

@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UILabel *lettersLabel;

@property (nonatomic, strong) UIView *selectedView;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) NSLayoutConstraint *lettersHiddenBottomConstraint;

@end

@implementation TYPinButton

+ (void)initialize {
    if (self != [TYPinButton class]) {
        return;
    }
    
    TYPinButton *appearance = [self appearance];
    appearance.borderColor = [UIColor whiteColor];
    appearance.selectedColor = [UIColor lightGrayColor];
    appearance.textColor = [UIColor whiteColor];
    appearance.hightlightedTextColor = [UIColor whiteColor];
    appearance.numberLabelFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:34.f];
    appearance.letterLabelFont = [UIFont fontWithName:@"HelveticaNeue" size:8.f];
}

+ (instancetype)buttonWithNumber:(NSInteger)number letters:(NSString *)letters {
    TYPinButton *button = [[TYPinButton alloc] init];
    button.numberText = [NSString stringWithFormat:@"%ld", number];
    button.lettersText = letters;
    return button;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.layer.borderWidth = 1.5f;
        _selectedView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
            view.translatesAutoresizingMaskIntoConstraints = NO;
            view.alpha = 0;
            view.userInteractionEnabled = NO;
            view;
        });
        [self addSubview:_selectedView];
        
        _contentView = [[UIView alloc] init];
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
        _contentView.userInteractionEnabled = NO;
        [self addSubview:_contentView];
        
        _numberLabel = ({
            UILabel *label = [self standardLabel];
            label.translatesAutoresizingMaskIntoConstraints = NO;
            label;
        });
        [_contentView addSubview:_numberLabel];
        
        _lettersLabel = ({
            UILabel *label = [self standardLabel];
            label.translatesAutoresizingMaskIntoConstraints = NO;
            label;
        });
        [_contentView addSubview:_lettersLabel];
        
        [_contentView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [_numberLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [_lettersLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        
        [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_numberLabel]|" options:NSLayoutFormatAlignAllLeft metrics:nil views:NSDictionaryOfVariableBindings(_numberLabel)]];
        [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_lettersLabel]|" options:NSLayoutFormatAlignAllLeft metrics:nil views:NSDictionaryOfVariableBindings(_lettersLabel)]];
        [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_numberLabel]-(-3@750)-[_lettersLabel]|" options:NSLayoutFormatAlignAllLeft metrics:nil views:NSDictionaryOfVariableBindings(_numberLabel, _lettersLabel)]];
        _lettersHiddenBottomConstraint = [NSLayoutConstraint constraintWithItem:_numberLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeBottom multiplier:1.f constant:0];
        _lettersHiddenBottomConstraint.priority = UILayoutPriorityRequired;
        [_contentView addConstraint:_lettersHiddenBottomConstraint];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_contentView]|" options:NSLayoutFormatAlignAllLeft metrics:nil views:NSDictionaryOfVariableBindings(_contentView)]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.f constant:0]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_selectedView]|" options:NSLayoutFormatAlignAllLeft metrics:nil views:NSDictionaryOfVariableBindings(_selectedView)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_selectedView]|" options:NSLayoutFormatAlignAllLeft metrics:nil views:NSDictionaryOfVariableBindings(_selectedView)]];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    self.numberLabel.highlighted = highlighted;
    self.lettersLabel.highlighted = highlighted;
}

#pragma mark - Touch Event

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:TYPinButtonAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        weakSelf.selectedView.alpha = 1.f;
        weakSelf.highlighted = YES;
    } completion:nil];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:TYPinButtonAnimationDuration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         weakSelf.selectedView.alpha = 0;
                         weakSelf.highlighted = NO;
                     } completion:nil];
}

#pragma mark - Setter / Getter

- (void)setLettersText:(NSString *)lettersText {
    NSMutableDictionary<NSString *, id> *attrs = [NSMutableDictionary dictionaryWithObject:@2 forKey:NSKernAttributeName];
    if (self.letterLabelFont) {
        [attrs setObject:self.letterLabelFont forKey:NSFontAttributeName];
    }
    self.lettersLabel.attributedText = [[NSAttributedString alloc] initWithString:lettersText ?: @"" attributes:attrs];
    if (lettersText.length > 0) {
        _lettersHiddenBottomConstraint.priority = UILayoutPriorityDefaultLow;
    }
}

- (NSString *)lettersText {
    return self.lettersLabel.attributedText.string;
}

- (void)setNumberText:(NSString *)numberText {
    self.numberLabel.text = numberText;
}

- (NSString *)numberText {
    return self.numberLabel.text;
}

- (void)setSelectedColor:(UIColor *)selectedColor {
    if (_selectedColor == selectedColor) {
        return;
    }
    _selectedColor = selectedColor;
    _selectedView.backgroundColor = selectedColor;
}

- (void)setNumberLabelFont:(UIFont *)numberLabelFont {
    if (_numberLabelFont == numberLabelFont) {
        return;
    }
    _numberLabelFont = numberLabelFont;
    _numberLabel.font = numberLabelFont;
}

- (void)setLetterLabelFont:(UIFont *)letterLabelFont {
    if (_letterLabelFont == letterLabelFont) {
        return;
    }
    _letterLabelFont = letterLabelFont;
    _lettersLabel.font = letterLabelFont;
}

- (void)setTextColor:(UIColor *)textColor {
    if (_textColor == textColor) {
        return;
    }
    _textColor = textColor;
    _numberLabel.textColor = textColor;
    _lettersLabel.textColor = textColor;
}

- (void)setHightlightedTextColor:(UIColor *)hightlightedTextColor {
    if (_hightlightedTextColor == hightlightedTextColor) {
        return;
    }
    _hightlightedTextColor = hightlightedTextColor;
    _numberLabel.highlightedTextColor = hightlightedTextColor;
    _lettersLabel.highlightedTextColor = hightlightedTextColor;
}

- (void)setBorderColor:(UIColor *)borderColor {
    if (_borderColor == borderColor) {
        return;
    }
    self.layer.borderColor = borderColor.CGColor;
}

#pragma mark - Helper

- (UILabel *)standardLabel {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.minimumScaleFactor = 1.f;
    return label;
}

@end
