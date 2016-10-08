//
//  QuickCreditPayCell.m
//  Demo_1
//
//  Created by allen on 14-9-23.
//  Copyright (c) 2014年 itazk. All rights reserved.
//

#import "HisuntechQuickCreditPayCell.h"

@implementation HisuntechQuickCreditPayCell

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
    self.btnSelect.frame = CGRectMake(-200, 12, 27, 26);
    NSString *path = ResourcePath(@"com_btn_checked.png");
    [self.btnSelect setBackgroundImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateSelected];
    [self addSubview:self.btnSelect];
    _creditPay = [[UILabel alloc]initWithFrame:CGRectMake(64, 14, 111, 21)];
    [self addSubview:_creditPay];
    _arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(286, 20, 14, 9)];
    path = ResourcePath(@"pull_down_btn.png");
    _arrowImageView.image =[UIImage imageWithContentsOfFile:path];
    [self addSubview:_arrowImageView];
}
- (void)changeArrowWithUp:(BOOL)up
{
     NSString *path = ResourcePath(@"pull_up_btn.png");
    if (up) {
        
        self.arrowImageView.image = [UIImage imageWithContentsOfFile:path];
    }else
    {
        path = ResourcePath(@"pull_down_btn.png");
        self.arrowImageView.image = [UIImage imageWithContentsOfFile:path];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
