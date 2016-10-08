//
//  IOSMD5.h
//  QRCodeTools
//
//  Created by apple on 15/6/21.
//  Copyright (c) 2015年 雅讯东方（山东）科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IOSMD5Class : NSObject
+(NSString *) md5: (NSString *) inPutText;
+ (NSString *) md5_16BIT: (NSString *) inPutText;
@end
