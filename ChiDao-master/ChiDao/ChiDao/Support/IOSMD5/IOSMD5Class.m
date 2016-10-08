//
//  IOSMD5.m
//  QRCodeTools
//
//  Created by apple on 15/6/21.
//  Copyright (c) 2015年 雅讯东方（山东）科技有限公司. All rights reserved.
//

#import "IOSMD5Class.h"
#import "CommonCrypto/CommonDigest.h"
@implementation IOSMD5Class
+(NSString *) md5: (NSString *) inPutText
{
    const char *cStr = [inPutText UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

+ (NSString *) md5_16BIT: (NSString *) inPutText
{
    const char *cStr = [inPutText UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    
    return [[NSString stringWithFormat:
             @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] substringWithRange:NSMakeRange(8, 16)];
}

@end
