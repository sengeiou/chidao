//
//  UserEntity.h
//  tfpay
//
//  Created by yanxiaogang on 14-8-4.
//  Copyright (c) 2014年 THTF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HisuntechUserEntity : NSObject{
    
    NSString  *province;//开户省
    NSString  *city;//开户市
    NSString  *address;//开户支行地址
    NSString  *protol; //协议号码
    NSString  *rechargeComo;//充值跳转来源
    NSString  *nameBank;//银行预留姓名
    NSString  *findPwdMode;//点击找回密码判断
    NSString  *bankNameCN;//银行中文名称
    NSString  *userNo;//内部用户号
    NSString  *userId;//用户ID
    NSString  *userNm;//用户姓名
    NSString  *relFlg;//实名认证标识
    NSString  *drwBal;//账户余额
    NSString  *loginPwd;//登录密码
    NSString  *payPwd;//支付密码
    NSString  *pwdQes;//密保问题
    NSString  *pwdAns;//密保答案
    NSString  *smsCode;//短信验证码
    NSString  *userTyp;//短信验证码用途
    NSString  *loginPwdNew;//新登录密码
    NSString  *oldPayPwd;//旧支付密码
    NSString  *oldLoginPwd;//旧登录密码
    NSString  *payPwdNew;//新支付密码
    NSString  *idCard;//身份证号码
    NSString  *bankNo;//银行编号
    NSString  *bankCardNo;//银行卡号
    NSString  *bankCardNoRel;//银行卡号不加*
    NSString  *bindTyp;//银行卡绑定类型 2快捷1提现0-消费
    NSString  *serverTime;//服务器时间
    NSString  *bindCardNum;//最多绑定银行卡数目
    NSString  *cvn2;//CVN2
    NSString  *cardExpDt;//银行卡有效期
    NSString  *bankPhone;//银行预留手机号
    NSString  *cardTyp;//绑定类型 1-信用卡 0-借记卡
    
    NSString  *txnAmt;//提现金额
    NSString  *stlBal;//可用来做提现、收付款交易的余额
    NSString  *strDt;//起始日期
    NSString *endDt;//结束日期
    NSString *pagNo;//页码
    NSString *pagNum;//每页记录数
    NSString *recNum;//当前查询记录笔数
    NSString *totRecNum;//总笔数
    NSString *pagCnt;//总页数
    NSString *ordNo;//订单号
    NSString *ordDt;//订单日期
    NSString *ordTm;//订单时间
    NSString *ordSts;//订单状态
    NSString *feeAmt;//手续费
    NSString *ordStsNm;//订单状态中文
    NSString *busCnl;//交易渠道
    NSString *bankNm;//银行名称
    NSString *recNum0;//绑定消费银行卡
    NSString *recNum1;//绑定提现银行卡
    NSString *recNum2;//绑定快捷银行卡
    NSString *totCardNum;//绑定所有银行卡记录数
    NSString *cardNoLast;//银行卡号
    NSString *conUserId;//联系人账号
    NSString *conUserNm;//联系人姓名
    NSString *conAlsNm;//联系人别名
    NSString *toUserId;//待收款人ID
    NSString *toUserNm;//待收款人姓名
    NSString *rcvUserId;//收款方账号
    NSString *payAmt;//付款金额
    NSString *payFlag;//收付款标识 P-付款 G-收款
    
    NSString *drwTotBal;//现金账户-可用余额
    NSString *trfSts;//转账状态
    NSString *payDt;//付款日期
    NSString *trnUserId;//付款人手机号
    NSString *oppUserId;//收款人手机号
    NSString *ordExpDt;//订单失效日期
    NSString *ordExpTm;//订单失效时间
    NSString *rmk;//备注
    NSString *rechargeAmt;//充值金额
    NSString *payTyp;//充值类型 1、刷卡2、	线上
    NSString *creDt;//订单建立日期
    NSString *creTm;//订单建立时间
    NSString *merNo;//商户编号
    NSString *merOrdNo;//商户订单编号
    NSString *refundAmt;//已退款金额
    NSString *merNm;//商户名称
    NSString *prdcNm;//商品名称
    NSString *pubKey;//公钥
    NSString *cusNm;//用户名
    NSString *realNmFlag;//实名状态
    NSString *wcAplAmt;//查询手续费上送交易金额	单位元
    NSString *FEE_CD;//查询手续费交易类 型	01-转账 03-提现
    NSString *trBank;//付款银行简称
    NSString *randomKey;//随机因子
    NSString *bonSts;//红包使用状态	0可用，1不可用
    NSString *prdTyp;//类别	券别：0红包，1代金券
    NSString *bonrecNum;//张数
    NSString *msgCD;//返回码
    NSString *msgInf;//返回码描述
    NSString *changeDate;//资金变动日期
    NSString *mode;//判断密码管理跳转
    NSString *phoneLastFour;//手机号最后四位
    Boolean isLoading;//交易查询不进行转圈
    NSDictionary *detailDic;//查询详情信息
    NSString *registerMode;//判断注册跳转
    NSInteger index;
}
@property(nonatomic,assign) NSInteger index;//选中的是第几个城市
@property(nonatomic,retain) NSString *province;
@property(nonatomic,retain) NSString *city;
@property(nonatomic,retain) NSString *address;
@property(nonatomic,retain) NSString *protol;
@property(nonatomic,retain)   NSString *registerMode;//判断注册跳转
@property(nonatomic,retain)  NSString  *rechargeComo;//充值跳转来源
@property(nonatomic,retain)  NSString  *nameBank;//银行预留姓名
@property(nonatomic,retain) NSString  *bankCardNoRel;//银行卡号不加*
@property(nonatomic,retain) NSString  *findPwdMode;//点击找回密码判断
@property(nonatomic,retain) NSDictionary *detailDic;//查询详情信息
@property Boolean isLoading;//交易查询不进行转圈
@property(nonatomic,retain) NSString *phoneLastFour;//手机号最后四位
@property(nonatomic,retain) NSString *mode;//判断密码管理跳转
@property(nonatomic,retain) NSString  *bankNameCN;//银行中文名称
@property(nonatomic,retain) NSString  *changeDate;//资金变动日期
@property(nonatomic,retain) NSString  *serverTime;//服务器时间
@property(nonatomic,retain) NSString  *userNo;//内部用户号
@property(nonatomic,retain) NSString  *userId;//用户ID
@property(nonatomic,retain) NSString  *userNm;//用户姓名
@property(nonatomic,retain) NSString  *relFlg;//实名认证标识
@property(nonatomic,retain) NSString  *drwBal;//账户余额
@property(nonatomic,retain) NSString  *loginPwd;//登录密码
@property(nonatomic,retain) NSString  *payPwd;//支付密码
@property(nonatomic,retain) NSString  *pwdQes;//密保问题
@property(nonatomic,retain) NSString  *pwdAns;//密保答案
@property(nonatomic,retain) NSString  *smsCode;//短信验证码
@property(nonatomic,retain) NSString  *userTyp;//短信验证码用途
@property(nonatomic,retain) NSString  *loginPwdNew;//新登录密码
@property(nonatomic,retain) NSString  *oldPayPwd;//旧支付密码
@property(nonatomic,retain) NSString  *oldLoginPwd;//旧登录密码
@property(nonatomic,retain) NSString  *payPwdNew;//新支付密码
@property(nonatomic,retain) NSString  *idCard;//身份证号码
@property(nonatomic,retain) NSString  *bankNo;//银行编号
@property(nonatomic,retain) NSString  *bankCardNo;//银行卡号
@property(nonatomic,retain) NSString  *bindTyp;//银行卡绑定类型 2快捷1提现0-消费
@property(nonatomic,retain) NSString  *bindCardNum;//最多绑定银行卡数目
@property(nonatomic,retain) NSString  *cvn2;//CVN2
@property(nonatomic,retain) NSString  *cardExpDt;//银行卡有效期
@property(nonatomic,retain) NSString  *bankPhone;//银行预留手机号
@property(nonatomic,retain) NSString  *cardTyp;//绑定类型 1-信用卡 0-借记卡
@property(nonatomic,retain) NSString  *txnAmt;//提现金额
@property(nonatomic,retain) NSString  *stlBal;//可用来做提现、收付款交易的余额
@property(nonatomic,retain) NSString  *strDt;//起始日期
@property(nonatomic,retain) NSString *endDt;//结束日期
@property(nonatomic,retain) NSString *pagNo;//页码
@property(nonatomic,retain) NSString *pagNum;//每页记录数
@property(nonatomic,retain) NSString *recNum;//当前查询记录笔数
@property(nonatomic,retain) NSString *totRecNum;//总笔数
@property(nonatomic,retain) NSString *pagCnt;//总页数
@property(nonatomic,retain) NSString *ordNo;//订单号
@property(nonatomic,retain) NSString *ordDt;//订单日期
@property(nonatomic,retain) NSString *ordTm;//订单时间
@property(nonatomic,retain) NSString *ordSts;//订单状态
@property(nonatomic,retain) NSString *feeAmt;//手续费
@property(nonatomic,retain) NSString *ordStsNm;//订单状态中文
@property(nonatomic,retain) NSString *busCnl;//交易渠道
@property(nonatomic,retain) NSString *bankNm;//银行名称
@property(nonatomic,retain) NSString *recNum0;//绑定消费银行卡
@property(nonatomic,retain) NSString *recNum1;//绑定提现银行卡
@property(nonatomic,retain) NSString *recNum2;//绑定快捷银行卡
@property(nonatomic,retain) NSString *totCardNum;//绑定所有银行卡记录数
@property(nonatomic,retain) NSString *cardNoLast;//银行卡号
@property(nonatomic,retain) NSString *conUserId;//联系人账号
@property(nonatomic,retain) NSString *conUserNm;//联系人姓名
@property(nonatomic,retain) NSString *conAlsNm;//联系人别名
@property(nonatomic,retain) NSString *toUserId;//待收款人ID
@property(nonatomic,retain) NSString *toUserNm;//待收款人姓名
@property(nonatomic,retain) NSString *rcvUserId;//收款方账号
@property(nonatomic,retain) NSString *payAmt;//付款金额
@property(nonatomic,retain) NSString *payFlag;//收付款标识 P-付款 G-收款
@property(nonatomic,retain) NSString *drwTotBal;//现金账户-可用余额
@property(nonatomic,retain) NSString *trfSts;//转账状态
@property(nonatomic,retain) NSString *payDt;//付款日期
@property(nonatomic,retain) NSString *trnUserId;//付款人手机号
@property(nonatomic,retain) NSString *oppUserId;//收款人手机号
@property(nonatomic,retain) NSString *ordExpDt;//订单失效日期
@property(nonatomic,retain) NSString *ordExpTm;//订单失效时间
@property(nonatomic,retain) NSString *rmk;//备注
@property(nonatomic,retain) NSString *rechargeAmt;//充值金额
@property(nonatomic,retain) NSString *payTyp;//充值类型 1、刷卡2、	线上
@property(nonatomic,retain) NSString *creDt;//订单建立日期
@property(nonatomic,retain) NSString *creTm;//订单建立时间
@property(nonatomic,retain) NSString *merNo;//商户编号
@property(nonatomic,retain) NSString *merOrdNo;//商户订单编号
@property(nonatomic,retain) NSString *refundAmt;//已退款金额
@property(nonatomic,retain) NSString *merNm;//商户名称
@property(nonatomic,retain) NSString *prdcNm;//商品名称
@property(nonatomic,retain) NSString *pubKey;//公钥
@property(nonatomic,retain) NSString *cusNm;//用户名
@property(nonatomic,retain) NSString *realNmFlag;//实名状态
@property(nonatomic,retain) NSString *wcAplAmt;//查询手续费上送交易金额	单位元
@property(nonatomic,retain) NSString *FEE_CD;//查询手续费交易类 型	01-转账 03-提现
@property(nonatomic,retain) NSString *trBank;//付款银行简称
@property(nonatomic,retain) NSString *randomKey;//随机因子
@property(nonatomic,retain) NSString *bonSts;//红包使用状态	0可用，1不可用
@property(nonatomic,retain) NSString *prdTyp;//类别	券别：0红包，1代金券
@property(nonatomic,retain) NSString *bonrecNum;//张数
@property(nonatomic,retain) NSString *msgCD;//返回码
@property(nonatomic,retain) NSString *msgInf;//返回码描述
@property (nonatomic,assign) BOOL isShowMain;// 是否显示过主界面
@property(nonatomic,assign) BOOL UnionPay;//是否是银联支付
@property(nonatomic,assign) BOOL Account;//是否是账户支付
@property(nonatomic,assign) BOOL Mixture;//是否是混合支付



@property(nonatomic,copy) NSString *USRID;
@property(nonatomic,copy) NSString *USRNO;
@property(nonatomic,copy) NSString *CREDT;
@property(nonatomic,copy) NSString *CRETM;
@property(nonatomic,copy) NSString *PARTNER_NAME;
@property(nonatomic,copy) NSString *PRODUCT_NAME;
@property(nonatomic,copy) NSString *ORDNO;
@property(nonatomic,copy) NSString *MERORDNO;
@property(nonatomic,copy) NSString *TOTAL_AMOUNT;
@property(nonatomic,copy) NSString *MERC_ID;

@property(nonatomic,copy) NSString *CHARSET;
@property(nonatomic,copy) NSString *ACTION;
@property(nonatomic,copy) NSString *REQ_DATA;
@property(nonatomic,copy) NSString *REQ_CERT;
@property(nonatomic,copy) NSString *REQ_SIGN;
@property(nonatomic,copy) NSString *SIGN_TYPE;

+(HisuntechUserEntity *)Instance;
+(void)releaseData;
@end
