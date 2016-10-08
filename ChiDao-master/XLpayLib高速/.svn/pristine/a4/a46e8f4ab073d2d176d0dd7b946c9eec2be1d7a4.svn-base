//
//  GetPayPasswordViewController.m
//  HisunPay
//
//  Created by scofield on 14-11-7.
//  Copyright (c) 2014年 com.hisuntech. All rights reserved.
//

#import "GetPayPasswordViewController.h"
#import "payPasswordReslutViewController.h"
@interface GetPayPasswordViewController ()
{
    NSString *_newPassword;
}
@end

@implementation GetPayPasswordViewController

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
    self.title = @"重置支付密码";
    self.headerLabel.text = @"支付密码由6位数字组成!";
    
    self.password.placeholder = @"请输入六位支付密码";
    self.password.maxLength = 6;
    self.password.kbdRandom = YES;
    self.password.kbdType =  KeyboardTypePinNumber;
    
    self.passwordRepeat.placeholder = @"请确认支付密码";
    self.passwordRepeat.delegate = self;
    self.password.kbdRandom = YES;
    self.passwordRepeat.kbdType =  KeyboardTypePinNumber;
    self.passwordRepeat.maxLength = 6;
    [self.commitBtn addTarget:self action:@selector(submitBtn) forControlEvents:UIControlEventTouchUpInside];
}

/**
 *  限定输入长度不能大于16
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	if (self.password == textField) {
        if (range.location >= 16){
			return NO; // return NO to not change text
        }
	}
    if (self.passwordRepeat == textField) {
        if (range.location >= 16){
			return NO; // return NO to not change text
        }
	}
    return YES;
}



/**
 *  提交更改
 */
- (void)submitBtn
{
    if ([self.password getLength] == 0 ) {
        [self toastResult:@"请输入支付密码"];
        return;
    }
    if (([self.password getLength]>0)&&([self.password getLength]<6)) {
        [self toastResult:@"支付密码长度不能小于6位"];
        return;
    }
    if ([self.passwordRepeat getLength] == 0) {
        [self toastResult:@"请确认支付密码"];
        return;
    }
    if (([self.passwordRepeat getLength]>0)&&([self.passwordRepeat getLength]<6)) {
        [self toastResult:@"密码长度不能小于6位"];
        return;
    }
    if (![[self.passwordRepeat getMeasureValue] isEqual:[self.password getMeasureValue]]) {
        [self.passwordRepeat clear];
        [self.password clear];
        [self toastResult:@"两次输入密码不一致"];
        return;
    }
    [self getRandomKey];
}
#pragma mark -找回请求
-(void)findPayPasswordRequest
{
    NSDictionary *dict = [HisuntechBuildJsonString getResetPayPwdMsgJsonString:[HisuntechUserEntity Instance].userId userNo:[HisuntechUserEntity Instance].userNo question:[HisuntechUserEntity Instance].pwdQes answer:[HisuntechUserEntity Instance].pwdAns novPayPwd:_newPassword];
//    NSLog(@"请求参数 = %@",dict);
    [self requestServer:dict requestType:APP_CODE_ResetPayPwd successSel:@selector(success:) failureSel:@selector(failure:)];
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
    //获取随机因子
    if (codeType == 4) {
        if ([@"MCA00000" isEqual:[dictJson objectForKey:@"RSP_CD"] ] ) {
            //得到服务器时间之后，进行登录
            _newPassword = [self.passwordRepeat getValue:[NSString stringWithFormat:@"%@000",[dictJson objectForKey:@"SYSTM"]]];
            [self findPayPasswordRequest];
        }else{
            [self toastResult:[dictJson objectForKey:@"RSP_MSG"]];
        }
        return;
    }
}

/**
 *  重置支付密码成功返回
 *
 */
- (void)success:(id)response
{
    NSError *error;
    NSData * dataResponse = [NSJSONSerialization dataWithJSONObject:response options:NSJSONWritingPrettyPrinted error:&error];
    NSDictionary *dictJson = [NSJSONSerialization JSONObjectWithData:dataResponse options:NSJSONReadingMutableLeaves error:&error];
    
    if ([@"MCA00000" isEqual:[dictJson objectForKey:@"RSP_CD"]]) {
        payPasswordReslutViewController *reslut = [[payPasswordReslutViewController alloc] init];
        [self.navigationController pushViewController:reslut animated:YES];
    }else{
//        NSLog(@"错误 = %@",dictJson);
        [self toastResult:[dictJson objectForKey:@"RSP_MSG"]];
    }
}

- (void)failure:(id)sener
{
    [self toastResult:@"请检查网路"];
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
