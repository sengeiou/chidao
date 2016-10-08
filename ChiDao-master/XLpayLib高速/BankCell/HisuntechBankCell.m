//
//  BankCell.m
//  HisunPay
//
//  Created by allen on 14/11/9.
//  Copyright (c) 2014年 com.hisuntech. All rights reserved.
//

#import "HisuntechBankCell.h"

@implementation HisuntechBankCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _bankLogo = [[UIImageView alloc]initWithFrame:CGRectMake(15, 2, 40, 40)];
        [self.contentView addSubview:_bankLogo];
        _bankName = [[UILabel alloc]initWithFrame:CGRectMake(63, 10, 211, 23)];
        [self.contentView addSubview:_bankName];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
