//
//  NSString+YFContainsString.m
//  ManYiXing
//
//  Created by 李友富 on 16/5/5.
//  Copyright © 2016年 李友富. All rights reserved.
//

#import "NSString+YFContainsString.h"

@implementation NSString (YFContainsString)

- (BOOL)yfContainsString:(NSString *)string {
    NSRange range = [self rangeOfString:string];
    return range.length != 0;
}

@end
