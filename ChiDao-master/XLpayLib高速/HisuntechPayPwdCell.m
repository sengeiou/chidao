//
//  PayPwdCell.m
//  Demo_1
//
//  Created by allen on 14-9-23.
//  Copyright (c) 2014年 itazk. All rights reserved.
//

#import "HisuntechPayPwdCell.h"
@implementation HisuntechPayPwdCell

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
    _payPwd = [[UITextField alloc]initWithFrame:CGRectMake(20, 10, 280, 30)];
    [self addSubview:_payPwd];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
