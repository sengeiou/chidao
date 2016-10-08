//
//  resetPasswordController.m
//  HisunPay
//
//  Created by 王鑫 on 14-11-3.
//  Copyright (c) 2014年 com.hisuntech. All rights reserved.
//

#import "resetPasswordController.h"

@interface resetPasswordController ()<UITextFieldDelegate>
{
    NSString *_oldPassword;
    NSString *_newPassword;
}

@end

@implementation resetPasswordController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"重置支付密码";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:225/255.0 green:235/255.0 blue:239/255.0 alpha:1];
    
    [self setLeftItemToBack];
    
    [self createUI];
}
-(void)createUI
{
    UILabel *headerLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 10 + 64, 300, 30)];
    headerLab.text = @"登录密码由8-16位英文字母、数字组成";
    headerLab.textColor = [UIColor lightGrayColor];
    headerLab.font =[UIFont systemFontOfSize:13];
    [self.view addSubview:headerLab];
    self.headerLabel = headerLab;
    
    UIView *passwordView = [[UIView alloc]initWithFrame:CGRectMake(0, 50 + 64, [UIScreen mainScreen].bounds.size.width, 50)];
    passwordView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:passwordView];
    
    self.password = [[PasswordTextField alloc]initWithFrame:CGRectMake(10, 0, 300, 50)usingPasswordKeyboard:YES];
    self.password.placeholder = @"请输入登录密码";
    self.password.encryptionPlatformPublicKey = [HisuntechUserEntity Instance].pubKey;
//    self.password.kbdRandom = YES;
    
    self.password.encryptType = E_SDHS_DUAL_PLATFORM;
    [passwordView addSubview:self.password];
    
    UIView *resetView = [[UIView alloc]initWithFrame:CGRectMake(0, 120 + 64, [UIScreen mainScreen].bounds.size.width, 50)];
    resetView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:resetView];
    
    self.passwordRepeat = [[PasswordTextField alloc]initWithFrame:CGRectMake(10, 0, 300, 50)];
    self.passwordRepeat.placeholder = @"请确认登录密码";
    self.passwordRepeat.encryptionPlatformPublicKey = [HisuntechUserEntity Instance].pubKey;
    self.passwordRepeat.kbdRandom = YES;
    self.passwordRepeat.encryptType = E_SDHS_DUAL_PLATFORM;
    [resetView addSubview:self.passwordRepeat];
    
    self.commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.commitBtn.frame = CGRectMake(20, 220 + 64, 280, 36);
    self.commitBtn.layer.cornerRadius = 5;
    self.commitBtn.clipsToBounds = YES;
    [self.commitBtn setBackgroundColor:[UIColor colorWithRed:37/255.0 green:183/255.0 blue:148/255.0 alpha:1]];
    [self.commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [self.view addSubview:self.commitBtn];
    
    UIButton *button = self.commitBtn;
//    [button addTarget:self action:@selector(submitLoginPasswordBack) forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma mark -获取随机因子
-(void) getRandomKey{
    
    //上行参数
    NSDictionary *requestDict = [HisuntechBuildJsonString getRandomKeyJsonString];
    //请求服务器 获取公钥
    [self requestServer:requestDict requestType:APP_CODE_RandomKey codeType:4];
}
- (void)submitLoginPasswordBack
{
    
//    if (self.passwordType == ChangePassTypeLogin) {
        if ([self.password getLength] == 0 ) {
            [self toastResult:@"请输入登录密码"];
            return;
        }
    
        if (([self.password getLength]>0)&&([self.password getLength]<6)) {
            [self toastResult:@"登录密码长度不能小于6位"];
            return;
        }
        if ([self.passwordRepeat getLength] == 0) {
            [self toastResult:@"请输入登录密码"];
            return;
        }
        if (([self.passwordRepeat getLength]>0)&&([self.passwordRepeat getLength]<6)) {
            [self toastResult:@"密码长度不能小于6位"];
            return;
        }
        if ([[self.passwordRepeat getMeasureValue] isEqual:[self.password getMeasureValue]]) {
            [self toastResult:@"两次输入密码一样"];
            return;
        }
        [self getRandomKey];
//    }
}
#pragma mark -请求服务器成功
-(void)resquestSuccess:(id)response{
    NSError *error;
    NSData * dataResponse = [NSJSONSerialization dataWithJSONObject:response options:NSJSONWritingPrettyPrinted error:&error];
    NSDictionary *dictJson = [NSJSONSerialization JSONObjectWithData:dataResponse options:NSJSONReadingMutableLeaves error:&error];
    //获取随机因子
    if (codeType == 4) {
        if ([@"MCA00000" isEqual:[dictJson objectForKey:@"RSP_CD"] ] ) {
            //得到服务器时间之后，进行登录
            _oldPassword = [self.password getValue:[NSString stringWithFormat:@"%@000",[dictJson objectForKey:@"SYSTM"]]];
            _newPassword = [self.passwordRepeat getValue:[NSString stringWithFormat:@"%@000",[dictJson objectForKey:@"SYSTM"]]];

//            [self updatePasswordRequest];
        }else{
            [self toastResult:[dictJson objectForKey:@"RSP_MSG"]];
        }
        return;
    }

}
- (void)updatePasswordRequest
{
//    NSDictionary *para = [HisuntechBuildJsonString getUpdateLoginPwdMsgJsonString:[HisuntechUserEntity Instance].userId userNo:[HisuntechUserEntity Instance].userNo regEmail:@"" oldLoginPwd:_oldPassword novLoginPwd:_newPassword];
//    [self requestServer:para requestType:APP_CODE_UpdateLoginPwd successSel:@selector(updateLoginPwdBack:) failureSel:@selector(failure:)];

}
- (void)updateLoginPwdBack:(id)response
{
    NSError *error;
    NSData * dataResponse = [NSJSONSerialization dataWithJSONObject:response options:NSJSONWritingPrettyPrinted error:&error];
    NSDictionary *dictJson = [NSJSONSerialization JSONObjectWithData:dataResponse options:NSJSONReadingMutableLeaves error:&error];
    
    if ([@"MCA00000" isEqual:[dictJson objectForKey:@"RSP_CD"]]) {
        [self toastResult:@"重置密码成功"];
    }else{
        [self toastResult:[dictJson objectForKey:@"RSP_MSG"]];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.title isEqualToString:@"重置密码成功"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}





/**
 *  请求服务器失败
 */
-(void)resquestFail:(id)response{
    if (codeType==4) {
        [self toastResult:@"请检查您当前网络"];
        return;
    }
}
- (void)failure:(NSError *)error
{
    [self toastResult:@"请检查网路"];
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
