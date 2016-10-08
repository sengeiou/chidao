//
//  AccountPayCell.h
//  Demo_1
//
//  Created by allen on 14-9-23.
//  Copyright (c) 2014年 itazk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HisuntechAccountPayCell : UITableViewCell{
    
    UIButton *_btnSelect;//点击按钮
    UILabel *_AccountMoney;//账户支付金额
    UILabel *_AccountPay;//账户支付
}

@property(nonatomic,retain) UIButton *btnSelect;//点击按钮
@property(nonatomic,retain) UILabel *AccountPay;//账户支付
@property(nonatomic,retain) UILabel *AccountMoney;//账户支付金额


@end
