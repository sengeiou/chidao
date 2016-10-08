//
//  QuickPayMoneyCell.m
//  Demo_1
//
//  Created by allen on 14-9-23.
//  Copyright (c) 2014年 itazk. All rights reserved.
//

#import "HisuntechQuickPayMoneyCell.h"

@implementation HisuntechQuickPayMoneyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}
- (void)createUI
{
    _QuickPay = [[UILabel alloc]initWithFrame:CGRectMake(20, 11, 91, 21)];
    self.contentView.backgroundColor =[UIColor colorWithRed:235/255.0 green:241/255.0 blue:245/255.0 alpha:1];
    _QuickPay.textColor = [UIColor lightGrayColor];
    _QuickPay.text = @"快捷支付";
    _QuickPay.font = [UIFont systemFontOfSize:15.0];
//    [self addSubview:_QuickPay];
    self.backgroundColor = [UIColor lightGrayColor];
    self.QuickMoney = [[UILabel alloc]initWithFrame:CGRectMake(202, 11, 130, 21)];
    self.QuickMoney.font = [UIFont systemFontOfSize:15.0];
    //self.QuickMoney.textColor = [UIColor lightGrayColor];
//    _QuickMoney.text = @"￥60.00元";
//    [self addSubview:self.QuickMoney];
    
    
//    [self.contentView addObserver:self forKeyPath:@"self.QuickMoney" options:NSKeyValueObservingOptionNew context:nil];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
