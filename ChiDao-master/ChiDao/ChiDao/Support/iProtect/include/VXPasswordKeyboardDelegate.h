//
//  VXPasswordKeyboardDelegate.h
//  CC iProtect Safety Input System for iOS
//
//  Copyright 2014年,2015年 北京云核网络技术有限公司. All rights reserved.
//

#import "PasswordKeyboardDelegate.h"
#import "iProtectTypes.h"

@protocol VXDelegate
@optional
- (void)textLength:(NSInteger)length withKeyboardDelegate:(id<KeyboardDelegate>)delegate;
- (void)enterKeyPressedWithKeyboardDelegate:(id<KeyboardDelegate>)delegate;
- (void)invalidCharacter:(unichar)ch withKeyboardDelegate:(id<KeyboardDelegate>)delegate;
- (void)maxTextLength:(NSInteger)length withKeyboardDelegate:(id<KeyboardDelegate>)delegate;
@end

@interface VXPasswordKeyboardDelegate : PasswordKeyboardDelegate {
@protected
    id<VXDelegate> vxDelegate;
}
@property (nonatomic, assign) id<VXDelegate> vxDelegate;

@end
