//
//  JLObuSDK.h
//  JLObuSDK
//
//  Created by juli on 16/6/20.
//  Copyright © 2016年 juli. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Foundation/Foundation.h>
@class CBPeripheral;

@protocol JLObuSDKDelegate;

/* 定义回调函数 */
typedef void(^obuCallBack)(Boolean status,NSObject * _Nullable data,NSString * _Nullable errorMsg);

@interface JLObuSDK : NSObject

@property (weak,nonatomic) id<JLObuSDKDelegate> delegate;

/* ObuSDK单例 */
+(JLObuSDK * _Nonnull) sharedObuSDK;
+(JLObuSDK * _Nonnull) sharedObuSDKWithDelegate:(id<JLObuSDKDelegate> _Nullable)delegate;
-(void) setDelegate:(id<JLObuSDKDelegate> _Nullable)delegate;
/* 检测蓝牙开启 */
-(Boolean) isEnabledBluetooth;

/**
 *  扫描设备
 *
 *  @param nFlagFilter 是否过滤 (不过滤:0  过滤:其他)
 *  @param callBack    回调 (data: NSArray< NSDictionary<NSString * , NSString *> *> *  例如:@[@{@"name":xxx,@"address":xxx,@"rssi":xxx}])
 */
-(void) scanBleDevice:(int)nFlagFilter callBack:(obuCallBack _Nonnull)callBack;

/**
 *  连接OBU设备
 *
 *  @param timeout  超时时间 (<=0时候  SDK会设置默认时限)
 *  @param callBack 回调 (data: nil)
 */
-(void) connectDevice:(int)timeout callBack:(obuCallBack _Nonnull)callBack;

/**
 *  连接OBU设备
 *
 *  @param peripheral 外设对象
 *  @param timeout    超时时间 (<=0时候  SDK会设置默认时限)
 *  @param callBack   回调 (data: nil)
 */
-(void) connectDevice:(CBPeripheral * _Nonnull)peripheral timeout:(int)timeout callBack:(obuCallBack _Nonnull)callBack;

/**
 *  连接OBU设备
 *
 *  @param name     设备名称
 *  @param address  设备标识(peripheral.identifier.UUIDString)
 *  @param callBack 回调 (data: nil)
 */
-(void) connectDevice:(NSString* _Nullable)name address:( NSString* _Nonnull)address callBack:(obuCallBack _Nonnull)callBack;

/**
 *  断开OBU设备
 *
 *  @param callBack 回调 (data: nil)
 */
-(void) disconnectDevice:(obuCallBack _Nonnull)callBack;

/**
 *  SDK连接设备的状态
 *
 *  @return 连接状态 (已连接:YES  未连接:NO)
 */
- (BOOL) checkConnectState;

/**
 *  检查OBU连接
 *
 *  @param callBack 回调
                    回调参数:  status:  已连接:YES  未连接:NO
                              data:    已连接: (NSDictionary <NSString * , NSString *> *) 
                        例:@{@"name":peripheral.name , @"address":(peripheral.identifier.UUIDString)}
                                       未连接: nil
 *
 *  @return 连接状态 CardOwnerRecord : 已连接:YES  未连接:NO
 */
-(Boolean)checkConnection:(obuCallBack _Nonnull)callBack;
//==============================业务接口==================================

/**
 *  基本信息获取
 *
 *  @param callBack 回调 (data: NSDictionary *   详文见<<蓝牙终端接口规范V1.5>>)
 */
-(void) getDevInformation:(obuCallBack _Nonnull)callBack;

/**
 *  系统对设备认证
 *
 *  @param data     四字节随机数
 *  @param callback 回调 (data:NSData * 随机数加密生成的密文)
 */
-(void) extAuthDevWithRand:(NSData * _Nonnull)data callBack:(obuCallBack _Nonnull)callBack;

/**
 *  设备对系统认证
 *
 *  @param src      原文
 *  @param mac      密文
 *  @param callback 回调 (data:NSData *  成功:0x00 失败:nil)
 */
-(void) intAuthDevWithSrc:(NSData * _Nonnull)src Mac:(NSData * _Nonnull)mac callBack:(obuCallBack _Nonnull)callBack;

/**
 *  秘钥替换
 *
 *  @param key      秘钥
 *  @param callBack 回调 (data:NSData *  成功:0x00 失败:nil)
 */
- (void)writeKey:(NSData * _Nonnull)key callBack:(obuCallBack _Nonnull)callBack;


/**
 *  读取卡信息
 *
 *  @param callBack 回调 (data:NSDictionary * 详文见<<蓝牙终端接口规范V1.5>>)
 */
-(void) getCardInformation:(obuCallBack _Nonnull)callBack;

/**
 *  读取持卡人信息
 *
 *  @param callBack 回到 (data:NSDictionary * 详文见<<蓝牙终端接口规范V1.5>>)
 */
-(void) readCardOwnerRecord:(obuCallBack _Nonnull)callBack;

/**
 *  圈存初始化
 *
 *  @param credit     充值金额
 *  @param cardId     卡号
 *  @param terminalNo 终端机编号
 *  @param pinCode    PIN码
 *  @param procType   交易类型 (ED:01  EP:02)
 *  @param keyIndex   秘钥索引
 *  @param callBack   回调 (data:NSDictionary * 详文见<<蓝牙终端接口规范V1.5>>)
 */
-(void) loadCreditGetMac1:(NSString * _Nonnull)credit cardId:(NSString * _Nonnull)cardId  terminalNo:(NSString * _Nonnull)terminalNo pinCode:(NSString * _Nonnull)pinCode procType:(NSString * _Nonnull)procType keyIndex:(NSString * _Nonnull)keyIndex callBack:(obuCallBack _Nonnull)callBack;

/**
 *  圈存写卡
 *
 *  @param dateMAC2 包含日期与Mac2的字符串  (格式：14位日期yyyymmddhhmmss + 8位mac2)
 *  @param callBack 回调 (data: NSDictionary * 详文见<<蓝牙终端接口规范V1.5>>)
 */
-(void) loadCreditWriteCard:(NSString * _Nonnull)dateMAC2 callBack:(obuCallBack _Nonnull)callBack;

/**
 *  读终端交易记录文件
 *
 *  @param pinCode   PIN码
 *  @param maxNumber 需读取的记录数量
 *  @param callBack  回调 (data:NSArray<NSDictionary *> * 详文见<<蓝牙终端接口规范V1.5>>)
 */
-(void) readCardTransactionRecord:(NSString * _Nonnull)pinCode maxNumber:(NSInteger)maxNumber callBack:(obuCallBack _Nonnull)callBack;

/**
 *  读联网收费复合消费过程文件
 *
 *  @param maxNumber 需读取的记录数量
 *  @param callBack  回调 (data:NSArray<NSDictionary *> * 详文见<<蓝牙终端接口规范V1.5>>)
 */
-(void) readCardConsumeRecord:(NSInteger)maxNumber callBack:(obuCallBack _Nonnull)callBack;

/**
 *  卡片复位
 *
 *  @param callBack 回调 (data:NSString * 响应内容)
 *                  回调中的参数: status :  状态码, 成功:YES  失败:NO
 *                              data   :  成功: NSData类型,表示卡片相关信息,此信息不唯一
                                          失败:  1: nil,                原因: 未连接设备
                                                2: NSdata类型, 值:0a01  原因:卡片不存在,或卡片位置不对
                                                3: NSData类型, 值:Oa02  原因:设备对系统做认证,不能进行业务
 
 *                             errorMsg:  成功:nil
                                          失败: 1:NSString类型, 值:"未连接OBU设备"          原因:未连接设备
                                               2:NSString类型, 值:"未读取到IC卡活IC卡不存在" 原因:卡片不存在,或卡片位置不对
                                               3:NSString类型, 值:"设备未认证系统"          原因:设备未认证系统
 */
-(void) resetCardCommandWithcallBack:(obuCallBack _Nonnull)callBack;

/**
 *  卡片通道
 *
 *  @param command  卡片指令(ICC通道 向OBU发送一条指令,且只能是一条数据,数据的类型是NSString类型,例:@"00a40000021001")
 *  @param callBack 回调 (data:NSString * 响应内容)
 */

-(void)cardCommand:(NSString * _Nonnull)command callBack:(obuCallBack _Nonnull)callBack;

/**
 *  透明通道 (向设备发送多条指令,通道可选择ICC或ESAM两个)
 *
 *  @param cmd        通道选择 (ESAM通道: 02  ICC通道:其他)
 *  @param encode     是否加密 (加密:YES 不加密:NO)
 *  @param reqData    指令组合 (格式: 指令总条数(1byte)+指令1长度(1byte)+指令1数据(n byte)+指令2长度(1byte)+指令2数据(n byte)+…..)
 *  @param reqDataLen 指令组合总长度
 *  @param callBack   回调 (data:NSData *  <与指令组合格式相同 > 详文见<<蓝牙终端接口规范V1.5>>)
 */
- (void) transCommand:(NSString * _Nonnull)cmd encode:(Boolean)encode reqData:(NSData * _Nonnull)reqData reqDataLen:(NSUInteger)reqDataLen callBack:(obuCallBack _Nonnull)callBack;

//==============================业务接口结束==================================

/**
 *  设备握手
 *
 *  @param callBack 回调 (data:nil)
 */
- (void)shakeHands:(obuCallBack _Nonnull)callBack;

//============================以下接口未实现  请不要调用===================================

/*
// 描扫设备
-(void) scanBle:(obuCallBack _Nonnull)callBack;

// 取消连接OBU设备
-(void) cancelConnect;

//设备绑定
- (void)bindOBU:(NSString * )uuid callBack:(obuCallBack)callBack;

// 设备解绑
- (void)unbindOBU:(obuCallBack)callBack;

// 读设备电量
-(void) checkBattery:(obuCallBack)callBack;
*/

@end


@protocol JLObuSDKDelegate <NSObject>

//OBU断开连接后回调
-(void)didDeviceDisConnected;

@end

