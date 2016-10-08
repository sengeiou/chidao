//
//  ETCCardModel.h
//  ChiDao
//
//  Created by 赵洋 on 16/8/19.
//  Copyright © 2016年 赵洋. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *
 *  ETC卡信息模型
 */
@interface ETCCardModel : NSObject

// 0是信联卡   1是鲁通卡
@property (nonatomic, copy) NSString *cardType;
@property (nonatomic, copy) NSString *cardNum;
@property (nonatomic, copy) NSString *plateNum;
@property (nonatomic, copy) NSString *name;
@end
