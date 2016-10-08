//
//  RegisterViewController.m
//  HisunPay
//
//  Created by scofield on 14-11-3.
//  Copyright (c) 2014年 com.hisuntech. All rights reserved.
//

#import "HisuntechRegisterViewController.h"
#import "HisuntechRegisterVerifyViewController.h"
#import "HisuntechValidateCheck.h"
#import "HisuntechUIColor+YUColor.h"
#import "iProtect.h"
#import "PayProtocolViewController.h"
@interface HisuntechRegisterViewController ()<UITextFieldDelegate>
{
    BOOL BtnSelected;
    UIView *AlertView;
    UIView *AlertViewBgView;
}

@property (nonatomic,strong) UITextField *phoneNumber;
@property (nonatomic,strong) UIButton *choicebox;

@end

@implementation HisuntechRegisterViewController

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
    BtnSelected = YES;
    self.title = @"注册";
    [self setLeftItemToBack];
    self.view.backgroundColor = kColor(225, 235, 239, 1);
    
//    NSArray *labelTitleArr = @[@"  账号:",@"  登录密码:",@"",];
//    NSArray *textFieldArr = @[@"请输入手机号注册",@"8~16位数字、字母组成",@"确认登录密码",];
//    
//    for (int i = 0; i<3; i++) {
//        
//        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 84+i*50, [UIScreen mainScreen].bounds.size.width, 50)];
//        bgView.backgroundColor = [UIColor whiteColor];
//        [self.view addSubview:bgView];
//        
//        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, (84+49.5)+i*50, [UIScreen mainScreen].bounds.size.width, 0.5)];
//        lineView.backgroundColor = [UIColor grayColor];
//        [self.view addSubview:lineView];
//        
//        UILabel *reminderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
//        reminderLabel.center = CGPointMake(50, 109+i*50);
//        reminderLabel.text = labelTitleArr[i];
//        [self.view addSubview:reminderLabel];
//        
//        
//        if (i==0) {
//             self.phoneNumber = [[UITextField alloc] initWithFrame:CGRectMake(100, 84+i*50, [UIScreen mainScreen].bounds.size.width - 110, 50)];
//            self.phoneNumber.tag = 200 +i;
//            self.phoneNumber.placeholder = textFieldArr[i];
//            self.phoneNumber.clearButtonMode = UITextFieldViewModeWhileEditing;
//            [self.view addSubview:self.phoneNumber];
//        }else
//        {
//            UITextField *messageText = [[PasswordTextField alloc] initWithFrame:CGRectMake(100, 84+i*50, [UIScreen mainScreen].bounds.size.width - 110, 50)];
//            messageText.tag = 200 +i;
//            messageText.placeholder = textFieldArr[i];
//            messageText.clearButtonMode = UITextFieldViewModeWhileEditing;
//            [self.view addSubview:messageText];
//        }
//        
//        
//    }
//    
//    UIButton *protocolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    protocolBtn.frame = CGRectMake(10, 250, 20, 20);
//    protocolBtn.selected = YES;
//    [protocolBtn setImage:[UIImage imageWithContentsOfFile:ResourcePath(@"red packet_choicebox_ic_n")] forState:UIControlStateNormal];
//    [protocolBtn setImage:[UIImage imageWithContentsOfFile:ResourcePath(@"register_Login_Btn"]) forState:UIControlStateSelected];
//    [protocolBtn addTarget:self action:@selector(protocolBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:protocolBtn];
//    
//    
//    UILabel *ptotocolLable = [[UILabel alloc] initWithFrame:CGRectMake(40, 250, [UIScreen mainScreen].bounds.size.width - 50, 20)];
//    NSDictionary *dicOne = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#41b880" withAlpha:1],NSFontAttributeName:[UIFont systemFontOfSize:15]};
//    NSMutableAttributedString *attstring = [[NSMutableAttributedString alloc] initWithString:@"我已阅读并同意《信联支付协议》"];
//    ptotocolLable.font = [UIFont systemFontOfSize:15];
//    [attstring addAttributes:dicOne range:NSMakeRange(7, 8)];
//    ptotocolLable.attributedText = attstring;
//    [self.view addSubview:ptotocolLable];
//    
//     UIButton *FinishBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//     FinishBtn.frame = CGRectMake(10, ptotocolLable.frame.origin.y+ 40, [UIScreen mainScreen].bounds.size.width - 20, 40);
//     FinishBtn.layer.cornerRadius = 4;
//     FinishBtn.clipsToBounds = YES;
//     [FinishBtn addTarget:self action:@selector(finishBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//     [FinishBtn setBackgroundColor:[UIColor colorWithHexString:@"#41b880" withAlpha:1] ];
//     [FinishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//     FinishBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
//     [FinishBtn setTitle:@"完成" forState:UIControlStateNormal];
//     [self.view addSubview:FinishBtn];
    
     
     
     
     
     
    
    self.phoneNumber = [[UITextField alloc]initWithFrame:CGRectMake(0,64+18,screenWidth , 50)];
    self.phoneNumber.delegate = self;
    self.phoneNumber.placeholder = @"请输入手机号";
    self.phoneNumber.backgroundColor = [UIColor whiteColor];
    self.phoneNumber.clearButtonMode = YES;
    self.phoneNumber.leftViewMode = UITextFieldViewModeAlways;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 50)];
    self.phoneNumber.leftView = view;
    self.phoneNumber.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:self.phoneNumber];
    
    _choicebox = [UIButton buttonWithType:UIButtonTypeCustom];
    _choicebox.selected = YES;
    NSString * imagePath = ResourcePath(@"red packet_choicebox_ic_n.png");
    [_choicebox setImage:[UIImage imageWithContentsOfFile:imagePath] forState:UIControlStateNormal];
    imagePath = ResourcePath(@"register_Login_Btn.png");
    [_choicebox setImage:[UIImage imageWithContentsOfFile:imagePath] forState:UIControlStateSelected];
    [_choicebox addTarget:self action:@selector(choicedClicked:) forControlEvents:UIControlEventTouchUpInside];
    CGRect frame = self.phoneNumber.frame;
    frame.origin.x += 10;
    frame.origin.y += 50 + 18;
    frame.size.height = 17;
    frame.size.width = 17;
    _choicebox.frame = frame;
    [self.view addSubview:_choicebox];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(_choicebox.frame.origin.x + 17 + 5, frame.origin.y - 6 , 300, 30)];
    label.textColor = [UIColor grayColor];

    NSDictionary *dicOne = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#41b880" withAlpha:1]};
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:@"我已阅读并同意《信联支付协议》"];
    [attString addAttributes:dicOne range:NSMakeRange(7, 8)];
    label.attributedText = attString;
    label.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(registerLabelTap)];
    [label addGestureRecognizer:tap];
    label.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:label];
    
    UIButton *submit = [UIButton buttonWithType:UIButtonTypeCustom];
    [submit setTitle:@"获取验证码" forState:UIControlStateNormal];
    [submit.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    submit.layer.cornerRadius = 3;
    submit.clipsToBounds = YES;
    [submit setBackgroundColor:[UIColor colorWithHexString:@"#41b880" withAlpha:1]];
    [submit addTarget:self action:@selector(finishBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    frame = self.choicebox.frame;
    frame.origin.x = 10;
    frame.origin.y += 17 + 18 ;
    frame.size.height = 40;
    frame.size.width = 300;
    submit.frame = frame;
    [self.view addSubview:submit];
}

-(void)protocolBtnClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    
}



-(void)finishBtnClick:(UIButton *)btn
{
    
    [self.view endEditing:YES];
//    for(int i = 0 ;i<3;i++)
//    {
//        UITextField *messageText = (UITextField *)[self.view viewWithTag:200+i];
//        if(messageText.text.length==0 || messageText.text == nil)
//        {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"警告" message:@"请填写正确的信息!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alertView show];
//            return;
//        }
//    }
    
    
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
    if (BtnSelected == NO) {
        [self toastResult:@"请同意信联支付服务协议"];
        return;
    }
    
    if(AlertView)
    {
        [AlertView removeFromSuperview];
    }
    
    if(AlertViewBgView)
    {
        [AlertViewBgView removeFromSuperview];
    }
    
    //自定义警示框
    
    NSArray *btnTitleArr = @[@"取消",@"确认",];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        
        AlertViewBgView = [[UIView alloc] initWithFrame:self.view.bounds];
        AlertViewBgView.backgroundColor = [UIColor grayColor];
        AlertViewBgView.alpha = 0.6;
        [self.view addSubview:AlertViewBgView];
        
        
        AlertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 80, [UIScreen mainScreen].bounds.size.height/3)];
        AlertView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
        AlertView.backgroundColor = [UIColor whiteColor];
        AlertView.layer.cornerRadius = 4;
        AlertView.clipsToBounds = YES;
        [self.view addSubview:AlertView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, AlertView.bounds.size.width - 40, AlertView.bounds.size.height/3)];
        
        titleLabel.center  = CGPointMake(AlertView.bounds.size.width/2, AlertView.bounds.size.height/6);
        titleLabel.text = @"我们将发送验证码到这个手机号:";
        titleLabel.adjustsFontSizeToFitWidth = YES;
        titleLabel.font = [UIFont boldSystemFontOfSize:16];
        titleLabel.textColor = [UIColor grayColor];
        [AlertView addSubview:titleLabel];
        
        UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,  AlertView.bounds.size.width - 40, AlertView.bounds.size.height/3)];
        phoneLabel.textAlignment = NSTextAlignmentCenter;
        phoneLabel.center = CGPointMake(AlertView.bounds.size.width/2, (AlertView.bounds.size.height -40)/3+AlertView.bounds.size.width/6);
        phoneLabel.font = [UIFont boldSystemFontOfSize:16];
        phoneLabel.textColor = [UIColor colorWithHexString:@"#41b880" withAlpha:1];
        [AlertView addSubview:phoneLabel];
        phoneLabel.text = [NSString stringWithFormat:@"  +86  %@",self.phoneNumber.text];
        
        for(int j = 0;j<2;j++)
        {
            UIButton *choseBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            choseBtn.tag = 400+j;
            choseBtn.frame = CGRectMake(0, 0,AlertView.bounds.size.width/2*2/3, AlertView.bounds.size.height/6);
            choseBtn.backgroundColor = [UIColor colorWithHexString:@"#41b880" withAlpha:1];
            choseBtn.layer.cornerRadius = 3;
            choseBtn.clipsToBounds= YES;
            [choseBtn addTarget:self action:@selector(choseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [choseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            choseBtn.titleLabel.font =[UIFont boldSystemFontOfSize:16];
            choseBtn.center = CGPointMake(AlertView.bounds.size.width/4 +(j*AlertView.bounds.size.width/2) , AlertView.bounds.size.width/6 + (AlertView.bounds.size.height - 40) * 2/3);
            [choseBtn setTitle:btnTitleArr[j] forState:UIControlStateNormal];
            [AlertView addSubview:choseBtn];
        }
    }];
}
     
-(void)choseBtnClick:(UIButton *)btn
{
   [UIView animateWithDuration:0.3 animations:^{
       if(AlertViewBgView)
       {
           [AlertViewBgView removeFromSuperview];
       }
       if(AlertView)
       {
           [AlertView removeFromSuperview];
       }
   }];
    
    
    if(btn.tag == 401)
    {
        [self submitNumber];
    }
}
    

- (void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)choicedClicked:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (btn.selected) {
        BtnSelected = YES;
    }else
    {
        BtnSelected = NO;
    }
}

- (void)registerLabelTap
{
    PayProtocolViewController *pay = [[PayProtocolViewController alloc] init];
    pay.url = @"http://123.129.210.53:8680/hipos/service/cnct.xhtml";
    [self.navigationController pushViewController:pay animated:YES];
}

- (void)submitNumber
{
    
    
    if ([HisuntechUserEntity Instance].pubKey== nil||[HisuntechUserEntity Instance].pubKey.length == 0) {
        
        NSDictionary *pubKeyDict = [HisuntechBuildJsonString getPublicKeyJsonString];
        [self requestServer:pubKeyDict requestType:APP_CODE_PublicKey successSel:@selector(getPublicKeySucc:) failureSel:@selector(failure:)];
    }else{
        [self requesetSmsCode];
    }
    
}

/**请求服务器 发送短信验证码*/
- (void)requesetSmsCode
{
    NSDictionary *requestDict = [HisuntechBuildJsonString getSendPhoneCodeJsonString:self.phoneNumber.text userType:@"1"];
    [self requestServer:requestDict requestType:APP_CODE_SmsCode successSel:@selector(VerifyMessage:) failureSel:@selector(failure:)];
}

- (void)resquestSuccess:(id)response
{
    if (codeType == 3) {
        NSError *error;
        NSData * dataResponse = [NSJSONSerialization dataWithJSONObject:response options:NSJSONWritingPrettyPrinted error:&error];
        NSDictionary *dictJson = [NSJSONSerialization JSONObjectWithData:dataResponse options:NSJSONReadingMutableLeaves error:&error];
        
        if ([@"MCA00000" isEqual:[dictJson objectForKey:@"RSP_CD"] ] ) {
            HisuntechRegisterVerifyViewController *rvc = [[HisuntechRegisterVerifyViewController alloc]init];
            NSLog(@"%@",_phoneNumber.text);
            
            rvc.sendMessagePhone = self.phoneNumber.text;
            
            [self.navigationController pushViewController:rvc animated:YES];
        }else{
            [self toastResult:[dictJson objectForKey:@"RSP_MSG"]];
        }
    }
}

-(void)resquestFail:(id)response{
    [self toastResult:@"检查当前网络"];
}

- (void)textFieldShouldReturn
{
    [self.view endEditing:YES];
}


- (void)getPublicKeySucc:(id)response
{
    NSError *error;
    NSData * dataResponse = [NSJSONSerialization dataWithJSONObject:response options:NSJSONWritingPrettyPrinted error:&error];
    NSDictionary *dictJson = [NSJSONSerialization JSONObjectWithData:dataResponse options:NSJSONReadingMutableLeaves error:&error];
    if ([@"MCA00000" isEqual:[dictJson objectForKey:@"RSP_CD"] ] ) {
        [HisuntechUserEntity Instance].pubKey = [dictJson objectForKey:@"PUBKEY"];
        [self requesetSmsCode];
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
        HisuntechRegisterVerifyViewController *rvc = [[HisuntechRegisterVerifyViewController alloc]init];
         rvc.sendMessagePhone = self.phoneNumber.text;
        [self.navigationController pushViewController:rvc animated:YES];
    }else{
        [self toastResult:[dictJson objectForKey:@"RSP_MSG"]];
    }
}

- (void)failure:(NSError *)error
{
    [self toastResult:@"请检查您当前网络"];
}

- (void)dealloc
{
    [self.view endEditing:YES];
    self.phoneNumber = nil;
    
}

@end
