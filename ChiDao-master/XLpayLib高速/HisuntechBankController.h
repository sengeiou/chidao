//
//  BankController.h
//  HisunPay
//
//  Created by allen on 14/11/19.
//  Copyright (c) 2014年 com.hisuntech. All rights reserved.
//

#import "HisuntechBaseViewController.h"

@protocol BankDelegate <NSObject>

- (void)passValue1:(NSDictionary *)bankDic;

@end

@interface HisuntechBankController : HisuntechBaseViewController

@property (nonatomic,assign) id<BankDelegate> delegate;
//银行数据源
@property(nonatomic,retain)NSMutableArray *bankNmArr;
//银行简称数据源
@property(nonatomic,retain)NSMutableArray *bankNoArr;
@end
