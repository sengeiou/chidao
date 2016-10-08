//
//  QuickPayItemCell.m
//  Demo_1
//
//  Created by allen on 14-9-23.
//  Copyright (c) 2014年 itazk. All rights reserved.
//

#import "HisuntechQuickPayItemCell.h"

@implementation HisuntechQuickPayItemCell

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
    _bankLogo = [[UIImageView alloc]initWithFrame:CGRectMake(20, 8, 35, 34)];
    NSString *path = ResourcePath(@"bank2_ic.png");
    _bankLogo.image = [UIImage imageWithContentsOfFile:path];
    [self addSubview:_bankLogo];
    _cardNo = [[UILabel alloc]initWithFrame:CGRectMake(73, 11, 200, 28)];
    _cardNo.font = [UIFont systemFontOfSize:17];
    [self addSubview:_cardNo];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
