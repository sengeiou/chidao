//
//  AddView.m
//  Demo_1
//
//  Created by mac on 14-10-24.
//  Copyright (c) 2014年 itazk. All rights reserved.
//

#import "HisuntechAddView.h"

@implementation HisuntechAddView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.frame =frame;
        self.text = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.text.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50);
        [self addSubview:self.text];
        [self.text setTintColor:[UIColor blackColor]];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-1, [UIScreen mainScreen].bounds.size.width, 1)];
        view.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:view];
    }
    return self;
}

@end
