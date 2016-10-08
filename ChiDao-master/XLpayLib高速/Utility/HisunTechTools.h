//
//  Tools.h
//  ZPay
//
//  Created by liao on 14-5-6.
//  Copyright (c) 2014年 thtf. All rights reserved.
//

#import <CFNetwork/CFNetwork.h>

@interface HisunTechTools : NSObject{
    
    CFTimeInterval  lastFrameStartTime;
}

-(NSString*)uuid;//设备唯一编号
-(NSString*)macaddress;//mac地址
-(NSString*)simulateAndRenderScene;//时间戳

/**
 *  动态获取IP地址
 */
+ (NSString *)localWiFiIPAddress;

@end
