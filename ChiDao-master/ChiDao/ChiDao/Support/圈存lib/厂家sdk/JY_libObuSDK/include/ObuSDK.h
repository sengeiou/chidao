//
//  ObuSDK.h
//  ObuSDK
//
//  Created by Timo Huang on 15/5/8.
//  Copyright (c) 2015年 Timo Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JYBlueObu.h"

/* 消息回调 */
@protocol JYObuSDKDelegate <NSObject>

/* 查找到蓝牙设备 */
- (void)didFindBlueObu:(JYBlueObu *)obu desc:(NSString *)szDesz;

/* 连接成功 */
- (void)didConnectObu:(JYBlueObu *)obu desc:(NSString *)szDesz;

/* 断开连接 */
- (void)didDisConnectObu:(JYBlueObu *)obu desc:(NSString *)szDesz;

/* 连接失败 */
- (void)ConnectFailed:(JYBlueObu *)obu desc:(NSString *)szDesz;

/* 接收数据失败 */
- (void)ReadDataFailed:(JYBlueObu *)obu desc:(NSString *)szDesz;

/* 发送数据失败 */
- (void)WriteDataFailed:(JYBlueObu *)obu desc:(NSString *)szDesz;

/* 扫描连接超时 */
-(void)didFindBlueObuTimeout;

@end

@protocol GVObuActionDelegate <NSObject>

//obu未激活前，防拆按钮（弹性柱）不管是弹起还是按下，返回的防拆位状态始终为1（弹起），激活成功后，返回防拆位状态为0（压下），此时拆卸obu，防拆位返回1（弹起）
//所以只有当防拆位状态由0-->1时，才会回调，表示已激活的obu被拆卸，弹性柱弹起。
- (void)didObuPlungerUp;

//闪灯结束后回调
- (void)didObuFlashLed;

//OBU连接成功后回调
- (void)didDeviceConnected;

//OBU断开连接后回调
- (void)didDeviceDisConnected;

@end

/* 定义回调函数 */
typedef void(^obuCallBack)(Boolean status, NSObject * data, NSString *errorMsg);

@interface ObuSDK : NSObject<JYObuSDKDelegate>

/* ObuSDK单例 */
+(ObuSDK *) sharedObuSDK;

/* 检测蓝牙开启 */
-(Boolean) isEnabledBluetooth;

/* 连接OBU设备 */
-(void) connectDevice:(int)timeout callBack:(obuCallBack)callBack;

/*根据设备名称进行连接*/
-(void) connectDevice:(int)timeout withName:(NSString*)name callBack:(obuCallBack)callBack;

/* 取消连接OBU设备 */
-(void) cancelConnect;

/* 断开OBU设备 */
-(void) disconnectDevice:(obuCallBack)callBack;

/* 读取卡信息 */
-(void) getCardInformation:(obuCallBack)callBack;

/* 读设备电量 */
-(void) checkBattery:(obuCallBack)callBack;

/* 读设备信息 */
-(void) getObuInformation:(obuCallBack)callBack;

/* 圈存初始化 */
-(void) loadCreditGetMac1:(NSString *)credit cardId:(NSString *)cardId  terminalNo:(NSString *)terminalNo pinCode:(NSString *)pinCode procType:(NSString *)procType keyIndex:(NSString *)keyIndex callBack:(obuCallBack)callBack;

/* 圈存写卡 */
-(void) loadCreditWriteCard:(NSString *)dateMAC2 callBack:(obuCallBack)callBack;

/* 读终端交易记录文件 */
-(void) readCardTransactionRecord:(NSString *)pinCode maxNumber:(NSInteger)maxNumber callBack:(obuCallBack)callBack;

/* 读联网收费复合消费过程文件 */
-(void) readCardConsumeRecord:(NSInteger)maxNumber callBack:(obuCallBack)callBack;

/* 读取持卡人信息 */
-(void) readCardOwnerRecord:(obuCallBack)callBack;

/* 数据透传 */
/* 透传接口使用说明：
 根据协议，reqData第一个字节已包含cmdCode，所以在该接口中，cmdCode不需要传入指令类型，接口保留cmdCode是为了兼容其他版本的接口，
 用户在使用时，根据协议组装好DATA域（Type+Content），传入reqData即可。
 */
- (void)transCommand:(unsigned char)cmdCode reqData:(NSData *)reqData callBack:(obuCallBack)callBack;

/* 设备绑定 */
- (void)bindOBU:(NSString *)uuid callBack:(obuCallBack)callBack;

/* 设备解绑 */
- (void)unbindOBU:(obuCallBack)callBack;

/* 设置监测OBU状态代理 */
- (void)setObuActionDelegate:(id)obj;

/* 启动监听OBU防拆状态（弹性柱状态） */
- (int)startObuTearListen;

/* 启动监听OBU闪灯状态 */
- (int)startObuFlashedListen;

/* 停止OBU防拆状态（弹性柱状态）、闪灯结束状态监听 */
- (void)stopAllObuListen;

/* 停止OBU防拆状态（弹性柱状态）监听 */
- (void)stopObuTearListen;

/* 停止OBU闪灯结束状态监听 */
- (void)stopObuFlashedListen;

/* 获取蓝牙OBU基本信息 */
- (void)getBleReaderInfo:(obuCallBack)callBack;

/* 设置OBU闪灯 */
//atLightNo: 0为前灯 1为背灯
-(void) setFlashingLight: (int)numbers interval:(int)times atLightNo: (int)index callback:(obuCallBack)callBack;

/* 获取OBU闪灯状态 */
-(void) getFlashingLightStatus:(int) lightNo callback:(obuCallBack)callBack;

/* 获取OBU防拆位状态 */
-(void) getObuTearFlagStatus:(obuCallBack)callBack;

/*设备校验*/
-(void)checkReader:(NSString*)data callback:(obuCallBack)callBack;

/* 产生公私钥*/
-(void)genRSAKey:(obuCallBack)callBack;

/* 取公钥*/
-(void)getPubkey:(obuCallBack)callBack;
    
/*公钥加密*/
-(void)pubkeyEncypt:(NSString *)data callback:(obuCallBack)callBack;

/*私钥解密*/
-(void)prikeyDecypt:(NSString *)data callback:(obuCallBack)callBack;

/*私钥签名*/
-(void)prikeySign:(NSString *)data callback:(obuCallBack)callBack;

/*公钥验签*/
-(void)pubkeyVerify:(NSString *)data sign:(NSString *)signData callback:(obuCallBack)callBack;

/*写入证书*/
-(void)writeCert:(NSString *)cert withFileId:(NSString*)fileId callback:(obuCallBack)callBack;

/*apdu指令通道*/
//dataType : 0x0: 明文  0x1: 密文
//channelID : 0x0: ICC通道  0x1:充值模块通道  0x2: ESAM通道
-(void)obuChannel:(NSString*)apdu dataType:(unsigned char)dataType atChannel:(unsigned char)channelID callback:(obuCallBack)callBack;

@end
