//
//  UIButton+UIButtonImageWithLable.h
//  ChiDao
//
//  Created by 赵洋 on 16/7/13.
//  Copyright © 2016年 赵洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (UIButtonImageWithLable)
- (void) setImage:(UIImage *)image withTitle:(NSString *)title forState:(UIControlState)stateType;
@end
