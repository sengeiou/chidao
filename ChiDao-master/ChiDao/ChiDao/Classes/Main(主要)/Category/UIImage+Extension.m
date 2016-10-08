//
//  UIImage+Extension.m
//  shufa
//
//  Created by zy on 15/3/24.
//  Copyright (c) 2015年 zy. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)
+ (UIImage *)imageWithName:(NSString *)name{
    UIImage *image = nil;
    if (iOS7) {
        // 处理iOS7的情况
        NSString *newName = [name stringByAppendingString:@"_os7"];
        image = [UIImage imageNamed:newName];
    }
    
    if (image == nil) {
        image = [UIImage imageNamed:name];
    }
    return image;
}
@end
