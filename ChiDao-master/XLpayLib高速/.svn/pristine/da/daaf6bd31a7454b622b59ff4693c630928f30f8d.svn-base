//
//  BgView.m
//  Demo_1
//
//  Created by 王鑫 on 14-10-29.
//  Copyright (c) 2014年 itazk. All rights reserved.
//

#import "HisuntechBgView.h"

@implementation HisuntechBgView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIView *bgView = [[UIView alloc]initWithFrame:self.bounds];
        bgView.backgroundColor = [UIColor whiteColor];
        
        UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1)];
        topLine.backgroundColor = [UIColor colorWithRed:0.769 green:0.779 blue:0.787 alpha:1.000]
        ;
        [bgView addSubview:topLine];
        
        
        UIView *footLine = [[UIView alloc]initWithFrame:CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, 1)];
        footLine.backgroundColor = [UIColor colorWithRed:0.769 green:0.779 blue:0.787 alpha:1.000]
        ;
        [bgView addSubview:footLine];
        
        [self addSubview:bgView];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
