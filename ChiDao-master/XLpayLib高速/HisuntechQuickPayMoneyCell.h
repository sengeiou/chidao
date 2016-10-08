//
//  QuickPayMoneyCell.h
//  Demo_1
//
//  Created by allen on 14-9-23.
//  Copyright (c) 2014年 itazk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HisuntechQuickPayMoneyCell : UITableViewCell{
    
    UILabel *_QuickMoney;//快捷支付金额
    UILabel *_QuickPay;//快捷支付
}
@property(nonatomic,retain) UILabel *QuickPay;//快捷支付
@property(nonatomic,retain) UILabel *QuickMoney;//快捷支付金额


@end
