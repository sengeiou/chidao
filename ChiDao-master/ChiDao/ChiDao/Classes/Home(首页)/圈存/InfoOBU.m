//
//  InfoOBU.m
//  TransferenceSDK
//
//  Created by 赵洋 on 16/8/4.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "InfoOBU.h"

@implementation InfoOBU

+  (InfoOBU*) shareInstance
{
    static InfoOBU* share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[super allocWithZone:NULL] init];
    });
    return share;
}
+ (instancetype) allocWithZone:(struct _NSZone *)zone
{
    return [self shareInstance];
}
-(NSString*) description{
    return [NSString stringWithFormat:@"<手机号:%@,本地圈存流水:%@>",self.phoneNum,self.loadseq];
}
@end
