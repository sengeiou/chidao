//
//  RegisterViewController.m
//  ChiDao
//
//  Created by 赵洋 on 16/7/12.
//  Copyright © 2016年 赵洋. All rights reserved.
//

#import "RegisterViewController.h"
#import "iProtect.h"
#import "JKCountDownButton.h"
@interface RegisterViewController ()<UITextFieldDelegate>
{
    JKCountDownButton *_countDownCode;
}
@property (nonatomic,strong) UITextField *userTF;
@property (nonatomic,strong) UITextField *verifyTF;
@property (nonatomic,strong) PasswordTextField *pwdTF;
@property (nonatomic,strong) PasswordTextField *pwdTF2;

@property (nonatomic,strong) UIButton *registerBtn;
@end

@implementation RegisterViewController
@synthesize registerBtn = _registerBtn;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"快速注册";
    self.view.backgroundColor = BackgroundColor;
    [self creatUI];
}
-(void)creatUI{
    //画线
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 20.0f, myScreenWidth, myLineHight1)];
    [iv setImage:[UIImage imageNamed:@"line.png"]];
    UIImageView *iv2 = [[UIImageView alloc] initWithFrame:CGRectMake(20.0f, 21.0f+50, myScreenWidth, myLineHight1)];
    [iv2 setImage:[UIImage imageNamed:@"line.png"]];
    UIImageView *iv3 = [[UIImageView alloc] initWithFrame:CGRectMake(20.0f, 22.0f+100, myScreenWidth, myLineHight1)];
    [iv3 setImage:[UIImage imageNamed:@"line.png"]];
    
    UIImageView *iv4 = [[UIImageView alloc] initWithFrame:CGRectMake(20.0f, 23.0f+150, myScreenWidth, myLineHight1)];
    [iv4 setImage:[UIImage imageNamed:@"line.png"]];
    
    UIImageView *iv5 = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 25.0f+200, myScreenWidth, myLineHight1)];
    [iv5 setImage:[UIImage imageNamed:@"line.png"]];
    
    [self.view addSubview:iv];
    [self.view addSubview:iv2];
    [self.view addSubview:iv3];
    [self.view addSubview:iv4];
    [self.view addSubview:iv5];
    
    //添加label   手机号  验证码  登录密码  确认密码
    UILabel *lb1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 21, 80, 50.0f)];
    lb1.text = @"手机号";
    [self.view addSubview:lb1];
    
    UILabel *lb2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 21+50, 80, 50.0f)];
    lb2.text = @"验证码";
    [self.view addSubview:lb2];
    
    UILabel *lb3 = [[UILabel alloc] initWithFrame:CGRectMake(20, 22.0f+100, 80, 50.0f)];
    lb3.text = @"登录密码";
    [self.view addSubview:lb3];
    
    UILabel *lb4 = [[UILabel alloc] initWithFrame:CGRectMake(20, 23.0f+150, 80, 50.0f)];
    lb4.text = @"确认密码";
    [self.view addSubview:lb4];
    
    // 添加输入框
    self.userTF = [[UITextField alloc] initWithFrame:CGRectMake(100.0f, 21, myScreenWidth-100, 50.0f)];
    [self.userTF setBackgroundColor:BackgroundColor];
    self.userTF.placeholder = @"请输入手机号";
    [self.userTF setBorderStyle:UITextBorderStyleNone];
    [self.userTF setTextAlignment:NSTextAlignmentLeft];
    self.userTF.leftViewMode = UITextFieldViewModeAlways;
    [self.userTF setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self.userTF setReturnKeyType:UIReturnKeyNext];
    [self.userTF setKeyboardType:UIKeyboardTypeDefault];
    self.userTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.userTF setDelegate:self];
    [self.view addSubview:self.userTF];
    
    self.verifyTF = [[UITextField alloc] initWithFrame:CGRectMake(100.0f, 22+50, myScreenWidth-100-80, 50.0f)];
    [self.verifyTF setBackgroundColor:BackgroundColor];
    self.verifyTF.placeholder = @"请输入验证码";
    [self.verifyTF setBorderStyle:UITextBorderStyleNone];
    [self.verifyTF setTextAlignment:NSTextAlignmentLeft];
    self.verifyTF.leftViewMode = UITextFieldViewModeAlways;
    [self.verifyTF setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self.verifyTF setReturnKeyType:UIReturnKeyNext];
    [self.verifyTF setKeyboardType:UIKeyboardTypeDefault];
    self.verifyTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.verifyTF setDelegate:self];
    [self.view addSubview:self.verifyTF];
    
    self.pwdTF = [[PasswordTextField alloc] initWithFrame:CGRectMake(100.0f, 23+100, myScreenWidth-100, 50.0f)];
    self.pwdTF.placeholder = @"请设置登录密码";
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
    self.pwdTF.kbdRandom = NO;
    //设置加密类型
    self.pwdTF.encryptType = E_SDHS_STANDARD;
    [self.view addSubview:self.pwdTF];
    
    
    self.pwdTF2 = [[PasswordTextField alloc] initWithFrame:CGRectMake(100.0f, 24+150, myScreenWidth-100, 50.0f)];
    self.pwdTF2.placeholder = @"请确认登录密码";
    [self.pwdTF2 setBackgroundColor:BackgroundColor];
    [self.pwdTF2 setBorderStyle:UITextBorderStyleNone];
    [self.pwdTF2 setTextAlignment:NSTextAlignmentLeft];
    self.pwdTF2.leftViewMode = UITextFieldViewModeAlways;
    self.pwdTF2.secureTextEntry = YES;
    [self.pwdTF2 setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self.pwdTF2 setReturnKeyType:UIReturnKeyDone];
    [self.pwdTF2 setKeyboardType:UIKeyboardTypeDefault];
    self.pwdTF2.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.pwdTF2 setDelegate:self];
    //设置键盘是否乱序
    self.pwdTF2.kbdRandom = NO;
    //设置加密类型
    self.pwdTF2.encryptType = E_SDHS_STANDARD;
    
    [self.view addSubview:self.pwdTF2];
    
    
    //注册btn
    self.registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _registerBtn.backgroundColor = btnColor;
    _registerBtn.layer.cornerRadius = myCornerRadius;
    _registerBtn.clipsToBounds = YES;
    [_registerBtn setTitle:@"注 册" forState:UIControlStateNormal];
    [_registerBtn addTarget:self action:@selector(registerClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_registerBtn];
    
    [_registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (self.pwdTF2.mas_bottom).offset (20);
        make.left.mas_equalTo (self.view.mas_left).offset (10);
        make.right.mas_equalTo (self.view.mas_right).offset (-10);
        make.height.mas_equalTo (44);
    }];
    
    _countDownCode = [JKCountDownButton buttonWithType:UIButtonTypeCustom];
    _countDownCode.frame = CGRectMake(myScreenWidth-85, 22+50+5, 80, 40);
    [_countDownCode setTitle:@"发送验证码" forState:UIControlStateNormal];
    _countDownCode.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    _countDownCode.layer.cornerRadius = myCornerRadius;
    _countDownCode.backgroundColor = btnColor;
    [self.view addSubview:_countDownCode];
    // 验证码倒计时
    [_countDownCode countDownButtonHandler:^(JKCountDownButton*sender, NSInteger tag) {
        sender.enabled = NO;
        [sender startCountDownWithSecond:60];
        [sender countDownChanging:^NSString *(JKCountDownButton *countDownButton,NSUInteger second) {
            NSString *title = [NSString stringWithFormat:@"重新发送(%zd)",second];
            return title;
        }];
        [sender countDownFinished:^NSString *(JKCountDownButton *countDownButton, NSUInteger second) {
            countDownButton.enabled = YES;
            return @"重新获取";
            
        }];
        
    }];
}
- (void)registerClick{
    
}

#pragma mark 键盘消失

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.userTF resignFirstResponder];
    [self.verifyTF resignFirstResponder];
    [self.pwdTF resignFirstResponder];
    [self.pwdTF2 resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
