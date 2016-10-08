//
//  CardTransactionRecord.h
//  ObuSDK
//
//  Created by HuangTimo on 15/8/7.
//  Copyright (c) 2015年 Timo Huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CardTransactionRecord : NSObject

@property(nonatomic, strong)NSString* onlineSn; //用户卡内产生的交易流水号
@property(nonatomic, strong)NSString* overdrawLimit; //透支限额
@property(nonatomic, strong)NSString* transAmount; //交易金额
@property(nonatomic, strong)NSString* transType; //交易类型标识:圈存/消费
@property(nonatomic, strong)NSString* terminalNo; //终端机编号
@property(nonatomic, strong)NSString* transDate; //交易日期CCYYMMDD
@property(nonatomic, strong)NSString* transTime; //交易时间HHMMSS

-(NSString*)description;

@end
