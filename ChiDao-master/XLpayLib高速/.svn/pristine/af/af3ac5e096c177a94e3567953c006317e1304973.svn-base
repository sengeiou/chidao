//
//  ForgetPasswordViewController.m
//  HisunPay
//
//  Created by scofield on 14-11-13.
//  Copyright (c) 2014年 com.hisuntech. All rights reserved.
//

#import "HisuntechForgetPasswordViewController.h"
#import "HisuntechNormalTextField.h"
#import "HisuntechValidateCheck.h"
#import "HisuntechForgetPasswordVerifyController.h"
#import "HisuntechUserEntity.h"
#import "HisuntechUIColor+YUColor.h"
@interface HisuntechForgetPasswordViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    //创建显示问题的table
    UITableView *_questionTable;
    //创建数据源数组
    NSMutableArray *_dataArr;
    //显示密保问题的label
    UILabel *_showLabel;
    //输入密保问题答案
    HisuntechNormalTextField *_inputText;
}

@end

@implementation HisuntechForgetPasswordViewController

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
    _dataArr = [NSMutableArray arrayWithCapacity:0];
    
    NSArray *arr = @[@" 我父亲的出生地" ,@" 我母亲的出生地",@" 我的出生地",@" 我的初中班主任",@" 小学学校名字",@" 高中死党名字"];
    
    for (int i = 0; i<arr.count; i++) {
        [_dataArr addObject:arr[i]];
    }
    
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = registerViewBackgroundColor;
    self.navigationController.navigationBarHidden = NO;
    self.title = @"重置登录密码";
    [self setLeftItemToBack];
    [self createUI];

}

-(void)createSecondUI
{
    UILabel *message = [[UILabel alloc]initWithFrame:CGRectMake(0, 64 + 5, screenWidth, 18)];
    message.font = registerLabelFont;
    message.textColor = registerLabelColor;
    message.text = @"    仅支持信联支付注册用户账户的手机号";
    [self.view addSubview:message];
    
    
    
    self.phoneNumber = [[HisuntechNormalTextField alloc]init];
    self.phoneNumber.frame = CGRectMake(0, message.frame.origin.y + message.frame.size.height + 5, [UIScreen mainScreen].bounds.size.width, 40);
    self.phoneNumber.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneNumber.placeholder = @"请输入手机号";
    [self.view addSubview:self.phoneNumber];
    self.phoneNumber.clearButtonMode = UITextFieldViewModeWhileEditing;
    UILabel *alertLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.phoneNumber.frame.origin.y + self.phoneNumber.frame.size.height + 10, screenWidth, 20)];
    alertLabel.text = @"请选择密保问题";
    alertLabel.userInteractionEnabled = YES;
    alertLabel.font = registerLabelFont;
    alertLabel.textColor = registerLabelColor;
    [self.view addSubview:alertLabel];
    
    //显示密保问题
    _showLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,alertLabel.frame.origin.y + alertLabel.frame.size.height + 10, screenWidth, 40)];
    _showLabel.userInteractionEnabled= YES;
    _showLabel.text = @" 我父亲的出生地";
    _showLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    _showLabel.layer.borderWidth = 1.5;
    _showLabel.textColor = [UIColor grayColor];
    _showLabel.font = [UIFont boldSystemFontOfSize:15];
    _showLabel.shadowColor = [UIColor blackColor];
    _showLabel.shadowOffset = CGSizeMake(0.5, 0.5);
    [self.view addSubview:_showLabel];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor cyanColor];
    [btn addTarget:self action:@selector(SecondChoseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, 0, 20, 20);
    btn.center = CGPointMake(alertLabel.frame.size.width - 30, 20);
    [_showLabel addSubview:btn];
    
    
    _questionTable = [[UITableView alloc] initWithFrame:CGRectMake(0, _showLabel.frame.origin.y + _showLabel.frame.size.height, screenWidth, 100)];
    _questionTable.hidden = YES;
    _questionTable.bounces = NO;
    _questionTable.backgroundColor = [UIColor yellowColor];
    _questionTable.delegate =self;
    _questionTable.dataSource = self;
    [self.view addSubview:_questionTable];
    [self.view bringSubviewToFront:_questionTable];
    
    //输入密保问题答案
    _inputText  = [[HisuntechNormalTextField alloc] initWithFrame:CGRectMake(0, _showLabel.frame.origin.y + _showLabel.frame.size.height + 10, screenWidth, 40)];
    _inputText.placeholder = @"请输入密保问题答案";
    _inputText.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:_inputText];
    
    //
    self.verifyCode = [[HisuntechNormalTextField alloc]init];
    self.verifyCode.frame = CGRectMake(0, _inputText.frame.origin.y + _inputText.frame.size.height + 10,[UIScreen mainScreen].bounds.size.width, 50);
    
    self.verifyCode.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.verifyCode.delegate = self;
    
    self.pooCode = [[HisuntechPooCodeView alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    
    self.verifyCode.rightViewMode = UITextFieldViewModeAlways;
    self.verifyCode.rightView = self.pooCode;
    self.verifyCode.delegate = self;
    
    self.verifyCode.placeholder = @"请输入右图中的校验码";
    [self.view addSubview:self.verifyCode];
    
    UIButton *submit = [UIButton buttonWithType:UIButtonTypeCustom];
    [submit setTitle:@"下一步" forState:UIControlStateNormal];
    [submit.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [submit setBackgroundColor:[UIColor colorWithHexString:@"#41b886" withAlpha:1]];
    submit.layer.cornerRadius = 3;
    submit.clipsToBounds = YES;
    [submit addTarget:self action:@selector(submitNumber) forControlEvents:UIControlEventTouchUpInside];
    submit.frame = CGRectMake(10,self.verifyCode.frame.origin.y + self.verifyCode.frame.size.height + 10, 300, 40);
    [self.view addSubview:submit];
    
    
    
    
}




- (void)createUI
{
   
    
    UILabel *message = [[UILabel alloc]initWithFrame:CGRectMake(0, 64 + 5, screenWidth, 18)];
    message.font = registerLabelFont;
    message.textColor = registerLabelColor;
    message.text = @"    仅支持信联支付注册用户账户的手机号";
    [self.view addSubview:message];
    
    
    
    self.phoneNumber = [[HisuntechNormalTextField alloc]init];
    self.phoneNumber.frame = CGRectMake(0, message.frame.origin.y + message.frame.size.height + 5, [UIScreen mainScreen].bounds.size.width, 50);
    self.phoneNumber.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.phoneNumber.keyboardType = UIKeyboardTypeNumberPad;
    
//    self.phoneNumber.text = [HisuntechUserEntity Instance].userId;
    self.phoneNumber.placeholder = @"请输入手机号";
    [self.view addSubview:self.phoneNumber];
    
    
    
//    HisuntechNormalTextField *idTextField = [[HisuntechNormalTextField alloc] initWithFrame:CGRectMake(0,self.phoneNumber.frame.origin.y + self.phoneNumber.frame.size.height + 10,[UIScreen mainScreen].bounds.size.width, 50)];
//    idTextField.tag = -10;
//    idTextField.placeholder = @"请输入身份证号";
//    [self.view addSubview:idTextField];
    
    self.verifyCode = [[HisuntechNormalTextField alloc]init];
    self.verifyCode.frame = CGRectMake(0, self.phoneNumber.frame.origin.y + self.phoneNumber.frame.size.height + 10,[UIScreen mainScreen].bounds.size.width, 50);
    self.verifyCode.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.verifyCode.delegate = self;
    
    self.pooCode = [[HisuntechPooCodeView alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
    self.verifyCode.rightViewMode = UITextFieldViewModeAlways;
    self.verifyCode.rightView = self.pooCode;
    self.verifyCode.delegate = self;
    self.verifyCode.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.verifyCode.placeholder = @"请输入右图中的校验码";
    [self.view addSubview:self.verifyCode];
    
    UIButton *submit = [UIButton buttonWithType:UIButtonTypeCustom];
    [submit setTitle:@"下一步" forState:UIControlStateNormal];
    [submit.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
//     NSString * imagePath = ResourcePath(@"login_btn_n.9.png");
//    [submit setBackgroundImage:[UIImage imageWithContentsOfFile:imagePath] forState:UIControlStateNormal];
    [submit setBackgroundColor:[UIColor colorWithHexString:@"#41b886" withAlpha:1]];
    submit.layer.cornerRadius = 3;
    submit.clipsToBounds = YES;
    [submit addTarget:self action:@selector(submitNumber) forControlEvents:UIControlEventTouchUpInside];
    submit.frame = CGRectMake(10, 280, 300, 40);
    [self.view addSubview:submit];

}

-(void)SecondChoseBtnClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (btn.selected) {
        _questionTable.hidden = NO;
        [self.view bringSubviewToFront:_questionTable];
    }else
    {
        _questionTable.hidden = YES;
        
    }
}


#pragma mark 问题tableView的代理

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"question"];
    if (cell == nil) {
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"question"];
    }
    
    cell.textLabel.text = _dataArr[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _showLabel.text = _dataArr[indexPath.row];
    _questionTable.hidden = YES;
}


- (void)submitNumber
{
    //校验手机号
	BOOL checkPhoneNumMsg = [[[HisuntechValidateCheck alloc]init] checkMdn:self.phoneNumber.text];
    if (self.phoneNumber.text == nil||[@"" isEqual:self.phoneNumber.text]) {
        [self toastResult:@"请输入手机号"];
        return;
    }
    if (checkPhoneNumMsg == NO){
        [self toastResult:@"手机号输入有误"];
        return;
    }
    if (![[self.verifyCode.text lowercaseString] isEqualToString:[self.pooCode.changeString lowercaseString]]) {
        [self shake];
        
        UIAlertView *codeAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"验证码输入错误" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        codeAlert.tag = -500;
        [codeAlert show];
        
        return;
    }
    
    
  // 发短信验证码
    [self requesetSmsCode];
}

/**请求服务器 发送短信验证码*/
- (void)requesetSmsCode
{
    NSDictionary *requestDict = [HisuntechBuildJsonString getSendPhoneCodeJsonString:self.phoneNumber.text userType:@"2"];
    [self requestServer:requestDict requestType:APP_CODE_SmsCode successSel:@selector(VerifyMessage:) failureSel:@selector(failure:)];
}

- (void)failure:(id)error
{
    [self toastResult:@"请检查网路"];
}

//提交号码成功返回验证码时调用
- (void)VerifyMessage:(id)response
{
    NSError *error;
    NSData * dataResponse = [NSJSONSerialization dataWithJSONObject:response options:NSJSONWritingPrettyPrinted error:&error];
    NSDictionary *dictJson = [NSJSONSerialization JSONObjectWithData:dataResponse options:NSJSONReadingMutableLeaves error:&error];
    
    if ([@"MCA00000" isEqual:[dictJson objectForKey:@"RSP_CD"] ] ) {
        
        HisuntechForgetPasswordVerifyController *captcha = [[HisuntechForgetPasswordVerifyController alloc]init];
        captcha.phoneNumber = self.phoneNumber;
        
        [self.navigationController pushViewController:captcha animated:YES];
        
    }else{
        [self toastResult:[dictJson objectForKey:@"RSP_MSG"]];
    }
}

- (void)shake
{
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    anim.repeatCount = 1;
    anim.values = @[@-20, @20, @-20];
    [self.pooCode.layer addAnimation:anim forKey:nil];
    [self.verifyCode.layer addAnimation:anim forKey:nil];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.verifyCode.text isEqualToString:self.pooCode.changeString]) {
        [self.verifyCode resignFirstResponder];
        [self submitNumber];
    }
    else
    {
        [self shake];
    }
    return YES;
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
//{
//    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
//    if (self.verifyCode)
//    {
//        if ([toBeString length] >= 4) {
////            self.verifyCode.text = [toBeString substringToIndex:4];
//            return NO;
//        }
//    }
//    return YES;
//}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
{
    if ([textField isEqual:self.verifyCode]) {
        if (range.location>=4)
            return NO;
    }
  }
  return YES;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == -500) {
        self.verifyCode.text = @"";
    }
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _questionTable.hidden = YES;
}

@end
