//
//  IPosServer.m
//  IPos
//
//  Created by hisuntech on 11-8-1.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import "HisuntechOrderEntity.h"
#import "HisunTechTools.h"
static HisuntechBuildJsonString *instance = nil;
@implementation HisuntechBuildJsonString
@synthesize publicKey;
@synthesize sequence;
@synthesize dict;
@synthesize orderString;
@synthesize serialNumber;

+(HisuntechBuildJsonString *)Instance{
	@synchronized(self){
		if (instance == nil) {
			instance = [[self alloc] init];
            NSDictionary *dict = [[NSBundle mainBundle] infoDictionary];
            NSString *strVer = [NSString stringWithFormat:@"%@",[dict objectForKey:@"CFBundleShortVersionString"]];
            [HisuntechOrderEntity Instance].clientVersion = strVer;
		}
	}
	return instance;
}

/**
 *  生成交易流水号
 *
 *
 */
+(NSString *)getSerlNo{
    
    NSString* time = [[[HisunTechTools alloc]init] simulateAndRenderScene];//时间戳
//    NSString* macAddress = [[[Tools alloc]init] macaddress];//MAC地址
    NSString* uuid = [[[HisunTechTools alloc]init] uuid];//设备唯一编号
    NSString *serlNo = [NSString stringWithFormat:@"%@%@",time,uuid];//交易流水号
    return serlNo;
}

/**
 *  key value封装成字典
 */
+(NSDictionary *)buildMessage:(NSArray *)Key value:(NSArray *)Value
{
	if (Key == nil||([Key count] == 0)) {
		return nil;
	}
	NSMutableDictionary *tmp = [[NSMutableDictionary alloc] init];
    
	if(Key != nil){
		for (int i=0;i<[Key count];i++ ) {
			[tmp setValue:[Value objectAtIndex:i] forKey:[Key objectAtIndex:i]];
			
		}
	}
    
	return tmp;
}
/**
 * OAPPMCA1/APP4080620-获取公钥-codeType 1 -APP_CODE_PublicKey
 */
+(NSDictionary *)getPublicKeyJsonString{
    
    NSArray *key = [[NSArray alloc]initWithObjects:@"TXN_CD",@"VERSION",@"PLAT"
                    ,@"PLUGINVER",@"CONTTYPE ",@"MCID",@"SERLNO",nil];
	NSArray *value = [[NSArray alloc]initWithObjects:APP_CODE_PublicKey,[HisuntechOrderEntity Instance].clientVersion
                      ,@"4",@"1.0",@"text/html",
                      @"",[self getSerlNo],nil];
    NSDictionary* jsonDict = [self buildMessage:key value:value];
    return jsonDict;
}

/**
 * OAPPMCA1/APP4080030-绑定银行卡发送验证码-codeType 2 -APP_CODE_SmsCode
 */
+(NSDictionary *)getSendPhoneCodeJsonString:(NSString*)phoneNum//手机号
                                   userType:(NSString*)userType{
    NSArray *key = [[NSArray alloc]initWithObjects:@"TXN_CD",@"VERSION",@"PLAT"
                    ,@"PLUGINVER",@"CONTTYPE ",@"MCID",@"SERLNO",@"MBL_NO",@"USETYP",nil];
	NSArray *value = [[NSArray alloc]initWithObjects:APP_CODE_SmsCode
                      ,[HisuntechOrderEntity Instance].clientVersion
                      ,@"4",@"1.0",@"text/html",
                      @"",[self getSerlNo],phoneNum,userType,nil];
    NSDictionary* jsonDict = [self buildMessage:key value:value];
    return jsonDict;
}
/**
 * OSDKMCA1/SDK4090250-绑定银行卡校验验证码-codeType 3 -APP_CODE_CheckSmsCode
 */
+(NSDictionary *)getSendPhoneCodeJsonString:(NSString*)phoneNum
                                    smsCode:(NSString*)smsCode{
    
    NSArray *key = [[NSArray alloc]initWithObjects:@"TXN_CD",@"VERSION",@"PLAT"
                    ,@"PLUGINVER",@"CONTTYPE ",@"MCID",@"SERLNO",@"BNKPHONE",@"SMSCD",nil];
	NSArray *value = [[NSArray alloc]initWithObjects:APP_CODE_CheckSmsCode
                      ,[HisuntechOrderEntity Instance].clientVersion
                      ,@"4",@"1.0",@"text/html",
                      @"",[self getSerlNo],phoneNum,smsCode,nil];
    NSDictionary* jsonDict = [self buildMessage:key value:value];
    return jsonDict;
}
/**
 * OAPPMCA1/APP4080720-获取随机因子-codeType 4 -APP_CODE_RandomKey
 */
+(NSDictionary *)getRandomKeyJsonString{
    
    NSArray *key = [[NSArray alloc]initWithObjects:@"TXN_CD",@"VERSION",@"PLAT"
                    ,@"PLUGINVER",@"CONTTYPE ",@"MCID",@"SERLNO",nil];
	NSArray *value = [[NSArray alloc]initWithObjects:APP_CODE_RandomKey
                      ,[HisuntechOrderEntity Instance].clientVersion
                      ,@"4",@"1.0",@"text/html",
                      @"",[self getSerlNo],nil];
    NSDictionary* jsonDict = [self buildMessage:key value:value];
    return jsonDict;
}
/**
 * OSDKMCA1/SDK4090220-查询代金券-codeType 5 -APP_CODE_QueryVoucher
 */
+(NSDictionary *)getVoucherMsgJsonString:(NSString *)userNo
                                   merNo:(NSString *)merNo
                                orderAmt:(NSString *)orderAmt
                                mService:(NSString *)mService{
    NSArray *key = [[NSArray alloc]initWithObjects:@"TXN_CD",@"VERSION",@"PLAT"
                    ,@"PLUGINVER",@"CONTTYPE ",@"MCID",@"SERLNO",@"USRNO",@"MER_NO",@"ORD_AMT",@"SERVICE",nil];
	NSArray *value = [[NSArray alloc]initWithObjects:APP_CODE_QueryVoucher
                      ,[HisuntechOrderEntity Instance].clientVersion
                      ,@"4",@"1.0",@"text/html",
                      @"",[self getSerlNo],userNo,merNo,orderAmt,mService,nil];
    NSDictionary* jsonDict = [self buildMessage:key value:value];
    return jsonDict;
}
+(NSDictionary *)getCheckPhoneCodeJsonString:(NSString *)phoneNum smsCode:(NSString *)smsCode{
    NSArray *key = [[NSArray alloc]initWithObjects:@"TXN_CD",@"VERSION",@"PLAT"
                    ,@"PLUGINVER",@"CONTTYPE ",@"MCID",@"SERLNO",@"BNKPHONE",@"SMSCD",nil];
	NSArray *value = [[NSArray alloc]initWithObjects:APP_CODE_CheckSmsCode
                      ,[HisuntechOrderEntity Instance].clientVersion
                      ,@"4",@"1.0",@"text/html",
                      @"",[self getSerlNo],phoneNum,smsCode,nil];
    NSDictionary* jsonDict = [self buildMessage:key value:value];
    return jsonDict;
}
/**
 * OSDKMCA1/SDK4090210-查询红包-codeType 6 -APP_CODE_QueryRedPacket
 */
+(NSDictionary *)getRedPacketMsgJsonString:(NSString *)userNo
                                     merNo:(NSString *)merNo
                                  orderAmt:(NSString *)orderAmt
                                  mService:(NSString *)mService{
    
    NSArray *key = [[NSArray alloc]initWithObjects:@"TXN_CD",@"VERSION",@"PLAT"
                    ,@"PLUGINVER",@"CONTTYPE ",@"MCID",@"SERLNO",@"USRNO",@"MER_NO",@"ORD_AMT",@"SERVICE",nil];
	NSArray *value = [[NSArray alloc]initWithObjects:APP_CODE_QueryRedPacket
                      ,[HisuntechOrderEntity Instance].clientVersion
                      ,@"4",@"1.0",@"text/html",
                      @"",[self getSerlNo],userNo,merNo,orderAmt,mService,nil];
    NSDictionary* jsonDict = [self buildMessage:key value:value];
    return jsonDict;
}
/**
 *  OSDKMCA1/SDK4090120-账户支付-codeType 7 -APP_CODE_AccountPay
 */
+(NSDictionary *)getAccountPayJsonString:(NSString*)userId//手机号
                                  userNo:(NSString*)userNo//内部用户号
                                regEmail:(NSString*)regEmail//邮箱号
                                 payType:(NSString*)payType//付款类型
                                 sdkCert:(NSString*)sdkCert//证书公钥
                                 signStr:(NSString*)signStr//签名值
                                 charSet:(NSString*)charSet//字符集
                                 reqData:(NSString*)reqData//接口请求数据
                                 reqCert:(NSString*)reqCert//商户证书公钥
                                signData:(NSString*)signData//商户签名值
                                signType:(NSString*)signType//签名方式
                                  bonStr:(NSString*)bonStr//使用红包拼接字符串
                               bonTotAmt:(NSString*)bonTotAmt//红包使用金额
                                  vchStr:(NSString*)vchStr//使用代金券拼接字符串
                               vchTotAmt:(NSString*)vchTotAmt//代金券使用金额
                               payAmtStr:(NSString*)payAmtStr
                             prdProperty:(NSString*)prdProperty{//支付总金额
    
    NSArray *key = [[NSArray alloc]initWithObjects:@"TXN_CD",
                    @"VERSION",
                    @"PLAT",
                    @"PLUGINVER",
                    @"CONTTYP",
                    @"MCID",
                    @"SERLNO",
                    @"USRID",
                    @"USRNO",
                    @"REG_EMAIL",
                    @"PAYTYPE",
                    @"SDKCERT",
                    @"SIGNVAL",
                    @"CHARSET",
                    @"REQ_DATA",
                    @"REQ_CERT",
                    @"REQ_SIGN",
                    @"SIGN_TYPE",
                    @"BON_STR",
                    @"BON_TOT_AMT",
                    @"VCH_STR",
                    @"VCH_TOT_AMT",
                    @"PAY_AMT",
                    @"REDUCE_STR",nil];
	NSArray *value = [[NSArray alloc]initWithObjects:APP_CODE_AccountPay
                      ,[HisuntechOrderEntity Instance].clientVersion
                      ,@"4",@"1.0",@"text/html",
                      @"",[self getSerlNo],userId,userNo,regEmail,payType,sdkCert,signStr,charSet,reqData,reqCert,signData,signType,bonStr,bonTotAmt,vchStr,vchTotAmt,payAmtStr,prdProperty,nil];
    NSDictionary* jsonDict = [self buildMessage:key value:value];
    return jsonDict;
}

/**
 *  OSDKMCA1/SDK4090070-捡起订单账户支付-codeType 8 -APP_CODE_PickOrderAccountPay
 */
+(NSDictionary *)getPickOrderAccountPayJsonString:(NSString*)userId//手机号
                                           userNo:(NSString*)userNo//内部用户号
                                         regEmail:(NSString*)regEmail//邮箱号
                                            credt:(NSString*)credt//订单建立日期
                                            ordNo:(NSString*)ordNo//内部订单号
                                         merOrdNo:(NSString*)merOrdNo//商户订单号
                                           bonStr:(NSString*)bonStr//使用红包拼接字符串
                                        bonTotAmt:(NSString*)bonTotAmt//红包使用金额
                                           vchStr:(NSString*)vchStr//使用代金券拼接字符串
                                        vchTotAmt:(NSString*)vchTotAmt//代金券使用金额
                                        payAmtStr:(NSString*)payAmtStr{//支付总金额
    NSArray *key = [[NSArray alloc]initWithObjects:@"TXN_CD",@"VERSION",@"PLAT"
                    ,@"PLUGINVER",@"CONTTYPE ",@"MCID",@"SERLNO",@"USRID",@"USRNO",@"REG_EMAIL",@"CREDT",@"ORDNO",@"MERCORDNO",@"BON_STR",@"BON_TOT_AMT",@"VCH_STR",@"VCH_TOT_AMT",@"PAY_AMT",nil];
	NSArray *value = [[NSArray alloc]initWithObjects:APP_CODE_PickOrderAccountPay
                      ,[HisuntechOrderEntity Instance].clientVersion
                      ,@"4",@"1.0",@"text/html",
                      @"",[self getSerlNo],userId,userNo,regEmail,credt,ordNo,merOrdNo,bonStr,bonTotAmt,vchStr,vchTotAmt,payAmtStr,nil];
    NSDictionary* jsonDict = [self buildMessage:key value:value];
    return jsonDict;
}

/**
 *  OAPPMCA1/APP4080010-登录-codeType 9 -APP_CODE_UserLogin
 */
+(NSDictionary *)getLoginJsonString:(NSString*)userId//手机号
                              email:(NSString*)regEmail//邮箱号
                                psw:(NSString*)psw{//登录密码
    NSArray *key = [[NSArray alloc]initWithObjects:@"TXN_CD",@"VERSION",@"PLAT"
                    ,@"PLUGINVER",@"CONTTYPE",@"MCID",@"SERLNO",@"USRID",@"REG_EMAIL",@"LOGPSW",nil];
    NSArray *value = [[NSArray alloc]initWithObjects:APP_CODE_UserLogin
                      ,[HisuntechOrderEntity Instance].clientVersion
                      ,@"4",@"1.0",@"text/html",
                      @"",[self getSerlNo],userId,regEmail,psw,nil];
    NSDictionary* jsonDict = [self buildMessage:key value:value];
    return jsonDict;
}

/**
 *  OAPPMCA1/APP4080250-查询绑定银行卡-codeType 10 -APP_CODE_QueryBindBankMsg
 */
+(NSDictionary *)getBindBankMsgJsonString:(NSString*)userId//手机号
                                   userNo:(NSString*)userNo//内部用户号
                                 regEmail:(NSString*)regEmail{//邮箱号
    
    NSArray *key = [[NSArray alloc]initWithObjects:@"TXN_CD",@"VERSION",@"PLAT"
                    ,@"PLUGINVER",@"CONTTYPE",@"MCID",@"SERLNO",@"USRID",@"USRNO",@"REG_EMAIL",nil];
	NSArray *value = [[NSArray alloc]initWithObjects:APP_CODE_QueryBindBankMsg
                      ,[HisuntechOrderEntity Instance].clientVersion
                      ,@"4",@"1.0",@"text/html",
                      @"",[self getSerlNo],userId,userNo,regEmail,nil];
    NSDictionary* jsonDict = [self buildMessage:key value:value];
    return jsonDict;
}

/**
 *  OSDKMCA1/SDK4090140-快捷卡支付-codeType 11 -APP_CODE_QuickCardPay
 */
+(NSDictionary *)getQuickCardPayJsonString:(NSString*)userId//手机号
                                    userNo:(NSString*)userNo//内部用户号
                                  regEmail:(NSString*)regEmail//邮箱号
                                    bonStr:(NSString*)bonStr//使用红包拼接字符串
                                 bonTotAmt:(NSString*)bonTotAmt//红包使用金额
                                    vchStr:(NSString*)vchStr//使用代金券拼接字符串
                                 vchTotAmt:(NSString*)vchTotAmt//代金券使用金额
                                   charSet:(NSString*)charSet//字符集
                                   reqData:(NSString*)reqData//接口请求数据
                                   reqCert:(NSString*)reqCert//商户证书公钥
                                  signData:(NSString*)signData//商户签名值
                                  signType:(NSString*)signType//签名方式
                                    payAmt:(NSString*)payAmt//快捷支付金额
                                  payTotal:(NSString*)payTotal//支付总金额
                                accountAmt:(NSString*)accountAmt//账户支付总金额
                                       pwd:(NSString*)pwd//支付密码
                                    bankNo:(NSString*)bankNo//银行简称
                                      cvn2:(NSString*)cvn2//cvn2
                                   bankNum:(NSString*)bankNum//银行卡号
                                      date:(NSString*)date//有效期
                                  phoneNum:(NSString*)phoneNum//银行预留手机号
                                    crdTyp:(NSString*)crdTyp//绑定卡类型
                                      name:(NSString*)name//持卡人姓名
                                     IDnum:(NSString*)IDnum//持卡人身份证号
                                     AgrNo:(NSString*)AgrNo{
    
    NSArray *key = [[NSArray alloc]initWithObjects:@"TXN_CD",@"VERSION",@"PLAT"
                    ,@"PLUGINVER",@"CONTTYPE",@"MCID",@"SERLNO",@"USRID",@"USRNO",@"REG_EMAIL",@"BON_STR",@"BON_TOT_AMT",@"VCH_STR",@"VCH_TOT_AMT",@"PAY_AMT",@"CHARSET",@"REQ_DATA",@"REQ_CERT",@"REQ_SIGN",@"SIGN_TYPE",@"PAYTOTAL",@"ACCOUNT_AMT",@"PAYPSW",@"BNKNO",@"CVN2",@"BNKCRDNO",@"CRDEXPDT",@"BNKPHONE",@"CRDTYP",@"CRDHOLDERNM",@"ID_NO",@"AGR_NO",nil];
	NSArray *value = [[NSArray alloc]initWithObjects:APP_CODE_QuickCardPay
                      ,[HisuntechOrderEntity Instance].clientVersion
                      ,@"4",@"1.0",@"text/html",
                      @"",[self getSerlNo],userId,userNo,regEmail,bonStr,bonTotAmt,vchStr,vchTotAmt,payAmt,charSet,reqData,reqCert,signData,signType,payTotal,accountAmt,pwd,bankNo,cvn2,bankNum,date,phoneNum,crdTyp,name,IDnum,AgrNo,nil];
    NSDictionary* jsonDict = [self buildMessage:key value:value];
    return jsonDict;
}

/**
 *  OSDKMCA1/SDK4090010-校验支付密码-codeType 12 -APP_CODE_CheckPayPwd
 */
+(NSDictionary *)getCheckPayPwdJsonString:(NSString*)userId//手机号
                                   userNo:(NSString*)userNo//内部用户号
                                 regEmail:(NSString*)regEmail//邮箱号
                                      pwd:(NSString*)pwd{//支付密码
    
    NSArray *key = [[NSArray alloc]initWithObjects:@"TXN_CD",@"VERSION",@"PLAT"
                    ,@"PLUGINVER",@"CONTTYPE",@"MCID",@"SERLNO",@"USRID",@"USRNO",@"REG_EMAIL",@"PAYPSW",nil];
	NSArray *value = [[NSArray alloc]initWithObjects:APP_CODE_CheckPayPwd
                      ,[HisuntechOrderEntity Instance].clientVersion
                      ,@"4",@"1.0",@"text/html",
                      @"",[self getSerlNo],userId,userNo,regEmail,pwd,nil];
    NSDictionary* jsonDict = [self buildMessage:key value:value];
    return jsonDict;
}

/**
 *  OSDKMCA1/SDK4090260-快捷充值-codeType 13 -APP_CODE_QuickCardRecharge
 */
+(NSDictionary *)getQuickCardRechargeJsonString:(NSString*)userId//手机号
                                         userNo:(NSString*)userNo//内部用户号
                                       regEmail:(NSString*)regEmail//邮箱号
                                            pwd:(NSString*)pwd//支付密码
                                         bankNo:(NSString*)bankNo//银行简称
                                        bankNum:(NSString*)bankNum//银行卡号
                                       phoneNum:(NSString*)phoneNum//银行预留手机号
                                           name:(NSString*)name//持卡人姓名
                                          IDnum:(NSString*)IDnum//持卡人身份证号
                                    rechargeAmt:(NSString*)rechargeAmt{//快捷充值金额
    
    NSArray *key = [[NSArray alloc]initWithObjects:@"TXN_CD",@"VERSION",@"PLAT"
                    ,@"PLUGINVER",@"CONTTYPE",@"MCID",@"SERLNO",@"USRID",@"USRNO",@"REG_EMAIL",@"PAYPSW",@"BNKNO",@"BNKCRDNO",@"BNKPHONE",@"CRDHOLDERNM",@"ID_NO",@"RECHARGE_AMT",nil];
	NSArray *value = [[NSArray alloc]initWithObjects:APP_CODE_QuickCardRecharge
                      ,[HisuntechOrderEntity Instance].clientVersion
                      ,@"4",@"1.0",@"text/html",
                      @"",[self getSerlNo],userId,userNo,regEmail,pwd,bankNo,bankNum,phoneNum,name,IDnum,rechargeAmt,nil];
    NSDictionary* jsonDict = [self buildMessage:key value:value];
    return jsonDict;
}

/**
 *  OSDKMCA1/SDK4090150-快捷卡捡起订单支付-codeType 14 -APP_CODE_PickOrderQuickCardPay
 */
+(NSDictionary *)getPickOrderQuickCardPayJsonString:(NSString*)userId//手机号
                                             userNo:(NSString*)userNo//内部用户号
                                           regEmail:(NSString*)regEmail//邮箱号
                                             bonStr:(NSString*)bonStr//使用红包拼接字符串
                                          bonTotAmt:(NSString*)bonTotAmt//红包使用金额
                                             vchStr:(NSString*)vchStr//使用代金券拼接字符串
                                          vchTotAmt:(NSString*)vchTotAmt//代金券使用金额
                                           orderAmt:(NSString*)orderAmt//订单金额
                                              credt:(NSString*)credt//订单建立日期
                                            orderNo:(NSString*)orderNo//内部订单号
                                         merOrderNo:(NSString*)merOrderNo//商户订单号
                                             payAmt:(NSString*)payAmt//支付总金额
                                           payTotal:(NSString*)payTotal//订单总金额
                                         accountAmt:(NSString*)accountAmt//账户支付总金额
                                                pwd:(NSString*)pwd//支付密码
                                             bankNo:(NSString*)bankNo//银行简称
                                               cvn2:(NSString*)cvn2//cvn2
                                            bankNum:(NSString*)bankNum//银行卡号
                                               date:(NSString*)date//有效期
                                           phoneNum:(NSString*)phoneNum//银行预留手机号
                                             crdTyp:(NSString*)crdTyp//绑定卡类型
                                               name:(NSString*)name//持卡人姓名
                                              IDnum:(NSString*)IDnum
                                              AgrNo:(NSString*)AgrNo{//持卡人身份证号
    NSArray *key = [[NSArray alloc]initWithObjects:@"TXN_CD",@"VERSION",@"PLAT"
                    ,@"PLUGINVER",@"CONTTYPE",@"MCID",@"SERLNO",@"USRID",@"USRNO",@"REG_EMAIL",@"BON_STR",@"BON_TOT_AMT",@"VCH_STR",@"VCH_TOT_AMT",@"PAY_AMT",@"PAYTOTAL",@"ACCOUNT_AMT",@"PAYPSW",@"BNKNO",@"CVN2",@"BNKCRDNO",@"CRDEXPDT",@"BNKPHONE",@"CRDTYP",@"CRDHOLDERNM",@"ID_NO",@"ORD_AMT",@"CREDT",@"ORDNO",@"MERCORDNO",@"AGR_NO",nil];
	NSArray *value = [[NSArray alloc]initWithObjects:APP_CODE_PickOrderQuickCardPay
                      ,[HisuntechOrderEntity Instance].clientVersion
                      ,@"4",@"1.0",@"text/html",
                      @"",[self getSerlNo],userId,userNo,regEmail,bonStr,bonTotAmt,vchStr,vchTotAmt,payAmt,payTotal,accountAmt,pwd,bankNo,cvn2,bankNum,date,phoneNum,crdTyp,name,IDnum,orderAmt,credt,orderNo,merOrderNo,AgrNo,nil];
    NSDictionary* jsonDict = [self buildMessage:key value:value];
    return jsonDict;
}

/**
 *  OAPPMCA1/APP4080630-更新账户信息-codeType 15 -APP_CODE_UpdateAccountMsg
 */
+(NSDictionary *)getUpdateAccountMsgJsonString:(NSString*)userId//手机号
                                        userNo:(NSString*)userNo//内部用户号
                                      regEmail:(NSString*)regEmail{//邮箱号
    
    NSArray *key = [[NSArray alloc]initWithObjects:@"TXN_CD",@"VERSION",@"PLAT"
                    ,@"PLUGINVER",@"CONTTYPE",@"MCID",@"SERLNO",@"USRID",@"USRNO",@"REG_EMAIL",nil];
	NSArray *value = [[NSArray alloc]initWithObjects:APP_CODE_UpdateAccountMsg
                      ,[HisuntechOrderEntity Instance].clientVersion
                      ,@"4",@"1.0",@"text/html",
                      @"",[self getSerlNo],userId,userNo,regEmail,nil];
    NSDictionary* jsonDict = [self buildMessage:key value:value];
    return jsonDict;
}
/**
 *OAPPMCA1/APP4080450-商城订单金额-codeType 16 -APP_CODE_Account_Pay
 */
+(NSDictionary *)getOrderMoneyJsonString:(NSString *)userNo
                              merOrderNo:(NSString *)merOrderNo
                              orderMoney:(NSString *)orderMoney{
    NSArray *key = [[NSArray alloc]initWithObjects:@"TXN_CD",@"VERSION",@"PLAT"
                    ,@"PLUGINVER",@"CONTTYPE",@"MCID",@"SERLNO",@"USRNO",@"MER_NO",@"ORD_AMT",nil];
	NSArray *value = [[NSArray alloc]initWithObjects:APP_CODE_Account_Pay
                      ,[HisuntechOrderEntity Instance].clientVersion
                      ,@"4",@"1.0",@"text/html",
                      @"",[self getSerlNo],userNo,merOrderNo,orderMoney,nil];
    NSDictionary* jsonDict = [self buildMessage:key value:value];
    return jsonDict;
    
}
// 验证支付密码 17

+(NSDictionary *)checkPayPasswordWithUserid:(NSString *)userId
                                     userno:(NSString *)userNo
                                     payPwd:(NSString *)payPwd
                                   regEmail:(NSString *)regEmail
{
    
    NSArray *key = [[NSArray alloc]initWithObjects:@"TXN_CD",@"VERSION",@"PLAT"
                    ,@"PLUGINVER",@"CONTTYPE ",@"MCID",@"SERLNO",@"USRNO",@"USRID",@"PAYPSW",@"REG_EMAIL",nil];
	NSArray *value = [[NSArray alloc]initWithObjects:CheckPayPasswordCode
                      ,[HisuntechOrderEntity Instance].clientVersion
                      ,@"4",@"1.0",@"text/html",
                      @"",[self getSerlNo],userNo,userId,payPwd,regEmail,nil];
    NSDictionary* jsonDict = [self buildMessage:key value:value];
    return jsonDict;
}
//充值添加银行卡 codeType = 18
+(NSDictionary *)addBankCardWithUserNO:(NSString *)userNo
                                bankNo:(NSString *)bankNo
                            bankcardNo:(NSString *)bankcardNo
                              bnkPhone:(NSString *)bnkPhone
                              cardType:(NSString *)cardType
                                 chkNO:(NSString *)
chkNO
                        cardHolderName:(NSString *)cardHolderName
                                 IDnum:(NSString *)idNum
                              userType:(NSString *)userType
                              crdexpDt:(NSString *)crdexpDt
                                  cvn2:(NSString *)cvn2
{
    
    NSArray *key = [[NSArray alloc]initWithObjects:@"TXN_CD",@"VERSION",@"PLAT"
                    ,@"PLUGINVER",@"CONTTYPE ",@"MCID",@"SERLNO",@"USRNO",@"BNKNO",@"BNKCRDNO",@"BNKPHONE",@"CRDTYP",@"CHK_NO",@"CRDHOLDERNM",@"ID_NO",@"USERTYP",@"CRDEXPDT",@"CVV2",nil];
	NSArray *value = [[NSArray alloc]initWithObjects:APP_CODE_ADDBankCard
                      ,[HisuntechOrderEntity Instance].clientVersion
                      ,@"4",@"1.0",@"text/html",
                      @"",[self getSerlNo],userNo,bankNo,bankcardNo,bnkPhone,cardType,chkNO,cardHolderName,idNum,userType,crdexpDt,cvn2,nil];
    NSDictionary* jsonDict = [self buildMessage:key value:value];
    return jsonDict;
}

/**
 *  注册  检查验证码
 */
+ (NSDictionary *)getRegisterPhoneCodeJsonString:(NSString *)phoneNum userType:(NSString *)userType smsCode:(NSString *)smsCode
{
    NSArray *key = [[NSArray alloc]initWithObjects:@"TXN_CD",@"VERSION",@"PLAT"
                    ,@"PLUGINVER",@"CONTTYPE ",@"MCID",@"SERLNO",@"MBL_NO",@"USETYP",@"MSGPSW",nil];
	NSArray *value = [[NSArray alloc]initWithObjects:APP_CODE_Check_Register_SmsCode
                      ,[HisuntechOrderEntity Instance].clientVersion
                      ,@"4",@"1.0",@"text/html",
                      @"",[self getSerlNo],phoneNum,userType,smsCode,nil];
    NSDictionary* jsonDict = [self buildMessage:key value:value];
    return jsonDict;
}

//注册 APP_CODE_UserRegister @"OAPPMCA1/APP4080020" 35
+(NSDictionary *)getRegisterJsonString:(NSString*)userId//手机号
                              regEmail:(NSString*)regEmail//邮箱号
                              loginPwd:(NSString*)loginPwd//
                                payPwd:(NSString*)payPwd
                                pswQue:(NSString*)pswQue
                                pswAns:(NSString*)pswAns
                               smsCode:(NSString*)smsCode
                                idName:(NSString *)idName
                             idCardNum:(NSString *)cardNum
{
    
    NSArray *key = [[NSArray alloc]initWithObjects:@"TXN_CD",@"VERSION",@"PLAT"
                    ,@"PLUGINVER",@"CONTTYPE",@"MCID",@"SERLNO",@"USRID",@"REG_EMAIL",@"LOG_PSWD",@"PAY_PSWD",@"PSW_QES",@"PSW_ANS",@"MSG_PSW",@"USRNM",@"IDNO",nil];
	NSArray *value = [[NSArray alloc]initWithObjects:APP_CODE_UserRegister
                      ,[HisuntechOrderEntity Instance].clientVersion
                      ,@"4",@"1.0",@"text/html",
                      @"",[self getSerlNo],userId,regEmail,loginPwd,payPwd,pswQue,pswAns,smsCode,idName,cardNum,nil];
    NSDictionary* jsonDict = [self buildMessage:key value:value];
    return jsonDict;
}
/**
 * OAPPMCA1/APP4080040-修改密码校验验证码-codeType 5 -APP_CODE_CheckSmsCode
 */
+(NSDictionary *)getCheckPhoneCodeJsonString:(NSString *)phoneNum
                                    userType:(NSString *)userType
                                     smsCode:(NSString *)smsCode
{
    
    NSArray *key = [[NSArray alloc]initWithObjects:@"TXN_CD",@"VERSION",@"PLAT"
                    ,@"PLUGINVER",@"CONTTYPE ",@"MCID",@"SERLNO",@"MBL_NO",@"USETYP",@"MSGPSW",nil];
	NSArray *value = [[NSArray alloc]initWithObjects:APP_CODE_Check_Register_SmsCode
                      ,[HisuntechOrderEntity Instance].clientVersion
                      ,@"4",@"1.0",@"text/html",
                      @"",[self getSerlNo],phoneNum,userType,smsCode,nil];
    NSDictionary* jsonDict = [self buildMessage:key value:value];
    return jsonDict;
}

//重置登录密码 OAPPMCA1/APP4080050--22--APP_CODE_ResetLoginPwd
+(NSDictionary *)getResetLoginPwdMsgJsonString:(NSString*)userId//手机号
                                      regEmail:(NSString*)regEmail//邮箱号
                                   novLoginPwd:(NSString*)novLoginPwd{//新登录密码
    NSArray *key = [[NSArray alloc]initWithObjects:@"TXN_CD",@"VERSION",@"PLAT"
                    ,@"PLUGINVER",@"CONTTYPE ",@"MCID",@"SERLNO",@"USRID",@"REG_EMAIL",@"NEWLOGPSW",nil];
	NSArray *value = [[NSArray alloc]initWithObjects:APP_CODE_ResetLoginPwd
                      ,[HisuntechOrderEntity Instance].clientVersion
                      ,@"4",@"1.0",@"text/html",
                      @"",[self getSerlNo],userId,regEmail,novLoginPwd,nil];
    NSDictionary* jsonDict = [self buildMessage:key value:value];
    return jsonDict;
}

//银联支付@"charset",@"req_data",@"req_cert",@"req_sign",@"sign_type"
+(NSDictionary *)getBankPayWithCharset:(NSString *)charset
                              req_data:(NSString *)req_data
                              req_cert:(NSString *)req_cert
                              req_sign:(NSString *)req_sign
                             sign_type:(NSString *)sign_type
{
    NSArray *key = [[NSArray alloc]initWithObjects:@"TXN_CD",@"VERSION",@"PLAT"
                    ,@"PLUGINVER",@"CONTTYPE ",@"MCID",@"SERLNO",@"charset",@"req_data",@"req_cert",@"req_sign",@"sign_type",nil];
    NSArray *value = [[NSArray alloc]initWithObjects:APP_CODE_MakeOrder
                      ,[HisuntechOrderEntity Instance].clientVersion
                      ,@"4",@"1.0",@"text/html",
                      @"",[self getSerlNo],charset,req_data,req_cert,req_sign,sign_type,nil];
    NSDictionary* jsonDict = [self buildMessage:key value:value];
    return jsonDict;
}

//找回支付密码的 相关的网络请求

//查询安全问题 OAPPMCA1/APP4080080--24--APP_CODE_QuerySafeQuestion
+(NSDictionary *)getPayQuestionMsgJsonString:(NSString*)userId//手机号
                                      userNo:(NSString*)userNo//内部用户号
                                    regEmail:(NSString*)regEmail{//邮箱号
    NSArray *key = [[NSArray alloc]initWithObjects:@"TXN_CD",@"VERSION",@"PLAT"
                    ,@"PLUGINVER",@"CONTTYPE ",@"MCID",@"SERLNO",@"USRNO",@"USRID",@"REG_EMAIL",nil];
    NSArray *value = [[NSArray alloc]initWithObjects:APP_CODE_QuerySafeQuestion
                      ,[HisuntechOrderEntity Instance].clientVersion
                      ,@"4",@"1.0",@"text/html",
                      @"",[self getSerlNo],userNo,userId,regEmail,nil];
    NSDictionary* jsonDict = [self buildMessage:key value:value];
    return jsonDict;
}



//重置支付密码 OAPPMCA1/APP4080090--23--APP_CODE_ResetPayPwd
+(NSDictionary *)getResetPayPwdMsgJsonString:(NSString*)userId//手机号
                                      userNo:(NSString*)userNo//内部用户号
                                    question:(NSString*)question//安全问题
                                      answer:(NSString*)answer//问题答案
                                   novPayPwd:(NSString*)novPayPwd{//新支付密码
    NSArray *key = [[NSArray alloc]initWithObjects:@"TXN_CD",@"VERSION",@"PLAT"
                    ,@"PLUGINVER",@"CONTTYPE ",@"MCID",@"SERLNO",@"USRNO",@"USRID",@"QUES1",@"ANS1",@"NEWPAYPSW",nil];
    NSArray *value = [[NSArray alloc]initWithObjects:APP_CODE_ResetPayPwd
                      ,[HisuntechOrderEntity Instance].clientVersion
                      ,@"4",@"1.0",@"text/html",
                      @"",[self getSerlNo],userNo,userId,question,answer,novPayPwd,nil];
    NSDictionary* jsonDict = [self buildMessage:key value:value];
    return jsonDict;
}

//重置 登录密码 上传身份证和 密保的接口
+(NSDictionary *)findPWDWithPhoneNum:(NSString *)phone withOPR_TYP:(NSString *)oprTyp withCHW_QUES1:(NSString *)question withCHW_ANS1:(NSString *)ans
{
    NSArray *key = [[NSArray alloc]initWithObjects:@"TXN_CD",@"VERSION",@"PLAT"
                    ,@"PLUGINVER",@"CONTTYPE ",@"MCID",@"SERLNO",@"MBL_NO",@"OPR_TYP",@"CHW_QUES1",@"CHW_ANS1",nil];
    NSArray *value = [[NSArray alloc]initWithObjects:APP_CODE_FindPWD
                      ,[HisuntechOrderEntity Instance].clientVersion
                      ,@"4",@"1.0",@"text/html",
                      @"",[self getSerlNo],phone,oprTyp,question,ans,nil];
    NSDictionary* jsonDict = [self buildMessage:key value:value];
    return jsonDict;
}


//身份证
+(NSDictionary *)findPWDWithPhoneNum:(NSString *)phone withOPR_TYP:(NSString *)oprTyp withIDCard:(NSString *)card
{
    NSArray *key = [[NSArray alloc]initWithObjects:@"TXN_CD",@"VERSION",@"PLAT"
                    ,@"PLUGINVER",@"CONTTYPE ",@"MCID",@"SERLNO",@"MBL_NO",@"OPR_TYP",@"IC_NO",nil];
    NSArray *value = [[NSArray alloc]initWithObjects:APP_CODE_FindPWD
                      ,[HisuntechOrderEntity Instance].clientVersion
                      ,@"4",@"1.0",@"text/html",
                      @"",[self getSerlNo],phone,oprTyp,card,nil];
    NSDictionary* jsonDict = [self buildMessage:key value:value];
    return jsonDict;
}


//查询是否设置支付密码 44
+(NSDictionary *)checkPwdMsgJsonString:(NSString*)userId    //手机号
                                userNo:(NSString*)userNo //内部用户号
{
    NSArray *key = [[NSArray alloc]initWithObjects:@"TXN_CD",@"VERSION",@"PLAT"
                    ,@"PLUGINVER",@"CONTTYPE ",@"MCID",@"SERLNO",@"USRNO",@"PHONE",nil];
    
    NSArray *value = [[NSArray alloc]initWithObjects:APP_CODE_CheckSetPwdCode
                      ,[HisuntechOrderEntity Instance].clientVersion
                      ,@"4",@"1.0",@"text/html",
                      @"",[self getSerlNo],userNo,userId,nil];
    NSDictionary* jsonDict = [self buildMessage:key value:value];
    return jsonDict;
}
//设置支付密码 45
+(NSDictionary *)setPwdMsgJsonString:(NSString*)userId//手机号
                              userNo:(NSString*)userNo//内部用户号
                            question:(NSString*)question//安全问题
                              answer:(NSString*)answer//问题答案
                           newPayPwd:(NSString*)newPayPwd //新的支付密码

{
    NSArray *key = [[NSArray alloc]initWithObjects:@"TXN_CD",@"VERSION",@"PLAT"
                    ,@"PLUGINVER",@"CONTTYPE ",@"MCID",@"SERLNO",@"USRNO",@"PHONE",@"QUES1",@"ANS1",@"PAY_PSWD_NEW",nil];
    NSArray *value = [[NSArray alloc]initWithObjects:APP_CODE_SetPwdCode
                      ,[HisuntechOrderEntity Instance].clientVersion
                      ,@"4",@"1.0",@"text/html",
                      @"",[self getSerlNo],userNo,userId,question,answer,newPayPwd,nil];
    NSDictionary* jsonDict = [self buildMessage:key value:value];
    return jsonDict;
}
@end

