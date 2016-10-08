//
//  PayFailedViewController.h
//  Demo_1
//
//  Created by allen on 14-9-23.
//  Copyright (c) 2014年 itazk. All rights reserved.
//

#import "HisuntechBaseViewController.h"

@interface HisuntechPayFailedViewController : HisuntechBaseViewController

//支付失败
@property(nonatomic,strong)UILabel *payFailedLabel;
@property (strong,nonatomic)  UILabel *payNum;//交易金额
@property (strong,nonatomic)  UILabel *vouNUm;//凭证号

@property (strong,nonatomic) NSString *payNumStr;
@property (strong,nonatomic) NSString *vouNumStr;
@end
