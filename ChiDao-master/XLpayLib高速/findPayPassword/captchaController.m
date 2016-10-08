//
//  captchaController.m
//  HisunPay
//
//  Created by 王鑫 on 14-11-4.
//  Copyright (c) 2014年 com.hisuntech. All rights reserved.
//

#import "captchaController.h"
#import "retrievePayPwdController.h"

@interface captchaController ()
{
    int time;
    NSTimer *timer;
}
@end

@implementation captchaController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        time = 180;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:225/255.0 green:235/255.0 blue:239/255.0 alpha:1];
    self.navigationItem.title = @"重置支付密码";
    [self setLeftItemToBack];
    [self createUI];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeTime) userInfo:nil repeats:YES];
    // Do any additional setup after loading the view.
}


-(void)createUI
{
    UIView *captchaView = [[UIView alloc]initWithFrame:CGRectMake(0, 50 + 64, [UIScreen mainScreen].bounds.size.width, 50)];
    captchaView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:captchaView];
    
    UILabel *la = [[UILabel alloc]initWithFrame:CGRectMake(0, 20 + 64, screenWidth, 20)];
    NSString *number = [HisuntechUserEntity Instance].userId;
    
    la.text = [NSString stringWithFormat:@"    请输入尾号为%@的手机接收到的验证码",[number substringFromIndex:number.length - 4]];
    la.backgroundColor = [UIColor clearColor];
    la.textColor = registerLabelColor;
    la.font = registerLabelFont;
    [self.view addSubview:la];
    
    self.captchaField = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, screenWidth-10, 50)];
    self.captchaField.keyboardType = UIKeyboardTypeNumberPad;
    self.captchaField.placeholder = @"输入验证码";
    self.captchaField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [captchaView addSubview:self.captchaField];
    
    self.getCaptcha = [UIButton buttonWithType:UIButtonTypeCustom];
    self.getCaptcha.frame = CGRectMake(0, 0, 120, 50);
    [self.getCaptcha setTitle:@"(180秒)重新获取" forState:UIControlStateNormal];
    [self.getCaptcha setTitleColor:registerLabelColor forState:UIControlStateNormal];
    [self.getCaptcha.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [self.getCaptcha addTarget:self action:@selector(getCaptchaClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 50)];
    line.backgroundColor = kColor(218, 223, 225, 1);
    [self.getCaptcha addSubview:line];
    
    [captchaView addSubview:self.getCaptcha];
    self.captchaField.rightView = self.getCaptcha;
    self.captchaField.rightViewMode = UITextFieldViewModeAlways;
    
    self.commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.commitBtn.frame = CGRectMake(20, 150 + 64, 280, 36);
    self.commitBtn.layer.cornerRadius = 5;
    self.commitBtn.clipsToBounds = YES;
    [self.commitBtn setBackgroundColor:[UIColor colorWithRed:37/255.0 green:183/255.0 blue:148/255.0 alpha:1]];
    [self.commitBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [self.commitBtn addTarget:self action:@selector(commitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.commitBtn];
}
-(void)commitBtnClick
{
    if ([self.captchaField.text isEqualToString:@""]||self.captchaField.text == nil) {
        [self toastResult:@"请输入验证码"];
        return;
    }
    
    //验证短信验证码 上行参数
    NSDictionary *requestDict = [HisuntechBuildJsonString getCheckPhoneCodeJsonString:[HisuntechUserEntity Instance].userId userType:@"8" smsCode:self.captchaField.text];
    [self requestServer:requestDict requestType:APP_CODE_CheckPaySmsCode successSel:@selector(CheckMessageCode:) failureSel:@selector(failure:)];
}

/**
 *  点击获取倒计时获取验证码
 */
-(void)getCaptchaClick
{
    if (time > 0) {
        return;
    }
    time = 180;
    
// 这个地方要写谁的号码 没有  接口类型  没有   先写2
    NSDictionary *dict = [HisuntechBuildJsonString getSendPhoneCodeJsonString:[HisuntechUserEntity Instance].userId userType:@"8"];
    [self requestServer:dict requestType:APP_CODE_SmsCode successSel:@selector(VerifyMessage:) failureSel:@selector(failure:)];
    
}
/**
 *  教研  验证码  成功返回
 *
 */
- (void)CheckMessageCode:(id)response
{
    NSError *error;
    NSData * dataResponse = [NSJSONSerialization dataWithJSONObject:response options:NSJSONWritingPrettyPrinted error:&error];
    NSDictionary *dictJson = [NSJSONSerialization JSONObjectWithData:dataResponse options:NSJSONReadingMutableLeaves error:&error];
    
    if ([@"MCA00000" isEqual:[dictJson objectForKey:@"RSP_CD"] ] ) {
        // 短信验证码 成功是跳转
        retrievePayPwdController *retrievePwd = [[retrievePayPwdController alloc] init];
        [self.navigationController pushViewController:retrievePwd animated:YES];
    }else{
        [self toastResult:[dictJson objectForKey:@"RSP_MSG"]];
    }
}

//提交号码成功返回验证码时调用
- (void)VerifyMessage:(id)response
{
    NSError *error;
    NSData * dataResponse = [NSJSONSerialization dataWithJSONObject:response options:NSJSONWritingPrettyPrinted error:&error];
    NSDictionary *dictJson = [NSJSONSerialization JSONObjectWithData:dataResponse options:NSJSONReadingMutableLeaves error:&error];
    
    if ([@"MCA00000" isEqual:[dictJson objectForKey:@"RSP_CD"] ] ) {
        [self toastResult:@"短信已发送，请查收"];
    }else{
        [self toastResult:[dictJson objectForKey:@"RSP_MSG"]];
    }
}

- (void)failure:(NSError *)error
{
//    NSLog(@"error: %@",error);
    [self toastResult:@"请检查您当前网络"];
}

-(void)changeTime
{
    if (time>0) {
        time--;
        [self.getCaptcha setTitle:[NSString stringWithFormat:@"(%d秒)重新获取",time] forState:UIControlStateNormal];
    }
    if (time == 0) {
        [self.getCaptcha setTitle:@"点击获取验证码" forState:UIControlStateNormal];
    }
}


@end
