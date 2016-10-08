//
//  PubFunctions.h
//  mPOSDemo
//
//  Created by zhongfu on 15/11/19.
//  Copyright (c) 2015年 shandongzhongfu. All rights reserved.
//

#import <Foundation/Foundation.h>

/***不可识别的包类型*/
#define ZFMPOS_PACKAGE_COMMUNICATION_ERR_CODE_PACKAGE_TYPE_NOT_RECOGNIZE 0x01
/***校验和错误*/
#define ZFMPOS_PACKAGE_COMMUNICATION_ERR_CODE_CHECKSUM_ERROR 0x02
/***包序号重复*/
#define ZFMPOS_PACKAGE_COMMUNICATION_ERR_CODE_REPEAT_PACKET_NUMBER 0x03
/***不识别的指令*/
#define ZFMPOS_PACKAGE_COMMUNICATION_ERR_CODE_CMD_NOT_RECOGNIZE 0x04
/***主密钥不存在*/
#define ZFMPOS_CMD_OPERAT_ERR_CODE_MASTERKEY_NOT_EXIST 0x01
/***工作密钥不存在*/
#define ZFMPOS_CMD_OPERAT_ERR_CODE_WORK_KEY_NOT_EXIST 0x02
/***CHECKVALUE错误*/
#define ZFMPOS_CMD_OPERAT_ERR_CODE_CHECKVALUE_ERROR 0x03
/***参数错误*/
#define ZFMPOS_CMD_OPERAT_ERR_CODE_PARAMETER_ERROR 0x04
/***可变数据域长度错误*/
#define ZFMPOS_CMD_OPERAT_ERR_CODE_VARIABLEDATA_LENGTH_ERROR 0x05
/***帧格式错误*/
#define ZFMPOS_CMD_OPERAT_ERR_CODE_FRAME_FORMAT_ERROR 0x06
/***执行异常*/
#define ZFMPOS_CMD_OPERAT_ERR_CODE_EXECUTION_EXCEPTION 0x07
/***数据库操作失败*/
#define ZFMPOS_CMD_OPERAT_ERR_CODE_DATABASE_OPERATION_FAIL 0x08
/***无打印机*/
#define ZFMPOS_CMD_OPERAT_ERR_CODE_NO_PRINTER 0x09
/***未知指令*/
#define ZFMPOS_CMD_OPERAT_ERR_CODE_UNKNOWN_COMMAND 0x0A
/***LRC校验失败*/
#define ZFMPOS_CMD_OPERAT_ERR_CODE_LRC_CHECK_FAIL 0x0B
/***交易超时*/
#define ZFMPOS_CMD_OPERAT_ERR_CODE_TRANSACTION_TIMEOUT 0x0C
/***其它*/
#define ZFMPOS_CMD_OPERAT_ERR_CODE_OTHER 0x0D
/***终端锁机*/
#define ZFMPOS_CMD_OPERAT_ERR_CODE_TERMINAL_LOCKING 0x0E
/***暂不支持该参数*/
#define ZFMPOS_CMD_OPERAT_ERR_CODE_NOT_SUPPORT 0x0F


/*** 操作成功 */
#define ZFMPOS_OPERAT_SUC  0x00
/*** 连接银行后台出错 */
#define ZFMPOS_CMD_OPERAT_ERR_CODE_CONNECT_BANK_ERR  0x8000
/*** 硬件错误 */
#define ZFMPOS_CMD_OPERAT_ERR_MPOS_ERR  0x8001
/*** 处理超时错误 */
#define ZFMPOS_CMD_OPERAT_ERR_TIMEOUT  0x8002
/*** 蓝牙断开 */
#define ZFMPOS_CMD_OPERAT_ERR_BLUETOOTH_CONNECT_FAIL  0x8003
/*** 蓝牙断开 */
#define ZFMPOS_CMD_OPERAT_ERR_BLUETOOTH_DISCONNECT  0x8004
/*** 数据异常 */
#define ZFMPOS_CMD_OPERAT_ERR_DATA_ABNORMAL  0x8005
/*** 未找到相关交易明细 */
#define ZFMPOS_CMD_OPERAT_ERR_DETAIL_NOT_FIND  0x8006
/*** 需重新签到 */
#define ZFMPOS_CMD_NEED_SIGIN_AGAIN  0x8007
/*** 操作失败 */
#define ZFMPOS_CMD_OPERAT_FILE  0x8008
/*** 用户取消 */
#define ZFMPOS_CMD_OPERAT_CANCLE  0x8009
/*** 未签到 */
#define ZFMPOS_OPERAT_ERR_NOT_SIGNIN  0x800A
/*** 金额错误 */
#define ZFMPOS_OPERAT_ERR_AMOUNT_ERR  0x800B
/*** 用户操作超时 */
#define ZFMPOS_OPERAT_ERR_USER_TIMEOUT  0x800C
/*** 签退未结算 */
#define ZFMPOS_OPERAT_ERR_SIGNOUT_NOT_SETLEMENT  0x800D
/*** 签到过期 */
#define ZFMPOS_CMD_SIGIN_TIMEOUT  0x800E
/*** 存储空间已满 */
#define  ZFMPOS_OPERAT_ERR_ROM_FULL 0x800F

@interface PubFunctions : NSObject


+(NSString *) ByteToHexNSString:(Byte *)arrBcdCode BcdCodeLength:(NSInteger)BcdCodeLength;
+(NSString *) NSDataToHexNSString:(NSData *)arrBcdCode;
+(NSInteger) BCDToInt:(NSData *)bcdData ByteNum:(NSInteger)ByteNum;
+(NSString *)HexStringToString:(NSString *)hexString;
+(NSString *)StringTohexString:(NSString *)string;
+(NSData *)StringBcdToNSData:(NSString *)bcdString;
+(NSString *)IntToBinary:(int)intValue;
+(NSInteger)int2bcd:(NSInteger)num;
+(NSData *)String10HexToBcd:(NSString*) str10Hex;
+(NSData *)HexStringToNSData:(NSString *)strHex;
+(NSInteger)intToBytes:(NSInteger) value arrByte:(Byte *)arrByte byteLength:(NSInteger)byteLength;
+(NSString *)nsdataToHexString:(NSData*)inputData;
+(NSInteger) DecodTLVData:(Byte*) arrTLVData TLVDataLength:(NSInteger)TLVDataLength TLVMap: (NSMutableDictionary*)mapOfTLVData;
+(NSInteger)nsdataToInt:(NSData *)inputData;

@end
