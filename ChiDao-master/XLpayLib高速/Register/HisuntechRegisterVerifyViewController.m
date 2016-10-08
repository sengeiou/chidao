//
//  RegisterVerifyViewController.m
//  HisunPay
//
//  Created by scofield on 14-11-3.
//  Copyright (c) 2014年 com.hisuntech. All rights reserved.
//

#import "HisuntechRegisterVerifyViewController.h"
#import "HisuntechRegisterSettingPasswordViewController.h"
#import "HisuntechUserEntity.h"
#import "HisuntechUIColor+YUColor.h"
@interface HisuntechRegisterVerifyViewController ()<UITextFieldDelegate>

@property (nonatomic,strong) UITextField *verifyField;
@property (nonatomic,strong) UIButton *countDown;
@property (nonatomic,assign) NSInteger count;

@end

@implementation HisuntechRegisterVerifyViewController

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
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    [self setLeftItemToBack];
    self.title = @"注册";
    self.view.backgroundColor = kColor(225, 235, 239, 1);
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, screenWidth, 50)];
    label.font = [UIFont boldSystemFontOfSize:13];
    label.textColor = [UIColor grayColor];
    
    
    NSString *lastFour = [self.sendMessagePhone substringFromIndex:self.sendMessagePhone.length - 4];
    label.text = [NSString stringWithFormat:@"     请输入尾号为%@手机收到的短信验证码",lastFour];
    [self.view addSubview:label];
    
    self.verifyField = [[UITextField alloc]initWithFrame:CGRectMake(0, 50 + 64  ,screenWidth , 50)];
    self.verifyField.delegate = self;
    self.verifyField.placeholder = @"请输入验证码";
    self.verifyField.backgroundColor = [UIColor whiteColor];
    self.verifyField.clearButtonMode = YES;
    self.verifyField.leftViewMode = UITextFieldViewModeAlways;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 50)];
    self.verifyField.leftView = view;
    self.verifyField.keyboardType = UIKeyboardTypeNumberPad;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame =CGRectMake(0, 0, 120, 50);
    [button setBackgroundColor:[UIColor colorWithHexString:@"#41b886" withAlpha:1]];
    [button setTitle:@"(179秒)重新获取" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0.3, 50)];
    lineView.backgroundColor = kColor(204, 210, 216, 1);
    [button addSubview:lineView];
    
    [self.view addSubview:self.verifyField];
    self.countDown = button;
    self.verifyField.rightView = self.countDown;
    [self.countDown addTarget:self action:@selector(reVerify) forControlEvents:UIControlEventTouchUpInside];
    self.verifyField.rightViewMode = UITextFieldViewModeAlways;
    
    UIButton *submit = [UIButton buttonWithType:UIButtonTypeCustom];
    [submit setTitle:@"提交" forState:UIControlStateNormal];
    [submit.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [submit setBackgroundColor:[UIColor colorWithHexString:@"#41b886" withAlpha:1]];
    submit.layer.cornerRadius = 4;
    submit.clipsToBounds = YES;
    [submit addTarget:self action:@selector(submitVerify) forControlEvents:UIControlEventTouchUpInside];
    CGFloat y = self.verifyField.frame.origin.y + self.verifyField.frame.size.height + 20;
    
    submit.frame = CGRectMake((screenWidth - 300)/2, y, 300, 40);
    
    [self.view addSubview:submit];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeTitle:) userInfo:nil repeats:YES];
    
    _count = 179;
}

- (void)changeTitle:(NSTimer *)timer
{
    if (_count == 0) {
        [self.countDown setTitle:@"重新发送" forState:UIControlStateNormal];
        return;
    }
    _count--;
    NSString *title = [NSString stringWithFormat:@"(%ld秒后)重新获取",(long)_count];
    [self.countDown setTitle:title forState:UIControlStateNormal];
}

// 重新请求新的验证码
- (void)reVerify
{
    if (_count > 0) {
        return;
    }
    _count = 179;
    [self.countDown setTitle:@"重新发送" forState:UIControlStateNormal];
    
    //发送短信验证码 上行参数
    NSDictionary *requestDict = [HisuntechBuildJsonString getSendPhoneCodeJsonString:self.sendMessagePhone
                                                                   userType:@"1"];
    
    //请求服务器 发送短信验证码
    [self requestServer:requestDict requestType:APP_CODE_SmsCode codeType:3];
}

- (void)submitVerify
{
    [self.view endEditing:YES];
    if (self.verifyField.text == nil||[@"" isEqual:self.verifyField.text]) {
        [self toastResult:@"请输入验证码"];
        return;
    }
    
    NSDictionary *requestDict = [HisuntechBuildJsonString getRegisterPhoneCodeJsonString:self.sendMessagePhone userType:@"1" smsCode:self.verifyField.text];
    
    // 检查 验证码是否正确
    [self requestServer:requestDict requestType:APP_CODE_Check_Register_SmsCode successSel:@selector(CheckSmsSuc:) failureSel:@selector(failure:)];
}

// 验证码  短信验证码  成功返回
- (void)CheckSmsSuc:(id)response
{
    NSError *error;
    NSData * dataResponse = [NSJSONSerialization dataWithJSONObject:response options:NSJSONWritingPrettyPrinted error:&error];
    NSDictionary *dictJson = [NSJSONSerialization JSONObjectWithData:dataResponse options:NSJSONReadingMutableLeaves error:&error];
    
    if ([@"MCA00000" isEqual:[dictJson objectForKey:@"RSP_CD"]]) {
        [HisuntechUserEntity Instance].smsCode = self.verifyField.text;
        HisuntechRegisterSettingPasswordViewController *rpw = [[HisuntechRegisterSettingPasswordViewController alloc]init];
        rpw.sendMessagePhone = self.sendMessagePhone;
        [self.navigationController pushViewController:rpw animated:YES];
    }else{
        [self toastResult:[dictJson objectForKey:@"RSP_MSG"]];
    }
}


- (void)failure:(NSError *)error
{
    [self toastResult:@"请检查您当前网络"];
}

/**
 *  请求服务器成功
 */
-(void)resquestSuccess:(id)response{
    
    NSError *error;
    NSData * dataResponse = [NSJSONSerialization dataWithJSONObject:response options:NSJSONWritingPrettyPrinted error:&error];
    NSDictionary *dictJson = [NSJSONSerialization JSONObjectWithData:dataResponse options:NSJSONReadingMutableLeaves error:&error];
    //发送短信验证码
    if (codeType==3) {
        if ([@"MCA00000" isEqual:[dictJson objectForKey:@"RSP_CD"] ] ) {
            [self toastResult:@"短信验证码已发送"];
        }else{
            [self toastResult:[dictJson objectForKey:@"RSP_MSG"]];
        }
        return;
    }
    //检查   验证码
    if (codeType == 10) {
        if ([@"MCA00000" isEqual:[dictJson objectForKey:@"RSP_CD"]]) {
            [HisuntechUserEntity Instance].smsCode = self.verifyField.text;
            HisuntechRegisterSettingPasswordViewController *rpw = [[HisuntechRegisterSettingPasswordViewController alloc]init];
            rpw.sendMessagePhone = self.sendMessagePhone;
            [self.navigationController pushViewController:rpw animated:YES];
        }else{
            [self toastResult:[dictJson objectForKey:@"RSP_MSG"]];
        }
    }
}
/**
 *  请求服务器失败
 */
-(void)resquestFail:(id)response{
    if (codeType==3 || codeType == 10) {
        [self toastResult:@"请检查您当前网络"];
        return;
    }
}


- (void)dealloc
{
    [self.view endEditing:YES];
    self.verifyField = nil;
    self.countDown = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
