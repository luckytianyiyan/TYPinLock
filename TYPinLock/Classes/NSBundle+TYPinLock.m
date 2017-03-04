//
//  NSBundle+TYPinLock.m
//  Pods
//
//  Created by luckytianyiyan on 17/1/10.
//
//

#import "NSBundle+TYPinLock.h"
#import "TYPinLockView.h"

@implementation NSBundle (TYPinLock)

+ (nullable NSBundle *)typ_bundle {
    return [NSBundle bundleWithPath:[[NSBundle bundleForClass:[TYPinLockView class]] pathForResource:@"TYPinLock" ofType:@"bundle"]];
}

@end
