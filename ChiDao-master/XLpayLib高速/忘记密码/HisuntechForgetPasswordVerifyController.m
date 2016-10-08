//
//  ForgetPasswordVerifyController.m
//  HisunPay
//
//  Created by scofield on 14-11-14.
//  Copyright (c) 2014年 com.hisuntech. All rights reserved.
//

#import "HisuntechForgetPasswordVerifyController.h"
#import "HisuntechForgetPasswordResetingController.h"
#import "HisuntechUIColor+YUColor.h"
#import "IDViewController.h"
#import "QuestionViewController.h"

@interface HisuntechForgetPasswordVerifyController ()

@property (nonatomic,strong) UITextField *verifyField;
@property (nonatomic,strong) UIButton *countDown;
@property (nonatomic,assign) NSInteger count;

@end

@implementation HisuntechForgetPasswordVerifyController

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
    [self setLeftItemToBack];
    self.navigationController.navigationBarHidden = NO;
    self.title = @"重置登录密码";
    
    self.view.backgroundColor = kColor(225, 235, 239, 1);
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, screenWidth, 50)];
    label.font = [UIFont boldSystemFontOfSize:13];
    label.textColor = [UIColor grayColor];
    
    
    NSString *lastFour = [self.phoneNumber.text substringFromIndex:self.phoneNumber.text.length - 4];
    label.text = [NSString stringWithFormat:@"     请输入尾号为%@手机收到的4位短信验证码",lastFour];
    [self.view addSubview:label];
    
    self.verifyField = [[UITextField alloc]initWithFrame:CGRectMake(0, 50+64 ,screenWidth , 50)];
    self.verifyField.delegate = self;
    self.verifyField.placeholder = @"请输入验证码";
    self.verifyField.backgroundColor = [UIColor whiteColor];
    self.verifyField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.verifyField.leftViewMode = UITextFieldViewModeAlways;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 50)];
    self.verifyField.leftView = view;
    self.verifyField.keyboardType = UIKeyboardTypeNumberPad;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame =CGRectMake(0, 0, 120, 50);
    [button setTitle:@"(179秒)重新获取" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [button setTitleColor:kColor(201, 201, 201, 1) forState:UIControlStateNormal];
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
//    NSString * imagePath = ResourcePath(@"login_btn_n.9.png");
//    [submit setBackgroundImage:[UIImage imageWithContentsOfFile:imagePath] forState:UIControlStateNormal];
    [submit setBackgroundColor:[UIColor colorWithHexString:@"#41b886" withAlpha:1]];
    submit.layer.cornerRadius = 3;
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
    NSDictionary *requestDict = [HisuntechBuildJsonString getRegisterPhoneCodeJsonString:self.phoneNumber.text userType:@"2" smsCode:self.verifyField.text];
    //请求服务器 发送短信验证码
    [self requestServer:requestDict requestType:APP_CODE_Check_Register_SmsCode codeType:3];
}

- (void)submitVerify
{
    if (self.verifyField.text == nil||[@"" isEqual:self.verifyField.text]) {
        [self toastResult:@"请输入验证码"];
        return;
    }
    
    NSDictionary *requestDict = [HisuntechBuildJsonString getCheckPhoneCodeJsonString:self.phoneNumber.text userType:@"2" smsCode:self.verifyField.text];
    // 检查 验证码是否正确
    [self requestServer:requestDict requestType:APP_CODE_Check_Register_SmsCode codeType:10];
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
            NSUserDefaults *selectSta = [NSUserDefaults standardUserDefaults];
            NSString *selectStaStr = [selectSta objectForKey:@"selectStatus"];
            if ([selectStaStr isEqualToString:@"0"]) {
                IDViewController *card = [[IDViewController alloc] init];
                card.phoneNumber = self.phoneNumber;
                [self.navigationController pushViewController:card animated:YES];
            }else
            {
                QuestionViewController *question = [[QuestionViewController alloc] init];
                question.phoneNumber = self.phoneNumber;
                [self.navigationController pushViewController:question animated:YES];
            }
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

@end
