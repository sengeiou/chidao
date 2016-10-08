//
//  AccountPayCell.m
//  Demo_1
//
//  Created by allen on 14-9-23.
//  Copyright (c) 2014年 itazk. All rights reserved.
//

#import "HisuntechAccountPayCell.h"
#import "HisuntechUIColor+YUColor.h"
@implementation HisuntechAccountPayCell

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
    //self.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"orders_touch_but_2.png"]];
    self.btnSelect = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnSelect.frame = CGRectMake(20, 15, 22, 21);
    NSString *path = ResourcePath(@"choicebox_btn_n.png");
    [self.btnSelect setBackgroundImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateSelected];
    path = ResourcePath(@"circle_ic.png");
    [self.btnSelect setBackgroundImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateNormal];
    [self.contentView addSubview:self.btnSelect];
    
    _AccountMoney = [[UILabel alloc]initWithFrame:CGRectMake(89, 14, 112, 21)];
    _AccountMoney.text = @"账户余额：";
    _AccountPay.userInteractionEnabled = YES;
    _AccountMoney.font = [UIFont boldSystemFontOfSize:16];
    [self.contentView addSubview:_AccountMoney];
    
    self.AccountPay = [[UILabel alloc]initWithFrame:CGRectMake(162+40, 14, 112, 21)];
    self.AccountPay.tag = -1;
    self.AccountPay.textColor = [UIColor colorWithHexString:@"#41b886" withAlpha:1];
    self.AccountPay.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.AccountPay];
    
    UIImageView *cellIcon = [[UIImageView alloc]initWithFrame:CGRectMake(53, 8, 31, 31)];
    path = ResourcePath(@"Balance_btn.png");
    cellIcon.userInteractionEnabled = YES;
    cellIcon.image = [UIImage imageWithContentsOfFile:path];
    [self.contentView addSubview:cellIcon];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 49, [UIScreen mainScreen].bounds.size.width, 1)];
    view.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
    [self.contentView addSubview:view];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
