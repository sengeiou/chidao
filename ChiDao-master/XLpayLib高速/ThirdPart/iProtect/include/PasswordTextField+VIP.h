//
//  PasswordTextField+VIP.h
//  CC iProtect Safety Input System for iOS
//
//  Copyright 2014年,2015年 北京云核网络技术有限公司. All rights reserved.
//

#import "PasswordTextField.h"

@interface PasswordTextField (VIP)

- (NSString*)getValueWithTimeStamp:(NSString*)timestamp withSalt:(NSString*)salt usingFullMD5Value:(BOOL)flag;

@end
