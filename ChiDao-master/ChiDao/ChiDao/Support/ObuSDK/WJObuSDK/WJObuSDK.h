#import <Foundation/Foundation.h>
//0.回调函数
typedef void(^listenCallBack)(void);
//1.回调函数(status成功、失败，data数据，errorMsg报错信息)
typedef void(^WJobuCallBack)(BOOL status,id data, NSString *errorMsg);

@interface WJObuSDK : NSObject
//2.创建ObuSDK对象的实例（单例）
+(instancetype)sharedObuSDK;

//3.查询蓝牙打开状态 打开返回YES 关闭返回NO
@property (nonatomic,assign,getter=isEnableBluetooth) BOOL   bluetoothState;

//4.连接OBU
-(void)connectDevice:(int)timeout localname:(NSString*)localName  callBack:(WJobuCallBack)callBack;

//5.断开OBU连接
-(void)disconnectDevice:(WJobuCallBack)callBack;

//6.IC卡信息查询
-(void)getCardInformation:(WJobuCallBack)callBack;

//7.obu基本信息查询
-(void)getObuInformation:(WJobuCallBack)callBack;

//8.数据透传 (山东 cmd参数 05：IC卡 06:ESAM 07:SE芯片 )
-(void)transCommand: (int)encode cmd:(int)cmd reqdata:(NSData*)reqData reqdatalen:(int)reqDataLen transcommflag:(int)transCommFlag callBack:(WJobuCallBack)callBack;

//9.公钥加密
-(void)encryptByPublicKey:(NSData*)srcData publicmodulus:(NSString*)publicExponent publickey:(NSString*)publicKey callBack:(WJobuCallBack)callBack;

//10.公钥验签
-(BOOL)verifyString:(NSData *)string withSign:(NSData *)signString publicmodulus:(NSString*)publicModulus publickey:(NSString*)publicKey;

//11.设备校验
-(void)checkReader:(NSString *)data datalen:(int)len callBack:(WJobuCallBack)callBack;

//12.取公钥
-(void)getPublicKeylen:(int)keyLength callBack:(WJobuCallBack)callBack;

//13.生成密钥对
-(void)generateSecKey:(WJobuCallBack)callBack;

//14.OBU加密数据
-(void)encryptByObuPrvateKeySrcData:(NSData*)srcData callBack:(WJobuCallBack)callBack;
//15.OBU签名数据
-(void)signdata:(NSData *)data callBack:(WJobuCallBack)callBack;
//16.闪灯
-(void)sendLightNums:(int)num index:(int)index callback:(WJobuCallBack)callBack;
//17.弹性柱状态查询
-(void)qryReaderStates:(WJobuCallBack)callBack;
//18.弹性柱状态监听
-(void)listenForReaderState:(WJobuCallBack)callBack;
//19.obu私钥解密
-(void)decryptByObuEncryptData:(NSData *)data callback:(WJobuCallBack)callBack;
//20.闪灯监听
-(void)listenForLightNum:(listenCallBack)callBack;
//21.唤醒obu
-(BOOL)ObuWakeUp:(WJobuCallBack)callBack;
//22.OBU休眠
-(BOOL)ObuSleep:(WJobuCallBack)callBack;
//23.导入证书
-(void)importCertificateSrcData:(NSData *)srcData callback:(WJobuCallBack)callBack;
//24.导出证书
-(void)exportCertificateSrcData:(WJobuCallBack)callBack;
@end
