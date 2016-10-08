//
//  SurePayCell.m
//  Demo_1
//
//  Created by allen on 14-9-23.
//  Copyright (c) 2014年 itazk. All rights reserved.
//

#import "HisuntechSurePayCell.h"
#import "HisuntechUIColor+YUColor.h"
@implementation HisuntechSurePayCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
        [self createUI];
    }
    return self;
}
- (void)createUI
{
    _surePay = [UIButton buttonWithType:UIButtonTypeCustom];
    _surePay.frame = CGRectMake(20,10, 280, 42);
    [_surePay setBackgroundColor:[UIColor colorWithHexString:@"#41b886" withAlpha:1]];
    _surePay.layer.cornerRadius = 4;
    _surePay.clipsToBounds = YES;
    [_surePay setTitle:@"确定支付" forState:UIControlStateNormal];
    [self.contentView addSubview:_surePay];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
