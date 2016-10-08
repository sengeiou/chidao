//
//  UITextField+LimitLength.h
//  shufa
//
//  Created by 赵洋 on 15/10/16.
//  Copyright (c) 2015年 zy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (LimitLength)
- (void)limitTextLength:(int)length;
/**
 *  uitextField 抖动效果
 */
- (void)shake;

-(void)setTextFieldInputAccessoryView;
@end
