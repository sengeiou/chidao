 //
//  TransferenceSDK.h
//  TransferenceSDK
//
//  Created by 赵洋 on 16/8/4.
//  Copyright © 2016年 zy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransferenceSDK : NSObject

typedef void(^ProcessResult)(NSMutableDictionary *dic);

typedef void(^QZResult)(NSString *status,NSString *desc);

typedef void(^CarResult)(NSString *status);


+ (TransferenceSDK *)sharedClient;

//卡复位
//********** 0代表连接成功***************
//********** 1代表连接失败***************
-(void)cardReset:(CarResult)callBack;


//连接设备
//@param   peripheralName	 设备名称
//         address           设备标示
//********** 0代表连接成功***************
//********** 1代表连接失败***************
//********** 2代表不支持该设备***************
-(void)connectDeviceWithName:(NSString *)peripheralName withAddress:(NSString *)address complete:(CarResult)callBack;


//断开设备连接
//********** 0代表断开设备连接成功***************
//********** 1代表断开设备连接失败***************
//********** 2代表不支持该设备   ***************
-(void)disconnectDevice:(CarResult)callBack;

//读卡 (卡号@"cardId"  余额@"balance" 车牌号@"vehicleNumber")
//**********status 1代表读卡成功***************
//**********status 0代表读卡失败***************
//**********status 2代表该卡是A卡,不支持圈存***************
-(void)getCarInformation:(ProcessResult)callBack;

//对外圈存
//============结果码==============
//********** 0代表圈存成功***************
//********** 1代表圈存失败***************
//********** 2代表圈存状态未知***************

//============过程码==============
//********** 5代表圈存状态未知***************
-(void)qzCar:(NSString *)money withCarID:(NSString *)cardID complete:(QZResult)callBack;


//=======================================================================
//============================暂时不用=====================================
//========================================================================
//设备读卡监听
//********** 0代表无卡***************
//********** 1代表有卡***************

-(void)startListenCar:(CarResult)callBack;
//取消监听
//********** 2代表计时器销毁成功***************
-(void)cancelListenCar:(CarResult)callBack;

@end
