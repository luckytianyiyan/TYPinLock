//
//  NSBundle+TYPinLock.m
//  Pods
//
//  Created by yinhun on 17/1/10.
//
//

#import "NSBundle+TYPinLock.h"

@implementation NSBundle (TYPinLock)

+ (NSBundle *)typ_bundle {
    return [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"TYPinLock" ofType:@"bundle"]];
}

@end
