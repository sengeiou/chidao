//
//  AddDebitCardController.m
//  Demo_1
//
//  Created by allen on 14-9-23.
//  Copyright (c) 2014年 itazk. All rights reserved.
//


#import "HisuntechAddDebitCardController.h"
#import "HisuntechValidateCheck.h"
#import "HisunTechTools.h"
#import "HisuntechMixPayViewController.h"
#import "HisuntechAFNetworking.h"
#import "HisuntechBgView.h"
#import "HisuntechBankController.h"
#import "HisuntechUserEntity.h"
@interface HisuntechAddDebitCardController ()<BankDelegate>

@end

@implementation HisuntechAddDebitCardController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
        self.title = @"添加借记卡";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:235/255.0 green:241/255.0 blue:245/255.0 alpha:1];
    [self createUI];
    NSString *path = ResourcePath(@"back_btn_n.png");
    UIBarButtonItem *navLeftBtn = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageWithContentsOfFile:path] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]style:UIBarButtonItemStylePlain target:self action:@selector(completeBack)];
    
    self.navigationItem.leftBarButtonItem = navLeftBtn;
}

-(void)completeBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createUI
{
    UILabel *infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 76-64, 261, 21)];
    infoLabel.font = [UIFont systemFontOfSize:13.0];
    infoLabel.text = @"请添加一张您自己名下的借记卡";
    infoLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:infoLabel];
    
    //发卡行
    HisuntechBgView *nameBg = [[HisuntechBgView alloc]initWithFrame:CGRectMake(0, 105-64, [UIScreen mainScreen].bounds.size.width, 40)];
    [self.view addSubview:nameBg];
    _bankName = [[UILabel alloc]initWithFrame:CGRectMake(20, 105-64, 280, 40)];
    _bankName.text = @"发卡行";
    _bankName.font = [UIFont systemFontOfSize:15];
    _bankName.textColor = [UIColor blackColor];
    [self.view addSubview:_bankName];
    //选择发卡行
    _goToBank = [UIButton buttonWithType:UIButtonTypeSystem];
    _goToBank.frame =CGRectMake(20, 105-64, 280, 40);
    [self.view addSubview:_goToBank];
    [_goToBank addTarget:self action:@selector(selectBankNo) forControlEvents:UIControlEventTouchUpInside];
    
    _selectBankBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectBankBtn.frame = CGRectMake(288, 109-53, 10, 15);
    [_selectBankBtn addTarget:self action:@selector(selectBankNo) forControlEvents:UIControlEventTouchUpInside];
    NSString *path = ResourcePath(@"pull_right_btn.png");
    [_selectBankBtn setImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateNormal];
    [self.view addSubview:_selectBankBtn];
    //借记卡卡号
    HisuntechBgView *cardNoBg = [[HisuntechBgView alloc]initWithFrame:CGRectMake(0, 91, [UIScreen mainScreen].bounds.size.width, 40)];
    [self.view addSubview:cardNoBg];
    
    _cardNo = [[UITextField alloc]initWithFrame:CGRectMake(20, 91, 280, 40)];
    _cardNo.borderStyle = UITextBorderStyleNone;
    _cardNo.placeholder = @"借记卡卡号";
    _cardNo.keyboardType = UIKeyboardTypeNumberPad;
    _cardNo.font = [UIFont systemFontOfSize:15];
    _cardNo.textColor = [UIColor lightGrayColor];
    [self.view addSubview:_cardNo];
    //持卡人姓名
    HisuntechBgView *cnameBg = [[HisuntechBgView alloc]initWithFrame:CGRectMake(0, 131, [UIScreen mainScreen].bounds.size.width, 40)];
    [self.view addSubview:cnameBg];

    _name = [[UITextField alloc]initWithFrame:CGRectMake(20, 131, 280, 40)];
    _name.borderStyle = UITextBorderStyleNone;
    _name.placeholder = @"持卡人姓名";
    _name.font = [UIFont systemFontOfSize:15];
    _name.textColor = [UIColor lightGrayColor];
    [self.view addSubview:_name];
    //持卡人身份证号
    HisuntechBgView *IDNumBg = [[HisuntechBgView alloc]initWithFrame:CGRectMake(0, 171, [UIScreen mainScreen].bounds.size.width, 40)];
    [self.view addSubview:IDNumBg];

    _IDNum = [[UITextField alloc]initWithFrame:CGRectMake(20,171, 280, 40)];
    _IDNum.borderStyle = UITextBorderStyleNone;
    _IDNum.placeholder = @"持卡人身份证号";
    _IDNum.font = [UIFont systemFontOfSize:15];
    _IDNum.textColor = [UIColor lightGrayColor];
    [self.view addSubview:_IDNum];
    //持卡人手机号
    HisuntechBgView *phoneBg = [[HisuntechBgView alloc]initWithFrame:CGRectMake(0, 211, [UIScreen mainScreen].bounds.size.width, 40)];
    [self.view addSubview:phoneBg];

    _phoneNum = [[UITextField alloc]initWithFrame:CGRectMake(20, 211, 280, 40)];
    _phoneNum.borderStyle = UITextBorderStyleNone;
    _phoneNum.placeholder = @"持卡人手机号";
    _phoneNum.keyboardType = UIKeyboardTypeNumberPad;
    _phoneNum.font = [UIFont systemFontOfSize:15];
    _phoneNum.textColor = [UIColor lightGrayColor];
    [self.view addSubview:_phoneNum];
    //短信验证码
    HisuntechBgView *SMSBg = [[HisuntechBgView alloc]initWithFrame:CGRectMake(0, 261, [UIScreen mainScreen].bounds.size.width, 40)];
    [self.view addSubview:SMSBg];

    _SMSNum = [[UITextField alloc]initWithFrame:CGRectMake(20, 261, 169, 40)];
    _SMSNum.placeholder = @"短信验证码";
    _SMSNum.font = [UIFont systemFontOfSize:15];
    _SMSNum.borderStyle = UITextBorderStyleNone;
    _SMSNum.textColor = [UIColor lightGrayColor];
    _SMSNum.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_SMSNum];
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    sendBtn.frame = CGRectMake(196, 263, 124, 40);
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [sendBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(checkTelNum) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendBtn];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(196, 262, 1, 40)];
    line.backgroundColor =[UIColor colorWithRed:0.769 green:0.779 blue:0.787 alpha:1.000];
    [self.view addSubview:line];
    
    UIButton *add = [UIButton buttonWithType:UIButtonTypeCustom];
    add.frame = CGRectMake(20, 341, 280, 36);
    path = ResourcePath(@"login_btn_n.9.png");
    [add setBackgroundImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateNormal];
    [add setTitle:@"添加借记卡" forState:UIControlStateNormal];
    [add addTarget:self action:@selector(addDebitCard) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:add];
}
- (void)addDebitCard{
    HisuntechValidateCheck *validate = [[HisuntechValidateCheck alloc]init];
    //校验手机号
	BOOL checkPhoneNumMsg = [validate checkMdn:_phoneNum.text];
    //校验身份证号
    BOOL checkIDnum = [validate validateIDCardNumber:_IDNum.text];
    //校验银行卡号
//    BOOL checkCardNo = [validate checkBankCardNum:_cardNo.text];
    if (_bankName.text == nil||[@"" isEqual:_bankName.text]) {
        [self toastResult:@"请选择开户行"];
        return;
    }
    if (_cardNo.text == nil ||[@"" isEqual:_cardNo.text]) {
        [self toastResult:@"请输入银行卡号"];
        return;
    }
//    if (checkCardNo == NO) {
//        [self toastResult:@"请输入正确银行卡号"];
//        return;
//    }
    if (_name.text == nil ||[@"" isEqual:_name.text]) {
        [self toastResult:@"请输入持卡人姓名"];
        return;
    }
    if (_IDNum.text == nil ||[@"" isEqual:_IDNum.text]) {
        [self toastResult:@"请输入持卡人身份证号"];
        return;
    }
    if (checkIDnum == YES) {
        [self toastResult:@"请输入正确的身份证号"];
        return;
    }
    if (_phoneNum.text == nil ||[@"" isEqual:_phoneNum.text]) {
        [self toastResult:@"请输入手机号"];
        return;
    }
    if (checkPhoneNumMsg == NO){
        [self toastResult:@"输入手机号有误"];
        return;
    }
    if (_SMSNum.text == nil ||[@"" isEqual:_SMSNum.text]) {
        [self toastResult:@"请输入短信验证码"];
        return;
    }
    
    NSDictionary *requestDict = [HisuntechBuildJsonString addBankCardWithUserNO:[HisuntechUserEntity Instance].userNo bankNo:[HisuntechUserEntity Instance].bankNo bankcardNo:self.cardNo.text bnkPhone:self.phoneNum.text cardType:@"0" chkNO:self.SMSNum.text cardHolderName:self.name.text IDnum:self.IDNum.text userType:@"3" crdexpDt:@""
                                                                  cvn2:@""];
    [self requestServer:requestDict requestType:APP_CODE_ADDBankCard codeType:18];
    
}
- (void)checkTelNum{
    if (_phoneNum.text == nil ||[@"" isEqual:_phoneNum.text]) {
        [self toastResult:@"请输入手机号"];
        return;
    }
    HisuntechValidateCheck *validateCheck = [[HisuntechValidateCheck alloc]init];
	BOOL msg = [validateCheck checkMdn:_phoneNum.text];
    if (msg==NO){
        [self toastResult:@"输入手机号有误"];
        return;
    }
    //请求参数
    NSDictionary *requestDict = [HisuntechBuildJsonString getSendPhoneCodeJsonString:_phoneNum.text userType:@"3"];
//    NSLog(@"requestDict = %@",requestDict);
    // 请求服务器 发送短信验证码
    [self requestServer:requestDict requestType:APP_CODE_SmsCode codeType:2];
}
/**
 *  dialog提示框
 *
 *  @param toastMsg 提示内容
 */
-(void)toastResult:(NSString *) toastMsg{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:toastMsg message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}
/**
 *  请求服务器成功
 */
-(void)resquestSuccess:(id)response{
    //NSLog(@" %@ resquestSuccess  JSON: %@", [self class],[response description]);
    
    NSError *error;
    NSData * dataResponse = [NSJSONSerialization dataWithJSONObject:response options:NSJSONWritingPrettyPrinted error:&error];
    NSDictionary *dictJson = [NSJSONSerialization JSONObjectWithData:dataResponse options:NSJSONReadingMutableLeaves error:&error];

    if (codeType==2) {
        /**
         *  MCAOOOOO表示请求成功
         */
        if ([@"MCA00000" isEqual:[dictJson objectForKey:@"RSP_CD"] ] ) {
            [self toastResult:@"短信已发送，请尽快输入"];
        }else{
            [self toastResult:[dictJson objectForKey:@"RSP_MSG"]];
        }
        return;
    }
    if (codeType==18) {
        /**
         *  MCAOOOOO表示请求成功
         */
//        NSLog(@"【绑卡%@",dictJson);
        if ([@"MCA00000" isEqual:[dictJson objectForKey:@"RSP_CD"] ] ) {
            //跳转到主页支付平台 传值
//           [self.delegate passValue:@{@"BNKNO":mBnkNo,//银行简称
//                                     @"BNKCRDNO":_cardNo.text,//银行卡号
//                                        @"BNKPHONE": _phoneNum.text,//银行预留手机号
//                                        @"CRDTYP": @"1",//绑定类型
//                                        @"SMSCD": _SMSNum.text,//短信验证码
//                                        @"CRDHOLDERNM": _name.text,//持卡人姓名
//                                        @"ID_NO": _IDNum.text}];//身份证号
            [self.delegate passValue:nil];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            [self toastResult:[dictJson objectForKey:@"RSP_MSG"] ];
        }        return;
    }
}
/**
 *  请求服务器失败
 */
-(void)resquestFail:(id)response{
    if (codeType==2||codeType==3) {
        [self toastResult:@"请检查您当前网络"];
        return;
    }
}

- (void)selectBankNo
{
    HisuntechBankController *bank = [[HisuntechBankController alloc]init];
    bank.delegate = self;
    [self.navigationController pushViewController:bank animated:YES];
}
/**
 *  代理传值使用
 */
- (void)passValue1:(NSDictionary *)bankDic
{
    self.bankName.text = [bankDic objectForKey:[HisuntechUserEntity Instance].bankNo];
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
