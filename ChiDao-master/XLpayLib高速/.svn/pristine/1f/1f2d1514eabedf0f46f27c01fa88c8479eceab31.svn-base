//
//  UserEntity.m
//  tfpay
//
//  Created by yanxiaogang on 14-8-4.
//  Copyright (c) 2014年 THTF. All rights reserved.
//

#import "HisuntechUserEntity.h"

@implementation HisuntechUserEntity

@synthesize changeDate;//资金变动日期
@synthesize serverTime;//服务器时间
@synthesize userNo;//内部用户号
@synthesize userId;//用户ID
@synthesize userNm;//用户姓名
@synthesize relFlg;//实名认证标识
@synthesize  drwBal;//账户余额
@synthesize  loginPwd;//登录密码
@synthesize  payPwd;//支付密码
@synthesize  pwdQes;//密保问题
@synthesize  pwdAns;//密保答案
@synthesize  smsCode;//短信验证码
@synthesize  userTyp;//短信验证码用途
@synthesize  loginPwdNew;//新登录密码
@synthesize  oldPayPwd;//旧支付密码
@synthesize  oldLoginPwd;//旧登录密码
@synthesize  payPwdNew;//新支付密码
@synthesize  idCard;//身份证号码
@synthesize  bankNo;//银行编号
@synthesize  bankCardNo;//银行卡号
@synthesize  bindTyp;//银行卡绑定类型 2快捷1提现0-消费
@synthesize  bindCardNum;//最多绑定银行卡数目
@synthesize  cvn2;//CVN2
@synthesize  cardExpDt;//银行卡有效期
@synthesize  bankPhone;//银行预留手机号
@synthesize  cardTyp;//绑定类型 1-信用卡 0-借记卡
@synthesize  txnAmt;//提现金额
@synthesize  stlBal;//可用来做提现、收付款交易的余额
@synthesize  strDt;//起始日期
@synthesize endDt;//结束日期
@synthesize pagNo;//页码
@synthesize pagNum;//每页记录数
@synthesize recNum;//当前查询记录笔数
@synthesize totRecNum;//总笔数
@synthesize pagCnt;//总页数
@synthesize ordNo;//订单号
@synthesize ordDt;//订单日期
@synthesize ordTm;//订单时间
@synthesize ordSts;//订单状态
@synthesize feeAmt;//手续费
@synthesize ordStsNm;//订单状态中文
@synthesize busCnl;//交易渠道
@synthesize bankNm;//银行名称
@synthesize recNum0;//绑定消费银行卡
@synthesize recNum1;//绑定提现银行卡
@synthesize recNum2;//绑定快捷银行卡
@synthesize totCardNum;//绑定所有银行卡记录数
@synthesize cardNoLast;//银行卡号
@synthesize conUserId;//联系人账号
@synthesize conUserNm;//联系人姓名
@synthesize conAlsNm;//联系人别名
@synthesize toUserId;//待收款人ID
@synthesize toUserNm;//待收款人姓名
@synthesize rcvUserId;//收款方账号
@synthesize payAmt;//付款金额
@synthesize payFlag;//收付款标识 P-付款 G-收款
@synthesize drwTotBal;//现金账户-可用余额
@synthesize trfSts;//转账状态
@synthesize payDt;//付款日期
@synthesize trnUserId;//付款人手机号
@synthesize oppUserId;//收款人手机号
@synthesize ordExpDt;//订单失效日期
@synthesize ordExpTm;//订单失效时间
@synthesize rmk;//备注
@synthesize rechargeAmt;//充值金额
@synthesize payTyp;//充值类型 1、刷卡2、	线上
@synthesize creDt;//订单建立日期
@synthesize creTm;//订单建立时间
@synthesize merNo;//商户编号
@synthesize merOrdNo;//商户订单编号
@synthesize refundAmt;//已退款金额
@synthesize merNm;//商户名称
@synthesize prdcNm;//商品名称
@synthesize pubKey;//公钥
@synthesize cusNm;//用户名
@synthesize realNmFlag;//实名状态
@synthesize wcAplAmt;//查询手续费上送交易金额	单位元
@synthesize FEE_CD;//查询手续费交易类 型	01-转账 03-提现
@synthesize trBank;//付款银行简称
@synthesize randomKey;//随机因子
@synthesize bonSts;//红包使用状态	0可用，1不可用
@synthesize prdTyp;//类别	券别：0红包，1代金券
@synthesize bonrecNum;//张数
@synthesize msgCD;//返回码
@synthesize msgInf;//返回码描述
@synthesize bankNameCN;//银行中文名称
@synthesize mode;//判断密码管理跳转
@synthesize phoneLastFour;//手机号最后四位
@synthesize isLoading;//交易查询不进行转圈
@synthesize detailDic;//查询详情信息
@synthesize findPwdMode;//点击找回密码判断
@synthesize bankCardNoRel;//银行卡号不加*
@synthesize nameBank;//银行预留姓名
@synthesize rechargeComo;//充值跳转来源
@synthesize registerMode;//判断注册跳转
@synthesize protol;
@synthesize province;
@synthesize city;
@synthesize address;
@synthesize index;
+(HisuntechUserEntity *)Instance{
    
	static HisuntechUserEntity *shareSingleton;
	@synchronized(self){
		if (!shareSingleton) {
			shareSingleton=[[HisuntechUserEntity alloc]init];
            [HisuntechUserEntity Instance].isLoading = YES;//交易查询不进行转圈,默认正常请求是转圈的
		}
		
	}
	return shareSingleton;
}

+(void)releaseData{
    [HisuntechUserEntity Instance].registerMode = @"";//判断注册跳转
    [HisuntechUserEntity Instance].rechargeComo = @"";
    [HisuntechUserEntity Instance].nameBank = @"";
    [HisuntechUserEntity Instance].bankCardNoRel = @"";
   [HisuntechUserEntity Instance].findPwdMode = @"";//点击找回密码判断
    [HisuntechUserEntity Instance].detailDic = @{@"REC":@""};;//查询详情信息
    [HisuntechUserEntity Instance].isLoading = YES;//交易查询不进行转圈,默认正常请求是转圈的
    [HisuntechUserEntity Instance].phoneLastFour = @"";//手机号最后四位
    [HisuntechUserEntity Instance].mode = @"";//判断密码管理跳转
    [HisuntechUserEntity Instance].bankNameCN = @"";//银行中文名称
    [HisuntechUserEntity Instance].changeDate = @"";//资金变动日期
    [HisuntechUserEntity Instance].serverTime = @"";//服务器时间
    [HisuntechUserEntity Instance].userNo = @"";//内部用户号
    [HisuntechUserEntity Instance].userId = @"";//用户ID
    [HisuntechUserEntity Instance].userNm = @"";//用户姓名
    [HisuntechUserEntity Instance].relFlg = @"";//实名认证标识
    [HisuntechUserEntity Instance].drwBal = @"";//账户余额
    [HisuntechUserEntity Instance].loginPwd = @"";//登录密码
    [HisuntechUserEntity Instance].payPwd = @"";//支付密码
    [HisuntechUserEntity Instance].pwdQes = @"";//密保问题
    [HisuntechUserEntity Instance].pwdAns = @"";//密保答案
    [HisuntechUserEntity Instance].smsCode = @"";//短信验证码
    [HisuntechUserEntity Instance].userTyp = @"";//短信验证码用途
    [HisuntechUserEntity Instance].loginPwdNew = @"";//新登录密码
    [HisuntechUserEntity Instance].oldPayPwd = @"";//旧支付密码
    [HisuntechUserEntity Instance].oldLoginPwd = @"";//旧登录密码
    [HisuntechUserEntity Instance].payPwdNew = @"";//新支付密码
    [HisuntechUserEntity Instance].idCard = @"";//身份证号码
    [HisuntechUserEntity Instance].bankNo = @"";//银行编号
    [HisuntechUserEntity Instance].bankCardNo = @"";//银行卡号
    [HisuntechUserEntity Instance].bindTyp = @"";//银行卡绑定类型 2快捷1提现0-消费
    [HisuntechUserEntity Instance].bindCardNum = @"";//最多绑定银行卡数目
    [HisuntechUserEntity Instance].cvn2 = @"";//CVN2
    [HisuntechUserEntity Instance].cardExpDt = @"";//银行卡有效期
    [HisuntechUserEntity Instance].bankPhone = @"";//银行预留手机号
    [HisuntechUserEntity Instance].cardTyp = @"";//绑定类型 1-信用卡 0-借记卡
    [HisuntechUserEntity Instance].txnAmt = @"";//提现金额
    [HisuntechUserEntity Instance].stlBal = @"";//可用来做提现、收付款交易的余额
    [HisuntechUserEntity Instance].strDt = @"";//起始日期
    [HisuntechUserEntity Instance].endDt = @"";//结束日期
    [HisuntechUserEntity Instance].pagNo = @"";//页码
    [HisuntechUserEntity Instance].pagNum = @"";//每页记录数
    [HisuntechUserEntity Instance].recNum = @"";//当前查询记录笔数
    [HisuntechUserEntity Instance].totRecNum = @"";//总笔数
    [HisuntechUserEntity Instance].pagCnt = @"";//总页数
    [HisuntechUserEntity Instance].ordNo = @"";//订单号
    [HisuntechUserEntity Instance].ordDt = @"";//订单日期
    [HisuntechUserEntity Instance].ordTm = @"";//订单时间
    [HisuntechUserEntity Instance].ordSts = @"";//订单状态
    [HisuntechUserEntity Instance].feeAmt = @"";//手续费
    [HisuntechUserEntity Instance].ordStsNm = @"";//订单状态中文
    [HisuntechUserEntity Instance].busCnl = @"";//交易渠道
    [HisuntechUserEntity Instance].bankNm = @"";//银行名称
    [HisuntechUserEntity Instance].recNum0 = @"";//绑定消费银行卡
    [HisuntechUserEntity Instance].recNum1 = @"";//绑定提现银行卡
    [HisuntechUserEntity Instance].recNum2 = @"";//绑定快捷银行卡
    [HisuntechUserEntity Instance].totCardNum = @"";//绑定所有银行卡记录数
    [HisuntechUserEntity Instance].cardNoLast = @"";//银行卡号
    [HisuntechUserEntity Instance].conUserId = @"";//联系人账号
    [HisuntechUserEntity Instance].conUserNm = @"";//联系人姓名
    [HisuntechUserEntity Instance].conAlsNm = @"";//联系人别名
    [HisuntechUserEntity Instance].toUserId = @"";//待收款人ID
    [HisuntechUserEntity Instance].toUserNm = @"";//待收款人姓名
    [HisuntechUserEntity Instance].rcvUserId = @"";//收款方账号
    [HisuntechUserEntity Instance].payAmt = @"";//付款金额
    [HisuntechUserEntity Instance].payFlag = @"";//收付款标识 P-付款 G-收款
    [HisuntechUserEntity Instance].drwTotBal = @"";//现金账户-可用余额
    [HisuntechUserEntity Instance].trfSts = @"";//转账状态
    [HisuntechUserEntity Instance].payDt = @"";//付款日期
    [HisuntechUserEntity Instance].trnUserId = @"";//付款人手机号
    [HisuntechUserEntity Instance].oppUserId = @"";//收款人手机号
    [HisuntechUserEntity Instance].ordExpDt = @"";//订单失效日期
    [HisuntechUserEntity Instance].ordExpTm = @"";//订单失效时间
    [HisuntechUserEntity Instance].rmk = @"";//备注
    [HisuntechUserEntity Instance].rechargeAmt = @"";//充值金额
    [HisuntechUserEntity Instance].payTyp = @"";//充值类型 1、刷卡2、	线上
    [HisuntechUserEntity Instance].creDt = @"";//订单建立日期
    [HisuntechUserEntity Instance].creTm = @"";//订单建立时间
    [HisuntechUserEntity Instance].merNo = @"";//商户编号
    [HisuntechUserEntity Instance].merOrdNo = @"";//商户订单编号
    [HisuntechUserEntity Instance].refundAmt = @"";//已退款金额
    [HisuntechUserEntity Instance].merNm = @"";//商户名称
    [HisuntechUserEntity Instance].prdcNm = @"";//商品名称
    [HisuntechUserEntity Instance].pubKey = @"";//公钥
    [HisuntechUserEntity Instance].cusNm = @"";//用户名
    [HisuntechUserEntity Instance].realNmFlag = @"";//实名状态
    [HisuntechUserEntity Instance].wcAplAmt = @"";//查询手续费上送交易金额	单位元
    [HisuntechUserEntity Instance].FEE_CD = @"";//查询手续费交易类 型	01-转账 03-提现
    [HisuntechUserEntity Instance].trBank = @"";//付款银行简称
    [HisuntechUserEntity Instance].randomKey = @"";//随机因子
    [HisuntechUserEntity Instance].bonSts = @"";//红包使用状态	0可用，1不可用
    [HisuntechUserEntity Instance].prdTyp = @"";//类别	券别：0红包，1代金券
    [HisuntechUserEntity Instance].bonrecNum = @"";//张数
    [HisuntechUserEntity Instance].msgCD = @"";//返回码
    [HisuntechUserEntity Instance].msgInf = @"";//返回码描述
    [HisuntechUserEntity Instance].isShowMain = NO;
    [HisuntechUserEntity Instance].protol = @"";//协议号
}


@end
