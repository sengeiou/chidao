//
//  iProtectTypes.h
//  CC iProtect Safety Input System for iOS
//
//  Copyright 2014年,2015年 北京云核网络技术有限公司. All rights reserved.
//

#ifndef iProtect_iProtectTypes_h
#define iProtect_iProtectTypes_h

#define PasswordKeyboardViewWillRotateNotification @"PasswordKeyboardViewWillRotateNotification"
#define PasswordKeyboardViewDidRotateNotification  @"PasswordKeyboardViewDidRotateNotification"

#define PasswordChangedNotification    @"CCPasswordChangedNotification"
#define kPasswordOldLength             @"kCCPasswordOldLength"
#define kPasswordCurrentLength         @"kCCPasswordCurrentLength"
#define kPasswordTextField             @"kCCPasswordTextField"

#define EditChangedNotification    @"CCEditChangedNotification"
#define kEditOldLength             @"kCCEditOldLength"
#define kEditCurrentLength         @"kCCEditCurrentLength"
#define kEditTextField             @"kCCEditTextField"

#define InvalidPasswordNotification    @"CCInvalidPasswordNotification"
#define kKeyboardDelegate              @"kCCKeyboardDelegate"

#define PasswordBeginEditingNotification   @"CCPasswordBeginEditingNotification"
#define PasswordEndEditingNotification     @"CCPasswordEndEditingNotification"
#define EditBeginEditingNotification       @"CCEditBeginEditingNotification"
#define EditEndEditingNotification         @"CCEditEndEditingNotification"
#define OKKeyClickedNotification           @"CCOKKeyClickedNotification"

#define LANDSCAPE_FRAME_HD  (CGRectMake(0, 0, 1024, 351))
#define PORTRAIT_FRAME_HD   (CGRectMake(0, 0, 768, 263))

#define PORTRAIT_FRAME      (CGRectMake(0, 0, 320, 216))
#define LANDSCAPE_FRAME     (CGRectMake(0, 0, 480, 161))

#define V_OK                                0
#define V_ERROR_EMPTY                       -1
#define V_ERROR_TOO_SHORT                   -2
#define V_ERROR_NOT_ACCEPT                  -3
#define V_ERROR_SIMPLE_PASSWORD             -4
#define V_ERROR_DICTIONARY_PASSWORD         -5
#define V_ERROR_TYPE_NO_MATCH               -6
#define V_ERROR_UNKNOWN                     -10
#define V_ERROR_INIT_VALIDATOR              -11

#define V_DICTIONARY_SEPARATOR              ','

#define V_CONTENTTYPE_ANY                   0x00000000
#define V_CONTENTTYPE_NUM                   0x00000001
#define V_CONTENTTYPE_LETTER                0x00000002
#define V_CONTENTTYPE_PUNCT                 0x00000004

/**********************************************************
 *
 * 在iPhone和Touch上，按键行为定义
 * TouchKeyTypeAuto               //放大的按键在未越狱环境弹起，
 *                                //越狱环境不弹起
 * TouchKeyTypeAlways             //放大的按键总是弹起
 * TouchKeyTypeNone               //放大的按键永不弹起
 *
 *********************************************************/
typedef enum {
    TouchKeyTypeAuto,
    TouchKeyTypeAlways,
    TouchKeyTypeNone
} TouchKeyType;

/**********************************************************
 *
 * KeyboardTypeLowerCaseLetter     //小写字母键盘
 * KeyboardTypeCapitalLetter       //大写字母键盘
 * KeyboardTypeNumber              //数字键盘
 * KeyboardTypeSymbol              //符号键盘
 * KeyboardTypePinNumber           //用来输入纯数字的iPhone键盘
 *
 *********************************************************/
typedef enum {
    KeyboardTypeLowerCaseLetter,
    KeyboardTypeCapitalLetter,
    KeyboardTypeNumber,
    KeyboardTypeSymbol,
    KeyboardTypePinNumber
} KeyboardType;


typedef enum {
    //Common Environment
    Product = 0,
    Test,
    Development,
    
    //OLP
    OLP_Product_1024 = 10,
    OLP_Product_2048,
    OLP_Test,
    OLP_Development
} WorkMode;

@protocol KeyboardDelegate <NSObject>
@optional
@property (nonatomic, assign) TouchKeyType touchKeyType;

@required
- (void)appendCharacter:(unichar)aChar;
- (void)backspace;
- (void)enter;
- (NSUInteger)textLength;
- (void)clear;
- (void)reloadKeyboard;
@end

extern BOOL isPortrait(void);
extern BOOL isLandscape(void);
extern CGRect CGRectByFactor(CGRect rect, BOOL portrait);

#pragma mark - Error Codes

#define ErrorDomain @"iProtectErrorDomain"

#define ErrorInvalidParametersCode 201
#define ErrorInvalidParametersDescription @"错误的参数"

#define ErrorInvalidJsonStringCode 202
#define ErrorInvalidJsonStringDescription @"原文不是json字符串"

#endif
