//
//  OrderMoneyCell.h
//  Demo_1
//
//  Created by allen on 14-9-23.
//  Copyright (c) 2014年 itazk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HisuntechOrderMoneyCell : UITableViewCell{
    
    UILabel *_pleaseSure;//请确认信联支付金额提示
    UILabel *_orderMoney;//订单金额
}

@property(nonatomic,retain) UILabel *pleaseSure;//请确认信联支付金额提示
@property(nonatomic,retain) UILabel *orderMoney;//订单金额


@end
