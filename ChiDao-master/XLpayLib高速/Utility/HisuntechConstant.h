//
//  Constant.h
//  Demo_1
//
//  Created by Jany on 14-11-25.
//  Copyright (c) 2014年 itazk. All rights reserved.
//

#ifndef Demo_1_Constant_h
#define Demo_1_Constant_h
#import "HisuntechBuildJsonString.h"
#import "HisuntechBaseViewController.h"
#import "HisuntechUserEntity.h"
#define PayBundle @"PayBundle.bundle"

#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: PayBundle]
#define ResourcePath(fileName) [MYBUNDLE_PATH stringByAppendingPathComponent:fileName]

#endif
#define AFNETWORKING_ALLOW_INVALID_SSL_CERTIFICATES
#define kColor(r,g,b,a) [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:a]
#define screenHeight [UIScreen mainScreen].bounds.size.height
#define screenWidth [UIScreen mainScreen].bounds.size.width
#define registerLabelColor kColor(112, 117, 120, 1)
#define registerLabelFont [UIFont boldSystemFontOfSize:13]
#define registerViewBackgroundColor kColor(225, 235, 239, 1)

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define signURL @"http://123.129.210.53:8880/rsademo/dorsasign.jsp"//商户签名地址

//交易代码-入口/服务名
#define APP_CODE_PublicKey @"OAPPMCA1/APP4080620"
#define APP_CODE_RandomKey @"OAPPMCA1/APP4080720"
#define APP_CODE_SmsCode @"OAPPMCA1/APP4080030"
#define APP_CODE_CheckSmsCode @"OSDKMCA1/SDK4090250"
#define APP_CODE_Check_Register_SmsCode @"OAPPMCA1/APP4080040"
#define APP_CODE_QueryVoucher @"OSDKMCA1/SDK4090220"
#define APP_CODE_QueryRedPacket @"OSDKMCA1/SDK4090210"
#define APP_CODE_AccountPay @"OSDKMCA1/SDK4090120"//账户支付
#define APP_CODE_PickOrderAccountPay @"OSDKMCA1/SDK4090070"//捡起订单
#define APP_CODE_UserLogin @"OAPPMCA1/APP4080010"
#define APP_CODE_QuickCardPay @"OSDKMCA1/SDK4090140"
#define APP_CODE_CheckPayPwd @"OSDKMCA1/SDK4090010"
#define APP_CODE_QuickCardRecharge @"OSDKMCA1/SDK4090260"
#define APP_CODE_PickOrderQuickCardPay @"OSDKMCA1/SDK4090150"
#define APP_CODE_UpdateAccountMsg @"OAPPMCA1/APP4080630"
#define APP_CODE_Account_Pay @"OAPPMCA1/APP4080450"
#define CheckPayPasswordCode @"OSDKMCA1/SDK4090010"// 验证支付密码
#define APP_CODE_ADDBankCard @"OSDKMCA1/SDK4090151"//添加银行卡
#define APP_CODE_QueryBindBankMsg @"OSDKMCA1/SDK4090152"//查询银行卡
#define APP_REGISTER_SMS_CODE @"OAPPMCA1/APP4080040"// 注册手机  验证码
#define APP_CODE_UserRegister @"OAPPMCA1/APP4080020"
#define APP_CODE_ResetLoginPwd @"OAPPMCA1/APP4080050"
#define APP_CODE_MakeOrder @"/OSDKMCA1/SDK4090380"//下单
#define APP_CODE_FindPWD @"OAPPMCA1/APP4080980"//找回支付密码 上传密保问题和身份证的 接口

//找回支付密码的接口
#define APP_CODE_QuerySafeQuestion @"OAPPMCA1/APP4080080"//请求支付密码问题
#define APP_CODE_ResetPayPwd @"OAPPMCA1/APP4080090" //重置支付密码
#define APP_CODE_CheckPaySmsCode @"OAPPMCA1/APP4080040"

//新增接口--查询是否设置支付密码
#define APP_CODE_CheckSetPwdCode @"OAPPMCA1/APP4080990"
//新增接口--设置支付密码
#define APP_CODE_SetPwdCode @"OAPPMCA1/APP4081000"

