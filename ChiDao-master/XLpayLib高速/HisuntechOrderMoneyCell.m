//
//  OrderMoneyCell.m
//  Demo_1
//
//  Created by allen on 14-9-23.
//  Copyright (c) 2014年 itazk. All rights reserved.
//

#import "HisuntechOrderMoneyCell.h"
#import "HisuntechUIColor+YUColor.h"
@implementation HisuntechOrderMoneyCell

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
    NSString *path = ResourcePath(@"cover_btn.png");
    self.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:path]];
    _pleaseSure = [[UILabel alloc]initWithFrame:CGRectMake(20, 14, 216, 21)];
    _pleaseSure.text = @"确认支付(元)";
    _pleaseSure.textColor = [UIColor blackColor];
    _pleaseSure.font = [UIFont systemFontOfSize:15.0];
    [self addSubview:_pleaseSure];
    _orderMoney = [[UILabel alloc]initWithFrame:CGRectMake(20, 63, 152, 21)];
    _orderMoney.font = [UIFont boldSystemFontOfSize:29];
    _orderMoney.adjustsFontSizeToFitWidth = YES;
    _orderMoney.textColor = [UIColor colorWithHexString:@"#41b886" withAlpha:1];
    _orderMoney.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_orderMoney];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
}

@end
