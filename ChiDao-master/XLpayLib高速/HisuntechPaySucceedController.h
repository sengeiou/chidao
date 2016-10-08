//
//  PaySucceedController.h
//  Demo_1
//
//  Created by allen on 14-9-23.
//  Copyright (c) 2014年 itazk. All rights reserved.
//

#import "HisuntechBaseViewController.h"

@interface HisuntechPaySucceedController : HisuntechBaseViewController

@property (strong, nonatomic) UILabel *paySucceedTitle;
@property (strong,nonatomic)  UILabel *payNum;//交易金额
@property (strong,nonatomic)  UILabel *vouNUm;//凭证号
@property (strong,nonatomic) NSString *payNumStr;

@property (copy,nonatomic) NSString *dealNum;

@end
