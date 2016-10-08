//
//  iProtect.h
//  CC iProtect Safety Input System for iOS
//
//  Copyright 2014年,2015年 北京云核网络技术有限公司. All rights reserved.
//

#ifndef I_PROTECT_H
#define I_PROTECT_H

#ifdef __cplusplus
extern "C" {
#endif

#import <Foundation/Foundation.h>
#import "PasswordTextField.h"
#import "EditTextField.h"
#import "iProtectTypes.h"
#import "PasswordKeyboardDelegate.h"
#import "VXPasswordKeyboardDelegate.h"

void iProtectInitialize(void);
    
NSString *iProtectHMAC(uint32_t type, const char* msg, const size_t msgLength);
    
/************************************************************************************
 *
 * 参数说明:
 *    type: 加密类型，见xcconfig文件中注释
 *    applicationPlatformPublicKey: 应用平台公钥，根据加密类型设置，不需要此参数时传nil
 *    encryptionPlatformPublicKey: 加密平台公钥根据加密类型设置，不需要此参数时传nil
 *    timestamp: 服务器时间，不需要此参数时传nil
 *    msg: 明文字符串，json格式，且外层一定是对象，不能是数组
 *    注: 公钥格式，RSA算法传公钥模数，国密SM2算法传坐标，X和Y中间用逗号分隔
 * 返回值说明: 加密成功时返回密文，加密失败时返回nil
 ***********************************************************************************/
NSString *iProtectEncrypt(uint32_t type, NSString *applicationPlatformPublicKey,
                          NSString *encryptionPlatformPublicKey, NSString *timestamp,
                          const char *msg);

/************************************************************************************
 *
 * 参数说明:
 *    type: 加密类型，见xcconfig文件中注释
 *    applicationPlatformPublicKey: 应用平台公钥，根据加密类型设置，不需要此参数时传nil
 *    encryptionPlatformPublicKey: 加密平台公钥根据加密类型设置，不需要此参数时传nil
 *    timestamp: 服务器时间，不需要此参数时传nil
 *    msg: 明文字符串，json格式，且外层一定是对象，不能是数组
 *    error: 加密出错时，返回具体的错误信息，当不关心具体错误信息时，可以传nil
 *    注: 公钥格式，RSA算法传公钥模数，国密SM2算法传坐标，X和Y中间用逗号分隔
 * 返回值说明: 加密成功时返回密文，加密失败时返回nil
 ***********************************************************************************/
NSString *iProtectEncryptWithError(uint32_t type, NSString *applicationPlatformPublicKey,
                              NSString *encryptionPlatformPublicKey, NSString *timestamp,
                              const char *msg, NSError * __autoreleasing * error);
    
#ifdef __cplusplus
}
#endif

#endif
