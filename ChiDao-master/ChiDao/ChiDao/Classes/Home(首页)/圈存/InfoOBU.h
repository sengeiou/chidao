//
//  InfoOBU.h
//  TransferenceSDK
//
//  Created by 赵洋 on 16/8/4.
//  Copyright © 2016年 zy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InfoOBU : NSObject
@property(nonatomic, strong)NSString* phoneNum; //手机号
@property(nonatomic, strong)NSString* loadseq; //本地圈存流水
+ (InfoOBU*) shareInstance;
-(NSString*) description;
@end
