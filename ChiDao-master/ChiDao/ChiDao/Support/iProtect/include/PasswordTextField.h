//
//  PasswordTextField.h
//  CC iProtect Safety Input System for iOS
//
//  Copyright 2014年,2015年 北京云核网络技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iProtectTypes.h"
#import "PasswordKeyboardDelegate.h"

@interface PasswordTextField : UITextField {
@private
    BOOL usePasswordKeyboard;
    PasswordKeyboardDelegate<UITextFieldDelegate> *passwordTextFieldDelegate;
}

@property (nonatomic, readonly) PasswordKeyboardDelegate<UITextFieldDelegate> *passwordTextFieldDelegate;
@property (nonatomic, assign) BOOL usePasswordKeyboard;
@property (nonatomic, retain) NSString *accepts;
@property (nonatomic, assign) uint32_t contentType;
@property (nonatomic, assign) BOOL passwordMode;
@property (nonatomic, retain) NSString *dictionaryWords;
@property (nonatomic, retain) NSString *applicationPlatformModulus;
@property (nonatomic, retain) NSString *encryptionPlatformModulus;
@property (nonatomic, retain) NSString *applicationPlatformPublicKey;
@property (nonatomic, retain) NSString *encryptionPlatformPublicKey;
@property (nonatomic, retain) NSString *applicationPlatformPublicKeyX;
@property (nonatomic, retain) NSString *applicationPlatformPublicKeyY;
@property (nonatomic, retain) NSString *encryptionPlatformPublicKeyX;
@property (nonatomic, retain) NSString *encryptionPlatformPublicKeyY;
@property (nonatomic, assign) uint32_t encryptType;
@property (nonatomic, assign) KeyboardType kbdType;
@property (nonatomic, assign) uint32_t minLength;
@property (nonatomic, assign) uint32_t maxLength;
@property (nonatomic, retain) NSString *maskChar;
@property (nonatomic, assign) BOOL kbdRandom;
@property (nonatomic, assign) TouchKeyType touchKeyType;
@property (nonatomic, assign) WorkMode mode;
@property (nonatomic, assign) BOOL keyboardHiddenOnOKKeyClicked;
@property (nonatomic, assign) BOOL highlightEffect;

@property (nonatomic, assign) BOOL monitorScreenshots;

- (id)initWithCoder:(NSCoder *)aDecoder usingPasswordKeyboard:(BOOL)use;
- (id)initWithFrame:(CGRect)frame usingPasswordKeyboard:(BOOL)use;

- (void)clear;
- (NSString*)getValue:(NSString*)timestamp;
- (NSString*)getValue:(NSString*)timestamp withPan:(NSString*)pan;
- (NSString*)getMeasureValue;
- (int16_t)verify;
- (int16_t)getLength;
- (int8_t)getComplexDegree;
- (uint32_t)getVertion;
- (NSString*)lastError;

//For HKB
- (NSString*)getMacAddress:(NSString*)timestamp;

@end
