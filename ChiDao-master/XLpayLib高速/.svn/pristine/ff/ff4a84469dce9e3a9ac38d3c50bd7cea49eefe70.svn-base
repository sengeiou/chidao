//
//  QuickCreditPayViewCell.m
//  Demo_1
//
//  Created by mac on 14-10-24.
//  Copyright (c) 2014年 itazk. All rights reserved.
//

#import "HisuntechQuickCreditPayViewCell.h"

@implementation HisuntechQuickCreditPayViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.clipsToBounds = YES;
        [self createUI];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}
- (void)createUI
{
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
    //bgView.image =[UIImage imageNamed:@"orders_touch_but_2.png"];
    [self addSubview:bgView];
    self.bankView = [[UIView alloc]initWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, 100)];
    
    //self.bankView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.bankView];
    self.btnSelect = [UIButton buttonWithType:UIButtonTypeCustom];
    
    NSString *path = ResourcePath(@"choicebox_btn_n.png");
    self.btnSelect.frame = CGRectMake(20, 15, 22, 21);
    [self.btnSelect setBackgroundImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateSelected];
    [self addSubview:self.btnSelect];
    _creditPay = [[UILabel alloc]initWithFrame:CGRectMake(89, 14, 111, 21)];
    _creditPay.font = [UIFont boldSystemFontOfSize:16];
    [self addSubview:_creditPay];
    _arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(286, 20, 14, 8)];
    path = ResourcePath(@"pull_down_btn.png");
    _arrowImageView.image =[UIImage imageWithContentsOfFile:path];
    [self addSubview:_arrowImageView];
    
    self.creditNum = [[UILabel alloc]initWithFrame:CGRectMake(202, 14, 90, 28)];
    
    [self addSubview:self.creditNum];
    
    UIImageView *cellIcon = [[UIImageView alloc]initWithFrame:CGRectMake(53, 8, 31, 31)];
    path = ResourcePath(@"visa_ic.png");
    cellIcon.image = [UIImage imageWithContentsOfFile:path];
    [self addSubview:cellIcon];

    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 49, [UIScreen mainScreen].bounds.size.width, 1)];
    view.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
    [self addSubview:view];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
