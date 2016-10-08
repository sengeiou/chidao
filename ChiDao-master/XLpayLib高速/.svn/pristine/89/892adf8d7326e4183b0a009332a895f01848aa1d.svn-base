//
//  HisuntechBankPayViewCell.m
//  hisuntechSdk
//
//  Created by 范胜利 on 15/6/10.
//  Copyright (c) 2015年 com.hisuntech. All rights reserved.
//

#import "HisuntechBankPayViewCell.h"

@implementation HisuntechBankPayViewCell

- (void)awakeFromNib {
    // Initialization code
}

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
    self.btnSelect = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnSelect.frame = CGRectMake(20, 15, 22, 21);
    NSString *path = ResourcePath(@"choicebox_btn_n.png");
    [self.btnSelect setBackgroundImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateSelected];
    path = ResourcePath(@"circle_ic.png");
    [self.btnSelect setBackgroundImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateNormal];
    [self.contentView addSubview:self.btnSelect];
    
    self.AccountPay = [[UILabel alloc]initWithFrame:CGRectMake(89, 14, 112, 21)];
    self.AccountPay.font = [UIFont boldSystemFontOfSize:16];
    [self.contentView addSubview:self.AccountPay];
    
    UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(53, 8, 31, 31)];
    iconImage.image = [UIImage imageWithContentsOfFile:ResourcePath(@"bg_checkbox_yinlian.png")];
    [self.contentView addSubview:iconImage];
    
    
    //这个 箭头去掉了
//    UIImageView *gotoImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 15,20)];
//    gotoImage.center = CGPointMake(self.bounds.size.width - 30, 25);
//    gotoImage.image = [UIImage imageWithContentsOfFile:ResourcePath(@"Back_Black_Btn.png")];
//    [self.contentView addSubview:gotoImage];

    
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 49, [UIScreen mainScreen].bounds.size.width, 1)];
    view.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
    [self.contentView addSubview:view];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
