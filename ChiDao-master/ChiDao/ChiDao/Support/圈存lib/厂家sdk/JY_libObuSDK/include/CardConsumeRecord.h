//
//  CardConsumeRecord.h
//  ObuSDK
//
//  Created by HuangTimo on 15/8/7.
//  Copyright (c) 2015年 Timo Huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CardConsumeRecord : NSObject

@property(nonatomic, strong)NSString* applicationId; //复合应用类型标识符
@property(nonatomic, strong)NSString* recordLength; //记录长度
@property(nonatomic, strong)NSString* applicationLockFlag; //应用锁定标志
@property(nonatomic, strong)NSString* tollRoadNetworkId; // 入/出口收费路网号
@property(nonatomic, strong)NSString* tollStationId; // 入/出口收费站号
@property(nonatomic, strong)NSString* tollLaneId; // 入/出口收费车道号
@property(nonatomic, strong)NSString* timeUnix; // 入/出口时间 UNIX时间
@property(nonatomic, strong)NSString* vehicleModel; //车型
@property(nonatomic, strong)NSString* passStatus; // 入出口状态
@property(nonatomic, strong)NSString* reserve1; //保留字节1
@property(nonatomic, strong)NSString* staffNo; //收费员工号 二进制方式存放入口员工号后六位
@property(nonatomic, strong)NSString* mtcSequenceNo; //收费员工号 二进制方式存放入口员工号后六位
@property(nonatomic, strong)NSString* vehicleNumber; //车牌号码
@property(nonatomic, strong)NSString* reserve2; //保留字节2

-(NSString*) description;

@end
