//
//  UIButton+UIButtonImageWithLable.m
//  ChiDao
//
//  Created by 赵洋 on 16/7/13.
//  Copyright © 2016年 赵洋. All rights reserved.
//

#import "UIButton+UIButtonImageWithLable.h"

@implementation UIButton (UIButtonImageWithLable)
- (void) setImage:(UIImage *)image withTitle:(NSString *)title forState:(UIControlState)stateType {
    //UIEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
    
    CGSize size = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    [self.imageView setContentMode:UIViewContentModeCenter];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0.0,
                                              5.0,
                                              0.0,
                                              self.frame.size.width-5-image.size.width)];
    [self setImage:image forState:stateType];
    
    [self.titleLabel setContentMode:UIViewContentModeCenter];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0,
                                              0,
                                              0.0,
                                              5.0)];
    [self setTitle:title forState:stateType];
}
@end
