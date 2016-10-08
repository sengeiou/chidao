//
//  ForgetPasswordViewController.h
//  HisunPay
//
//  Created by scofield on 14-11-13.
//  Copyright (c) 2014年 com.hisuntech. All rights reserved.
//

#import "HisuntechBaseViewController.h"
#import "HisuntechPooCodeView.h"
@interface HisuntechForgetPasswordViewController : HisuntechBaseViewController



@property (nonatomic,strong) UITextField *phoneNumber;//手机号
@property (nonatomic,strong) UITextField *verifyCode;// 验证图
@property (nonatomic,strong) HisuntechPooCodeView *pooCode;// 随机数字图片


@end
