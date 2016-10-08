//
//  PasswordKeyboardDelegate+VIP.h
//  CC iProtect Safety Input System for iOS
//
//  Copyright 2014年,2015年 北京云核网络技术有限公司. All rights reserved.
//

#import "PasswordKeyboardDelegate.h"

@interface PasswordKeyboardDelegate (VIP)

- (NSString*)getValueWithSalt:(NSString*)salt UsingFullMD5Value:(BOOL)flag;

@end
