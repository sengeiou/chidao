//
//  NewsClient.h
//  
//
//  Created by zy on 15/3/12.
//  Copyright (c) 2015年 zy. All rights reserved.
//

#import "HisuntechAFHTTPSessionManager.h"
@interface NewsClient : HisuntechAFHTTPSessionManager
+ (NewsClient *)sharedClient;
//-----------登录功能-----------------
////用户快速注册
//#define UserRegURL @"/accountapple/userreg"
////登录
//#define LoginURL @"/accountapple/userlog"
////注销
//#define LogoutURL @"/accountapple/logout"
////用户修改基本信息
//#define UserUpdateURL @"/accountapply/userupdate"
////token更新
//#define TokenUpdateURL @"/accountapply/tokenupdate"
////校验密码
//#define ValidatePwdURL @"/accountapply/validatePwd"
////修改密码
//#define RevisePwdURL @"/accountapply/revisePwd"
////忘记密码
//#define ForgetPwdURL @"/accountapply/forgetPwd"

-(NSURLSessionDataTask *) userReg:(NSString *)path withPhoneID:(NSString *)phomacid withAccount:(NSString *)account withMobile:(NSString *)mobile withPwd:(NSString *)pwd withMsgCode:(NSString *)msgcode withArea:(NSString *)area withRegip:(NSString *)regip completion:(void(^)(NSMutableDictionary *dic,NSError *error))completion;


-(NSURLSessionDataTask *) login:(NSString *)path withAccount:(NSString *)account withPwd:(NSString *)pwd withLoginTime:(NSString *)logintime withArea:(NSString *)area withLoginip:(NSString *)loginip withClientid:(NSString *)clientid completion:(void(^)(NSMutableDictionary *dic,NSError *error))completion;

-(NSURLSessionDataTask *) logout:(NSString *)path withToken:(NSString *)token completion:(void(^)(NSMutableDictionary *dic,NSError *error))completion;

-(NSURLSessionDataTask *) userUpdate:(NSString *)path withToken:(NSString *)token withOrgid:(NSString *)orgid withHeadpic:(NSString *)headpic withNickName:(NSString *)nickname completion:(void(^)(NSMutableDictionary *dic,NSError *error))completion;

-(NSURLSessionDataTask *) tokenUpdate:(NSString *)path withToken:(NSString *)token completion:(void(^)(NSMutableDictionary *dic,NSError *error))completion;

-(NSURLSessionDataTask *) validatePwd:(NSString *)path withOldPwd:(NSString *)oldPwd withToken:(NSString *)token completion:(void(^)(NSMutableDictionary *dic,NSError *error))completion;


-(NSURLSessionDataTask *) forgetPwd:(NSString *)path withToken:(NSString *)token withPwd:(NSString *)pwd withRePwd:(NSString *)repwd withMsgCode:(NSString *)msgcode withArea:(NSString *)area withRegip:(NSString *)regip completion:(void(^)(NSMutableDictionary *dic,NSError *error))completion;

-(NSURLSessionDataTask *) revisePwd:(NSString *)path withToken:(NSString *)token withPwd:(NSString *)pwd withRePwd:(NSString *)repwd withArea:(NSString *)area withRegip:(NSString *)regip completion:(void(^)(NSMutableDictionary *dic,NSError *error))completion;


////-----------鲁通卡功能-----------------
////鲁通卡添加
//#define AddCard @"/etc/addcard.mb"
////鲁通卡删除
//#define RemoveCard @"/etc/removecard.mb"
////鲁通卡记录查询
//#define GetCard @"/etc/getcards.mb"
////订单提交
//#define CreateOrder @"/etc/createorder.mb"
////多订单查询(根据app账单调整)
//#define GetOrders @"/etc/getorders.mb"
////卡信息查询
//#define GetCardInfo @"/etc/getcardinfo.mb"

-(NSURLSessionDataTask *) addCard:(NSString *)path withToken:(NSString *)token withCardId:(NSString *)cardid withCarval:(NSString *)carval withArea:(NSString *)area withRegip:(NSString *)regip completion:(void(^)(NSMutableDictionary *dic,NSError *error))completion;

-(NSURLSessionDataTask *) removeCard:(NSString *)path withToken:(NSString *)token withCardId:(NSString *)cardid withCarval:(NSString *)carval withArea:(NSString *)area withRegip:(NSString *)regip completion:(void(^)(NSMutableDictionary *dic,NSError *error))completion;

-(NSURLSessionDataTask *) getCard:(NSString *)path withToken:(NSString *)token completion:(void(^)(NSMutableDictionary *dic,NSError *error))completion;


-(NSURLSessionDataTask *) getOrders:(NSString *)path withToken:(NSString *)token withPagenum:(int)pagenum withPagesize:(int)pagesize withArea:(NSString *)area withRegip:(NSString *)regip completion:(void(^)(NSMutableDictionary *dic,NSError *error))completion;

-(NSURLSessionDataTask *) getCardInfo:(NSString *)path withToken:(NSString *)token withCardId:(NSString *)cardid withArea:(NSString *)area withRegip:(NSString *)regip completion:(void(^)(NSMutableDictionary *dic,NSError *error))completion;

//-----------我的功能-----------------
-(NSURLSessionDataTask *) addAddress:(NSString *)path withToken:(NSString *)token withName:(NSString *)name withAddressArea:(NSString *)addressArea withAddrDetail:(NSString *)addrDetail withPostid:(NSString *)postid withMobile:(NSString *)mobile completion:(void(^)(NSMutableDictionary *dic,NSError *error))completion;

-(NSURLSessionDataTask *) updateAddress:(NSString *)path withToken:(NSString *)token withID:(NSString *)addrid withName:(NSString *)name withAddressArea:(NSString *)addressArea withAddrDetail:(NSString *)addrDetail withPostid:(NSString *)postid withMobile:(NSString *)mobile completion:(void(^)(NSMutableDictionary *dic,NSError *error))completion;

-(NSURLSessionDataTask *) removeAddress:(NSString *)path withToken:(NSString *)token withAddrid:(NSString *)addrid withArea:(NSString *)area withRegip:(NSString *)regip completion:(void(^)(NSMutableDictionary *dic,NSError *error))completion;

-(NSURLSessionDataTask *) getAddress:(NSString *)path withToken:(NSString *)token completion:(void(^)(NSMutableDictionary *dic,NSError *error))completion;

//-----------头像上传功能-----------------


//-----------obu功能-----------------
// 1、obu亮灯次数获取
// 2、obu视频上传
// 3、obu视频激活

//obu亮灯次数获取
-(NSURLSessionDataTask *) getLightNums:(NSString *)path withToken:(NSString *)token withObuID:(NSString *)obuID completion:(void(^)(NSMutableDictionary *dic,NSError *error))completion;
//
////上传视频
//- (void)uploadFileWithMediaData:(NSMutableArray *)mediaDatas
//                            url:(NSString *)url
//                         params:(id)params;

@end
