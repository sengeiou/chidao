//
//  LoginViewController.m
//  ChiDao
//
//  Created by 赵洋 on 16/7/8.
//  Copyright © 2016年 赵洋. All rights reserved.
//

#import "LoginViewController.h"
#import "iProtect.h"
#import "RegisterViewController.h"
#import "FindPwdViewController.h"

#import "HisuntechConstant.h"
#import "NSObject+RMArchivable.h"
#import "NSUserDefaults+RMSaveCustomObject.h"
#import "RMMapper.h"
#import "LoginModel.h"
 #import "NSObject+RMArchivable.h"
@interface LoginViewController ()<UITextFieldDelegate>
{
    NSString* loginPwd;
}
@property (nonatomic,strong) UITextField *userTF;
@property (nonatomic,strong) PasswordTextField *pwdTF;
@property (nonatomic,strong) UIButton *loginBtn;

@end

@implementation LoginViewController
@synthesize loginBtn = _loginBtn;
@synthesize pwdTF = _pwdTF;
- (void)addNavButton{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    [backBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(doBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
}
-(void)doBack
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    self.view.backgroundColor = BackgroundColor;
    
    [self addNavButton];
    [self creatUI];
    
}
-(void)creatUI{
    
    //画线
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 20.0f, myScreenWidth, myLineHight1)];
    [iv setImage:[UIImage imageNamed:@"line.png"]];
    UIImageView *iv2 = [[UIImageView alloc] initWithFrame:CGRectMake(20.0f, 21.0f+50, myScreenWidth, myLineHight1)];
    [iv2 setImage:[UIImage imageNamed:@"line.png"]];
    UIImageView *iv3 = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 22.0f+100, myScreenWidth, myLineHight1)];
    [iv3 setImage:[UIImage imageNamed:@"line.png"]];
    [self.view addSubview:iv];
    [self.view addSubview:iv2];
    [self.view addSubview:iv3];
    
    //左边账户和登录密码
    UILabel *userLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 21, 80, 50.0f)];
    userLabel.text = @"账户";
    [self.view addSubview:userLabel];
    
    UILabel *pwdLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 21+50, 80, 50.0f)];
    pwdLabel.text = @"登录密码";
    [self.view addSubview:pwdLabel];
    
    //初始化用户名和密码框
    self.userTF = [[UITextField alloc] initWithFrame:CGRectMake(100.0f, 21, myScreenWidth-100, 50.0f)];
    [self.userTF setBackgroundColor:BackgroundColor];
    self.userTF.placeholder = @"手机号";
    [self.userTF setBorderStyle:UITextBorderStyleNone];
    [self.userTF setTextAlignment:NSTextAlignmentLeft];
    self.userTF.leftViewMode = UITextFieldViewModeAlways;
    [self.userTF setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self.userTF setReturnKeyType:UIReturnKeyNext];
    [self.userTF setKeyboardType:UIKeyboardTypeDefault];
    self.userTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.userTF setDelegate:self];
    [self.view addSubview:self.userTF];
    
    
    self.pwdTF = [[PasswordTextField alloc] initWithFrame:CGRectMake(100.0f, 22+50, myScreenWidth-100, 50.0f) usingPasswordKeyboard:YES];
    self.pwdTF.placeholder = @"请输入登录密码";
    [self.pwdTF setBackgroundColor:BackgroundColor];
    [self.pwdTF setBorderStyle:UITextBorderStyleNone];
    [self.pwdTF setTextAlignment:NSTextAlignmentLeft];
    self.pwdTF.leftViewMode = UITextFieldViewModeAlways;
    self.pwdTF.secureTextEntry = YES;
    [self.pwdTF setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self.pwdTF setReturnKeyType:UIReturnKeyDone];
    [self.pwdTF setKeyboardType:UIKeyboardTypeDefault];

    self.pwdTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.pwdTF setDelegate:self];
    
    //设置键盘是否乱序
    self.pwdTF.kbdRandom = YES;
    //设置加密类型
    self.pwdTF.encryptType = E_SDHS_DUAL_PLATFORM;
    [self.view addSubview:self.pwdTF];
    
    //登录btn
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginBtn.backgroundColor = btnColor;
    _loginBtn.layer.cornerRadius = myCornerRadius;
    _loginBtn.clipsToBounds = YES;
    [_loginBtn setTitle:@"登 录" forState:UIControlStateNormal];
    [_loginBtn addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginBtn];
    
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (self.pwdTF.mas_bottom).offset (20);
        make.left.mas_equalTo (self.view.mas_left).offset (10);
        make.right.mas_equalTo (self.view.mas_right).offset (-10);
        make.height.mas_equalTo (44);
    }];

    //找回密码
    UIButton *findPassword = [UIButton buttonWithType:UIButtonTypeCustom];
    [findPassword setTitleColor:DetailColor forState:UIControlStateNormal];
    [findPassword setTitle:@"找回密码" forState:UIControlStateNormal];
    findPassword.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    findPassword.titleLabel.font = [UIFont systemFontOfSize:14];
    [findPassword addTarget:self action:@selector(findPassword) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:findPassword];
    [findPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (_loginBtn.mas_bottom).offset (20);
        make.right.mas_equalTo (self.view.mas_right).offset (-10);
        make.width.mas_equalTo (90);
        make.height.mas_equalTo (20);
    }];
    
    //快速注册
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerBtn setTitleColor:DetailColor forState:UIControlStateNormal];
    [registerBtn setTitle:@"快速注册" forState:UIControlStateNormal];
    registerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [registerBtn addTarget:self action:@selector(registerUser) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (_loginBtn.mas_bottom).offset (20);
        make.left.mas_equalTo (self.view.mas_left).offset (10);
        make.width.mas_equalTo (90);
        make.height.mas_equalTo (20);
    }];
    
}
- (void)registerUser{
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}
- (void)findPassword{
    FindPwdViewController *findVC = [[FindPwdViewController alloc] init];
    [self.navigationController pushViewController:findVC animated:YES];
}
- (void)loginClick{
    if ([Tool isMobile:self.userTF.text]) {
        
        if ([self.pwdTF.text isEqualToString:@""]) {
            [Tool showMessage:@"请输入登录密码"];
        }else if([self.pwdTF.text length]>7){
            
            [self getPublicKey];
            
        }else{
            [Tool showMessage:@"登录密码不能少于8位"];
        }
    }else{
        [Tool showMessage:@"请输入正确手机号码"];
    }
    
    
}

#pragma mark -获取公钥
-(void)getPublicKey{
    //上行参数
    NSDictionary *requestDict = [HisuntechBuildJsonString getPublicKeyJsonString];
    //请求服务器 获取公钥
    [self requestServer:requestDict requestType:APP_CODE_PublicKey codeType:1];
}

#pragma mark -获取随机因子
-(void) getRandomKey{
    //上行参数
    NSDictionary *requestDict = [HisuntechBuildJsonString getRandomKeyJsonString];
    //请求服务器 获取公钥
    [self requestServer:requestDict requestType:APP_CODE_RandomKey codeType:4];
}
#pragma mark -请求服务器成功
-(void)resquestSuccess:(id)response{
    NSError *error;
    NSData * dataResponse = [NSJSONSerialization dataWithJSONObject:response options:NSJSONWritingPrettyPrinted error:&error];
    NSDictionary *dictJson = [NSJSONSerialization JSONObjectWithData:dataResponse options:NSJSONReadingMutableLeaves error:&error];
    //获取公钥
    if (codeType==1) {
        if ([@"MCA00000" isEqual:[dictJson objectForKey:@"RSP_CD"] ] ) {
            NSString *newPub = [dictJson objectForKey:@"PUBKEY"];
            [[NSUserDefaults standardUserDefaults]setObject:[dictJson objectForKey:@"PUBKEY"] forKey:@"PUBKEY"];
            NSString *oldPub = [[NSUserDefaults standardUserDefaults]objectForKey:@"PUBKEY"];
            if ([newPub isEqualToString:oldPub]) {
            }else{
                [[NSUserDefaults standardUserDefaults]setObject:[dictJson objectForKey:@"PUBKEY"] forKey:@"PUBKEY"];
                [[NSUserDefaults standardUserDefaults]synchronize];
            }
            [HisuntechUserEntity Instance].pubKey = [dictJson objectForKey:@"PUBKEY"];
            self.pwdTF.encryptionPlatformPublicKey = [HisuntechUserEntity Instance].pubKey;
            
#pragma mark -获取公钥成功之后获取随机因子
            [self getRandomKey];
        }else{
            [self toastResult:[dictJson objectForKey:@"RSP_MSG"]];
        }
        return;
    }
    //获取随机因子
    if (codeType == 4) {
        if ([@"MCA00000" isEqual:[dictJson objectForKey:@"RSP_CD"] ] ) {
            //得到服务器时间之后，进行登录
            
            loginPwd = [self.pwdTF getValue:[NSString stringWithFormat:@"%@000",[dictJson objectForKey:@"SYSTM"]]];
            #pragma mark -获取随机因子成功之后进行登录
            
            [self login];
        }else{
            [self toastResult:[dictJson objectForKey:@"RSP_MSG"]];
        }
        return;
    }

}
/**
 *  请求服务器失败
 */
-(void)resquestFail:(id)response{
    if (codeType==1||codeType==4||codeType==9) {
        [self toastResult:@"请检查您当前网络"];
        return;
    }
}

- (void)login{
    NSURLSessionDataTask *task = [[NewsClient sharedClient] login:LoginURL withAccount:self.userTF.text withPwd:loginPwd withLoginTime:[Tool getCurrentTime] withArea:[APPConfig getInstance].currentCity withLoginip:[Tool getIpAddresses] withClientid:@"12345" completion:^(NSMutableDictionary *dic, NSError *error) {
        
        if (!error) {
            
            if ([[dic objectForKey:@"code"] isEqualToString:@"000000"]) {
                
                [[APPConfig getInstance] setTokenWord:[[dic objectForKey:@"data"] objectForKey:@"token"]];
                
                LoginModel* lm = [RMMapper objectWithClass:[LoginModel class] fromDictionary:[dic objectForKey:@"data"]];
                
                NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                [defaults rm_setCustomObject:lm forKey:@"CD_LoginModel"];
                
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CD_updateAccount" object:nil];
                [self doBack];
                [Tool showMessage:@"登录成功"];
                
            }else{
                
                [Tool showMessage:[dic objectForKey:@"desc"]];
            }
            
        }
        
    }];
    [task resume];
}

#pragma mark 键盘消失

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.userTF resignFirstResponder];
    [self.pwdTF resignFirstResponder];
}

#pragma mark - UITextField delegat

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField==self.userTF) {
        [self.userTF resignFirstResponder];
        [self.pwdTF becomeFirstResponder];
    }else{
        [self.pwdTF resignFirstResponder];
    }
    
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
