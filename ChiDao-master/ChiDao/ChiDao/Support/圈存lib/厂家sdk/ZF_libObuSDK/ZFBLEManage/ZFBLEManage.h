//
//  ZFBLEManage.h
//  ZFBLEManage
//
//  Created by zhongfu on 16/1/26.
//  Copyright (c) 2016年 shandongzhongfu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreBluetooth/CBService.h>


//消息定义
//*****************************************************
#define  ZFBLE_NOTIFICATION_NAME                             @"ZFBLENotification"                              //消息名称
#define  ZFBLE_NOTIFICATION_MESSAGE                          @"ZFBLENotificationMessage"                       //消息执行命令
//蓝牙设备
#define  ZFBLE_NOTIFICATION_MESSAGE_ENUM_DEVICES_FINISH      @"ZFBLENotificationMessageEnumDevicesFinish"      //消息执行命令，查找蓝牙设备完成
#define  ZFBLE_NOTIFICATION_MESSAGE_CONNECT_DEVICES_SUC      @"ZFBLENotificationMessageConnectDevicesSuc"      //消息执行命令，连接设备成功
#define  ZFBLE_NOTIFICATION_MESSAGE_CONNECT_DEVICES_FAIL     @"ZFBLENotificationMessageConnectDevicesFail"     //消息执行命令，连接设备失败
#define  ZFBLE_NOTIFICATION_MESSAGE_DISCONNECT_DEVICES_SUC   @"ZFBLENotificationMessageDisconnectDevicesSuc"   //消息执行命令，断开设备成功
#define  ZFBLE_NOTIFICATION_MESSAGE_DISCONNECT_DEVICES_FAIL  @"ZFBLENotificationMessageDisconnectDevicesFail"  //消息执行命令，断开设备失败

//*****************************************************
#define ZFBLE_SUCCESS                   0     //操作成功。
#define ZFBLE_FAILED                    1001  //操作失败。
#define ZFBLE_CONNECT_DEVICE_FAIL       1002  //与设备建立连接失败
#define ZFBLE_DISCONNECT_DEVICE_FAIL    1003  //与设备断开连接失败
#define ZFBLE_SERVICE_NOT_MPOS          1004  //连接的设备非mPOS设备（查找服务）
#define ZFBLE_SERVICE_NOT_FIND          1005  //查找服务失败
#define ZFBLE_CHARACTERE_NOT_MPOS       1006  //接的设备非mPOS设备（查找角色）
#define ZFBLE_CHARACTERE_NOT_FIND       1007  //查找角色失败
#define ZFBLE_SET_NOTIFICATION_FAIL     1008  //设置notification失败
#define ZFBLE_INVALID_PARAMETER         1009  //参数错误
#define ZFBLE_UNKNOW                    2000  //未知错误
//*************************************************************

/* 定义回调函数 */
typedef void(^ZFCallBack)(Boolean status, NSData * data, NSString *errorMsg);


@interface ZFBLEManage : NSObject<CBCentralManagerDelegate, CBPeripheralDelegate> {
}


@property (strong, nonatomic) NSMutableArray   *pMutableArrayPeripherals;
@property (strong, nonatomic) CBCentralManager *pCBCentralManager;
@property (strong, nonatomic) CBPeripheral     *pCBPeripheral;
@property (strong, nonatomic) CBCharacteristic *pCBCharacteristic;
@property (nonatomic, copy) void (^BLERevDataBlock)(Byte *bRevData,long iRevDataLength);
@property (nonatomic, copy) void (^BLEReturnValueBlock)(NSInteger iRetrunValue);

@property NSInteger ZFBLE_BLEStatus;
@property NSInteger ZFBLE_ErrCode;

/*!
 *  @method ZFBLEManageSharedZFBLEManage:
 *
 *  @param nil	    
 *
 *  @discussion			单例模式
 *
 *
 *	@return				成功返回:static ZFBLEManage，
 *                      失败返回:nil.
 *
 */
+(ZFBLEManage *)ZFBLEManage_SharedZFBLEManage;


/*!
 *  @method MPOS_GetCentralManagerState:
 *
 *  @param
 *
 *  @discussion         打印输出当前CBCentralManager状态
 *
 *	@return				当前CBCentralManager状态的描述.
 *
 */
- (NSString *) ZFBLEManage_GetCentralManagerState;

/*!
 *  @method mPOS_EnumDevices:
 *
 *  @param timeout	    超时时间（秒）.
 *
 *  @discussion			在超时时间内枚举周围设备并将枚举到到设备存放在pMutableArrayPeripherals中，
 *                      枚举完成后访问pMutableArrayPeripherals获取设备.
 *
 *	@return				成功返回ZFBLE_SUCCESS，
 *                      失败返回ZFBLE_FAILED，失败原因:设备未准备就绪或蓝牙未打开.
 *
 */
-(NSInteger) ZFBLEManage_EnumDevices:(NSInteger) timeout;


/*!
 *  @method ZFBLEManage_Connect:
 *
 *  @param 	DeviceUUID  要连接的外围蓝牙设备名称.
 *          callBack    回调函数
 *
 *  @discussion			连接设备.
 *
 *	@return				无
 *
 */
-(void) ZFBLEManage_Connect:(NSString *)DeviceUUID callBack:(ZFCallBack)callBack;

/*!
 *  @method ZFBLEManage_Disconnect:
 *
 *  @param peripheral   要断开的外围蓝牙设备.
 *         callBack    回调函数
 *
 *  @discussion			断开设备.
 *
 *	@return				无.
 *
 */
-(void) ZFBLEManage_Disconnect:(ZFCallBack)callBack;


/*!
 *  @method ZFBLEManage_GetLastError:
 *
 *  @param              无.
 *
 *  @discussion			获取错误信息.
 *
 *	@return				错误信息.
 *
 */
-(NSString *)ZFBLEManage_GetLastError;

/*!
 *  @method ZFBLEManage_DataTrans:
 *
 *  @param  Cmd 发送数据.
 *          CmdLength 发送数据长度.
 *          Response 接收数据.
 *          ResponseLen 接收数据长度.
 *
 *  @discussion			数据收发.
 *
 *	@return				无。
 *
 */
-(void) ZFBLEManage_DataTrans:(Byte *)Cmd
                         CmdLength:(NSInteger)CmdLen
                          callBack:(ZFCallBack)callBack;

/*!
 *  @method ZF_CardReaderReboot:
 *
 *  @param  callBack    回调函数
 *
 *
 *  @discussion			卡片复位.
 *
 *	@return				无.
 *
 */
-(void) ZF_CardReaderReboot:(ZFCallBack)callBack;

/*!
 *  @method ZF_CheckCardStauts:
 *
 *  @param callBack    回调函数.
 *
 *
 *  @discussion			检测是否有卡.
 *
 *	@return				无.
 *
 */
-(void) ZF_CheckCardStauts:(ZFCallBack)callBack;

/*!
 *  @method ZF_GetDevInfo:
 *
 *  @param callBack    回调函数.
 *
 *
 *  @discussion			获取设备信息，格式为：设备ID长度＋设备ID＋蓝牙名称长度＋蓝牙名称＋蓝牙地址长度＋蓝牙地址.
 *
 *	@return				无.
 *
 */
-(void) ZF_GetDevInfo:(ZFCallBack)callBack;

/*!
 *  @method ZF_IntAuthDev:
 *
 *  @param src         数据.
 *         srcLength   数据长度.
 *         mac         MAC值
 *         callBack    回调函数
 *
 *  @discussion			内部认证.
 *
 *	@return				无.
 *
 */
-(void) ZF_IntAuthDev:(Byte *)src srcLength:(NSInteger)srcLength mac:(Byte *)mac callBack:(ZFCallBack)callBack;

/*!
 *  @method ZF_ReadOrWriteCard:
 *
 *  @param inputData   输入数据.
 *         inputDataLength 输入数据长度
 *         callBack    回调函数
 *
 *  @discussion			数据卡片读写，设备未认证时，callback中errorMsg的内容为：设备未认证.
 *
 *	@return				无.
 *
 */
-(void) ZF_ReadOrWriteCard:(Byte *)inputData
                inputDataLength:(NSInteger) inputDataLength
                       callBack:(ZFCallBack)callBack;


@end
