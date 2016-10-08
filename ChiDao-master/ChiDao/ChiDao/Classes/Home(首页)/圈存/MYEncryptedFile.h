//
//  MYEncryptedFile.h
//  ManYiXing
//
//  Created by min on 16/8/3.
//  Copyright © 2016年 李友富. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYEncryptedFile : NSObject

+ (NSString *) goEncryptDES:(NSDictionary *)dic;

+ (void) goFreeMemory;
@end
