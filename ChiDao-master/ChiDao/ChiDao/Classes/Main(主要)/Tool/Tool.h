//
//  Tool.h
//  ChiDao
//
//  Created by 赵洋 on 16/5/24.
//  Copyright (c) 2016年 赵洋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tool : NSObject

//获取基础参数字典
+(NSMutableDictionary *)getBaseDicWithAppID:(NSString *)appID withAPIVersion:(NSString *)version;

+(void)showMessage:(NSString *)message;
+(NSString *)getVersion;
//手机号验证
+ (BOOL) isMobile:(NSString *)mobileNumbel;
//颜色转换 IOS中十六进制的颜色转换为UIColor
+ (UIColor *) colorWithHexString: (NSString *)color;

//判断是否存在视频文件
+(BOOL) isExistFile:(NSString *)fileName;
//删除某个视频文件
+(void) removeFile:(NSString *)fileName;

+(void) removeMovFile:(NSString *)fileName;
//获取视频长度
+(int) getVideoFileSecond:(NSString *)fileName;
//获取当前时间
+(NSString *)getCurrentTime;
//获取车内视频大小
+ (float) fileSizeAtInCar;
//获取车外视频大小
+ (float) fileSizeAtOutCar;
//获取视频封面，本地视频，网络视频都可以用
+ (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL;

//获取ip
+ (NSString *)getIpAddresses;

//手机号隐藏中间4位
+ (NSString *)hidePhoneNum:(NSString *)phoneNum;

/*车牌号验证*/
+(BOOL)validateCarNo:(NSString*)carNo;

@end
