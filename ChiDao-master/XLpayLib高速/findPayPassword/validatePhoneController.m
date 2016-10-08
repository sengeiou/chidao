//
//  validatePhoneController.m
//  HisunPay
//
//  Created by 王鑫 on 14-11-4.
//  Copyright (c) 2014年 com.hisuntech. All rights reserved.
//

#import "validatePhoneController.h"
#import "captchaController.h"

@interface validatePhoneController ()

@end

@implementation validatePhoneController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:225/255.0 green:235/255.0 blue:239/255.0 alpha:1];
    
    self.title = @"重置支付密码";
    [self setLeftItemToBack];
    
    [self createUI];
    // Do any additional setup after loading the view.
}

-(void)backPop
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}



-(void)createUI{
    
    
    UIView *phoneView = [[UIView alloc]initWithFrame:CGRectMake(0, 74, [UIScreen mainScreen].bounds.size.width, 50)];
    phoneView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:phoneView];
    
    self.phoneNum = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, 300, 50)];
    self.phoneNum.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneNum.placeholder = @"请输入注册账号";
    self.phoneNum.clearButtonMode  = UITextFieldViewModeWhileEditing;
    self.phoneNum.text = [HisuntechUserEntity Instance].userId;
    [phoneView addSubview:self.phoneNum];
    
    self.commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.commitBtn.frame = CGRectMake(20, 170, 280, 36);
    [self.commitBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    self.commitBtn.layer.cornerRadius = 5;
    self.commitBtn.clipsToBounds = YES;
    [self.commitBtn setBackgroundColor:[UIColor colorWithRed:37/255.0 green:183/255.0 blue:148/255.0 alpha:1]];
    [self.commitBtn addTarget:self action:@selector(commitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.commitBtn];
}

//提交号码成功返回验证码时调用
- (void)VerifyMessage:(id)response
{
    NSError *error;
    NSData * dataResponse = [NSJSONSerialization dataWithJSONObject:response options:NSJSONWritingPrettyPrinted error:&error];
    NSDictionary *dictJson = [NSJSONSerialization JSONObjectWithData:dataResponse options:NSJSONReadingMutableLeaves error:&error];
    
    if ([@"MCA00000" isEqual:[dictJson objectForKey:@"RSP_CD"] ] ) {
        
        captchaController *captcha = [[captchaController alloc]init];
        [self.navigationController pushViewController:captcha animated:YES];
        
    }else{
        [self toastResult:[dictJson objectForKey:@"RSP_MSG"]];
    }
}

- (void)failure:(NSError *)error
{
    [self toastResult:@"请检查您当前网络"];
}

/**
 *  提交手机号
 */
-(void)commitBtnClick
{
    //校验手机号
    if (self.phoneNum.text == nil||[@"" isEqual:self.phoneNum.text]) {
        [self toastResult:@"请输入手机号"];
        return;
    }
//    if (checkPhoneNumMsg == NO){
//        [self toastResult:@"手机号输入有误"];
//        return;
//    }
#warning 这个地方要写谁的号码 没有  接口类型  没有
    
    if (![self.phoneNum.text isEqualToString:[HisuntechUserEntity Instance].userId]) {
        [self toastResult:@"与当前账号不一致"];
        return;
    }
    
    NSDictionary *dict = [HisuntechBuildJsonString getSendPhoneCodeJsonString:[HisuntechUserEntity Instance].userId userType:@"8"];
    
    [self requestServer:dict requestType:APP_CODE_SmsCode successSel:@selector(VerifyMessage:) failureSel:@selector(failure:)];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
