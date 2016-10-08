//
//  PasswordKeyboardDelegate.h
//  CC iProtect Safety Input System for iOS
//
//  Copyright 2014年,2015年 北京云核网络技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iProtectTypes.h"

@class Keyboard;

@interface PasswordKeyboardDelegate : NSObject <KeyboardDelegate> {
@protected
    BOOL usePasswordKeyboard;
    NSString *accepts;
    NSString *applicationPlatformModulus;
    NSString *applicationPlatformPublicKeyX;
    NSString *applicationPlatformPublicKeyY;
    NSString *encryptionPlatformModulus;
    NSString *encryptionPlatformPublicKeyX;
    NSString *encryptionPlatformPublicKeyY;
    NSString *timestamp;
    NSString *lastError;
    uint32_t encryptType;
    KeyboardType keyboardType;
    uint32_t minLength;
    uint32_t maxLength;
    NSString *maskChar;
    BOOL randomKeyboard;
    Keyboard *keyboard;
    NSMutableString *password;
    NSData *challengeCode;
    uint32_t contentType;
    BOOL passwordMode;
    NSString *secureKey;
    NSString *seed;
    WorkMode mode;
    NSString *dictionaryWords;
    float toolbarHeight;
}

@property (nonatomic, assign) BOOL usePasswordKeyboard;
@property (nonatomic, retain) NSString *accepts;
@property (nonatomic, retain) NSString *applicationPlatformModulus;
@property (nonatomic, retain) NSString *encryptionPlatformModulus;
@property (nonatomic, retain) NSString *applicationPlatformPublicKey;
@property (nonatomic, retain) NSString *encryptionPlatformPublicKey;
@property (nonatomic, retain) NSString *applicationPlatformPublicKeyX;
@property (nonatomic, retain) NSString *applicationPlatformPublicKeyY;
@property (nonatomic, retain) NSString *encryptionPlatformPublicKeyX;
@property (nonatomic, retain) NSString *encryptionPlatformPublicKeyY;
@property (nonatomic, retain) NSString *timestamp;
@property (nonatomic, retain) NSString *lastError;
@property (nonatomic, assign) uint32_t encryptType;
@property (nonatomic, assign) KeyboardType keyboardType;
@property (nonatomic, assign) uint32_t minLength;
@property (nonatomic, assign) uint32_t maxLength;
@property (nonatomic, retain) NSString *maskChar;
@property (nonatomic, assign) BOOL randomKeyboard;
@property (readonly) Keyboard *keyboard;
@property (nonatomic, assign) WorkMode mode;
@property (nonatomic, assign) TouchKeyType touchKeyType;
@property (nonatomic, assign) float toolbarHeight;
@property (nonatomic, assign) BOOL highlightEffect;

//For CCFCCB, used for co-operation with CFCA soft certificate system.
@property (nonatomic, retain) NSData *challengeCode;

//For OLP.
@property (nonatomic, retain) NSString *secureKey;
@property (nonatomic, retain) NSString *seed;

//For content validation, arguments for verify method.
@property (nonatomic, assign) uint32_t contentType;
@property (nonatomic, assign) BOOL passwordMode;
@property (nonatomic, retain) NSString *dictionaryWords;

- (id)initUsingPasswordKeyboard:(BOOL)use;
- (id)init;

- (NSString*)getValue;
- (NSString*)getMeasureValue;
- (int8_t)getComplexDegree;
/**********************************************************
 *
 * Name:
 *    vefify
 * Return Value:
 *    0 : 合法
 *   -1 : 内容为空
 *   -2 : 输入小于最小长度
 *   -3 : 输入字符不可接受
 *   -4 : 输入内容是简单密码
 *   -5 : 输入内容是字典密码
 *   -6 : 输入内容类型不符合
 *   -10: 未知错误
 *   -11: 初始化内容验证器错误
 *
 *********************************************************/
- (int16_t)verify;

//For OLP.
- (NSString*)getPasswordWithPan:(NSString*)pan;
- (NSString*)getPasswordWithUserName:(NSString*)name;
- (NSString*)getPasswordType2;

//For CCFCCB, used for co-operation with CFCA soft certificate system.
- (NSString*)getEncryptedPinCode;

//For HKB
- (NSString*)getMacAddress;

@end
