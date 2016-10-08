//
//  WebPasswordKeyboardDelegate.h
//  CC iProtect Safety Input System for iOS
//
//  Copyright 2014年,2015年 北京云核网络技术有限公司. All rights reserved.
//

#import "PasswordKeyboardDelegate.h"

@protocol WebPasswordKeyboardProtocal <NSObject>
@optional
- (void)textLength:(NSInteger)length;
- (void)enterKeyPressed;
- (void)maxTextLength:(NSInteger)length;
@end

@interface WebPasswordKeyboardDelegate : PasswordKeyboardDelegate

@property (nonatomic, weak) id<WebPasswordKeyboardProtocal> delegate;

@end
