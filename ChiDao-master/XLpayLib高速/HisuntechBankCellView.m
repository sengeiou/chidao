//
//  BankCellView.m
//  Demo_1
//
//  Created by mac on 14-10-24.
//  Copyright (c) 2014年 itazk. All rights reserved.
//

#import "HisuntechBankCellView.h"

@implementation HisuntechBankCellView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame =frame;
        self.backgroundColor = [UIColor whiteColor];
        NSString *path = ResourcePath(@"bank2_ic.png");

        _bankLogo = [[UIImageView alloc]initWithFrame:CGRectMake(20, 8, 35, 34)];
        _bankLogo.image = [UIImage imageWithContentsOfFile:path];
        [self addSubview:_bankLogo];
        
        self.bankName = [[UILabel alloc]initWithFrame:CGRectMake(73, 11, 150, 28)];
        self.bankName.font = [UIFont systemFontOfSize:17];
        [self addSubview:self.bankName];
        
        _cardNo = [[UILabel alloc]initWithFrame:CGRectMake(223, 11, 90, 28)];
        _cardNo.font = [UIFont systemFontOfSize:17];
        [self addSubview:_cardNo];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-1, [UIScreen mainScreen].bounds.size.width, 1)];
        view.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:view];
        self.clickBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.clickBtn.frame = self.bounds;
        [self addSubview:self.clickBtn];
    }
    return self;
}
@end
