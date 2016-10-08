//
//  WebPasswordKeyboard.h
//  CC iProtect Safety Input System for iOS
//
//  Copyright 2014年,2015年 北京云核网络技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebPasswordKeyboardDelegate.h"
#import "iProtectTypes.h"

@class WebPasswordKeyboard;

@protocol JSCallbackProtocol <NSObject>
@optional
- (void)passwordLength:(NSUInteger)length withWebPasswordKeyboard:(WebPasswordKeyboard*)keyboard;

//only called in WebPasswordKeyboardModeNormal mode
- (void)keyboardHeight:(float)height withWebPasswordKeyboard:(WebPasswordKeyboard*)keyboard;
@end

@interface WebPasswordKeyboard : NSObject <WebPasswordKeyboardProtocal>

@property (nonatomic, weak) UIWebView *webView;
@property (nonatomic, weak) id<JSCallbackProtocol> jsCallbackDelegate;

@property (nonatomic, strong) NSString *accepts;
@property (nonatomic, assign) uint32_t contentType;
@property (nonatomic, assign) BOOL passwordMode;
@property (nonatomic, strong) NSString *dictionaryWords;
@property (nonatomic, strong) NSString *applicationPlatformModulus;
@property (nonatomic, strong) NSString *encryptionPlatformModulus;
@property (nonatomic, strong) NSString *applicationPlatformPublicKey;
@property (nonatomic, strong) NSString *encryptionPlatformPublicKey;
@property (nonatomic, strong) NSString *applicationPlatformPublicKeyX;
@property (nonatomic, strong) NSString *applicationPlatformPublicKeyY;
@property (nonatomic, strong) NSString *encryptionPlatformPublicKeyX;
@property (nonatomic, strong) NSString *encryptionPlatformPublicKeyY;
@property (nonatomic, assign) uint32_t encryptType;
@property (nonatomic, assign) KeyboardType kbdType;
@property (nonatomic, assign) uint32_t minLength;
@property (nonatomic, assign) uint32_t maxLength;
@property (nonatomic, strong) NSString *maskChar;
@property (nonatomic, assign) BOOL kbdRandom;
@property (nonatomic, assign) TouchKeyType touchKeyType;
@property (nonatomic, assign) BOOL highlightEffect;

- (void)clear;
- (NSString*)getValue:(NSString*)timestamp;
- (NSString*)getValue:(NSString*)timestamp withPan:(NSString*)pan;
- (NSString*)getMeasureValue;
- (int16_t)verify;
- (int16_t)getLength;
- (int8_t)getComplexDegree;
- (uint32_t)getVertion;
- (NSString*)lastError;

- (void)showKeyboard;
- (void)hideKeyboard;

@end
