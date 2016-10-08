//
//  paySDK.h
//  Demo_1
//
//  Created by Jany on 14-11-22.
//  Copyright (c) 2014年 itazk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HisuntechPaySDK : NSObject
+(void)sendPayMessageOfApp:(NSDictionary*)messageDic;
+(void)sendPayMessageOfMall:(NSDictionary *)messageDic withUnionpay:(BOOL)one withAccount:(BOOL)two withMicture:(BOOL)three;
@end
