//
//  paySDK.m
//  Demo_1
//
//  Created by Jany on 14-11-22.
//  Copyright (c) 2014年 itazk. All rights reserved.
//

#import "HisuntechPaySDK.h"
#import "HisuntechUserEntity.h"
@implementation HisuntechPaySDK
+(void)sendPayMessageOfApp:(NSDictionary *)messageDic
{
    HisuntechUserEntity *user = [HisuntechUserEntity Instance];
    user.ACTION = [messageDic objectForKey:@"ACTION"];
    user.userId = [messageDic objectForKey:@"USRID"];
    user.userNo = [messageDic objectForKey:@"USRNO"];
    user.CREDT = [messageDic objectForKey:@"CREDT"];
    user.CRETM = [messageDic objectForKey:@"CRETM"];
    user.PARTNER_NAME = [messageDic objectForKey:@"PARTNER_NAME"];
    user.PRODUCT_NAME = [messageDic objectForKey:@"PRODUCT_NAME"];
    user.ORDNO = [messageDic objectForKey:@"ORDNO"];
    user.MERORDNO = [messageDic objectForKey:@"MERORDNO"];
    user.TOTAL_AMOUNT = [messageDic objectForKey:@"TOTAL_AMOUNT"];
    user.MERC_ID = [messageDic objectForKey:@"MERC_ID"];
}
+(void)sendPayMessageOfMall:(NSDictionary *)messageDic
               withUnionpay:(BOOL)one//银联
                withAccount:(BOOL)two//账户
                withMicture:(BOOL)three//混合
{
    HisuntechUserEntity *user = [HisuntechUserEntity Instance];
    user.UnionPay = one;
    user.Account = two;
    user.Mixture = three;
    
//    user.CHARSET = [messageDic objectForKey:@"charset"];//字符集
//    user.ACTION = [messageDic objectForKey:@"action"];//
//    user.REQ_DATA = [messageDic objectForKey:@"req_data"];
//    user.REQ_CERT = [messageDic objectForKey:@"req_cert"];
//    user.REQ_SIGN = [messageDic objectForKey:@"req_sign"];
//    user.SIGN_TYPE = [messageDic objectForKey:@"sign_type"];
    
    user.CHARSET = [messageDic objectForKey:@"CHARSET"];//字符集
    user.ACTION = [messageDic objectForKey:@"ACTION"];//
    user.REQ_DATA = [messageDic objectForKey:@"REQ_DATA"];
    user.REQ_CERT = [messageDic objectForKey:@"REQ_CERT"];
    user.REQ_SIGN = [messageDic objectForKey:@"REQ_SIGN"];
    user.SIGN_TYPE = [messageDic objectForKey:@"SIGN_TYPE"];
}


@end
