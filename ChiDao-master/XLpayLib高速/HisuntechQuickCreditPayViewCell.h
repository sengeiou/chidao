//
//  QuickCreditPayViewCell.h
//  Demo_1
//
//  Created by mac on 14-10-24.
//  Copyright (c) 2014年 itazk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HisuntechQuickCreditPayViewCell : UITableViewCell
@property(nonatomic,retain) UIButton *btnSelect;//点击按钮
@property(nonatomic,retain) UILabel *creditPay;//信用卡支付
@property(nonatomic,retain) UIImageView *arrowImageView;//打开
@property(nonatomic,retain) UIView *bankView;//银行卡显示
@property(nonatomic,retain) UILabel *creditNum;//借记卡尾号
@end
