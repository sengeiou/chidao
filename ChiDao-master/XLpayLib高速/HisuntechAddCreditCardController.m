//
//  AddCreditCardController.m
//  Demo_1
//
//  Created by allen on 14-9-23.
//  Copyright (c) 2014年 itazk. All rights reserved.
//

#import "HisuntechAddCreditCardController.h"
#import "HisuntechMixPayViewController.h"
#import "HisuntechAFNetworking.h"
#import "HisuntechLoadingView.h"
#import "HisuntechValidateCheck.h"
#import "HisunTechTools.h"
#import "HisuntechBgView.h"
#import "HisuntechBankController.h"
#import "HisuntechUserEntity.h"

@interface HisuntechAddCreditCardController ()<BankDelegate>

@end

@implementation HisuntechAddCreditCardController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

      
        self.title = @"添加信用卡";  //设置标题
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
    //信用卡行
    HisuntechBgView *nameView = [[HisuntechBgView alloc]initWithFrame:CGRectMake(0, 77-64, [UIScreen mainScreen].bounds.size.width, 40)];
    [self.view addSubview:nameView];
    _bankName = [[UILabel alloc]initWithFrame:CGRectMake(20, 77-64, 280, 40)];
    _bankName.font = [UIFont systemFontOfSize:15];
    _bankName.text = @"发卡行";
    _bankName.textColor = [UIColor blackColor];
    [self.view addSubview:_bankName];
    
    //选择银行
    _goToBank = [UIButton buttonWithType:UIButtonTypeSystem];
    _goToBank.frame =CGRectMake(20, 77-64, 280, 40);
    [self.view addSubview:_goToBank];
    [_goToBank addTarget:self action:@selector(selectBankNo:) forControlEvents:UIControlEventTouchUpInside];
    
    _selectBankBt = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectBankBt.frame = CGRectMake(282, 25, 8, 15);
    NSString *path = ResourcePath(@"pull_right_btn.png");
    [_selectBankBt setImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateNormal];
    [_selectBankBt addTarget:self action:@selector(selectBankNo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_selectBankBt];
    //信用卡号
    HisuntechBgView *cardNoView = [[HisuntechBgView alloc]initWithFrame:CGRectMake(0, 63, [UIScreen mainScreen].bounds.size.width, 40)];
    [self.view addSubview:cardNoView];
    _cardNo = [[UITextField alloc]initWithFrame:CGRectMake(20, 63, 280, 40)];
    _cardNo.borderStyle = UITextBorderStyleNone;
    _cardNo.font = [UIFont systemFontOfSize:15];
    _cardNo.placeholder = @"信用卡卡号";
    _cardNo.keyboardType = UIKeyboardTypeNumberPad;
    _cardNo.textColor = [UIColor lightGrayColor];
    [self.view addSubview:_cardNo];
    //持卡人姓名
    HisuntechBgView *cnameView = [[HisuntechBgView alloc]initWithFrame:CGRectMake(0, 103, [UIScreen mainScreen].bounds.size.width, 40)];
    [self.view addSubview:cnameView];
    _name = [[UITextField alloc]initWithFrame:CGRectMake(20, 103, 280, 40)];
    _name.borderStyle = UITextBorderStyleNone;
    _name.font = [UIFont systemFontOfSize:15];
    _name.placeholder = @"持卡人姓名";
    _name.textColor = [UIColor lightGrayColor];
    [self.view addSubview:_name];
    //持卡人身份证号
    HisuntechBgView *IDnumView = [[HisuntechBgView alloc]initWithFrame:CGRectMake(0, 143, [UIScreen mainScreen].bounds.size.width, 40)];
    [self.view addSubview:IDnumView];
    _IDnum = [[UITextField alloc]initWithFrame:CGRectMake(20,143, 280, 40)];
    _IDnum.borderStyle = UITextBorderStyleNone;
    _IDnum.font = [UIFont systemFontOfSize:15];
    _IDnum.placeholder = @"持卡人身份证号";
    _IDnum.textColor = [UIColor lightGrayColor];
    [self.view addSubview:_IDnum];
    //有效期
    HisuntechBgView *dateView = [[HisuntechBgView alloc]initWithFrame:CGRectMake(0, 183, [UIScreen mainScreen].bounds.size.width, 40)];
    [self.view addSubview:dateView];

    _date = [[UITextField alloc]initWithFrame:CGRectMake(20, 183, 280, 40)];
    _date.borderStyle = UITextBorderStyleNone;
    _date.font = [UIFont systemFontOfSize:15];
    _date.placeholder = @"有效期";
    _date.keyboardType = UIKeyboardTypeNumberPad;
    _date.textColor = [UIColor lightGrayColor];
    [self.view addSubview:_date];
    //CVN2
    HisuntechBgView *cvn2View = [[HisuntechBgView alloc]initWithFrame:CGRectMake(0, 223, [UIScreen mainScreen].bounds.size.width, 40)];
    [self.view addSubview:cvn2View];
    _cvn2 = [[UITextField alloc]initWithFrame:CGRectMake(20, 223, 280, 40)];
    _cvn2.borderStyle = UITextBorderStyleNone;
    _cvn2.font = [UIFont systemFontOfSize:15];
    _cvn2.keyboardType = UIKeyboardTypeNumberPad;
    _cvn2.placeholder = @"CVN2";
    _cvn2.textColor = [UIColor lightGrayColor];
    [self.view addSubview:_cvn2];
    //持卡人手机号
    HisuntechBgView *phoneView = [[HisuntechBgView alloc]initWithFrame:CGRectMake(0, 263, [UIScreen mainScreen].bounds.size.width, 40)];
    [self.view addSubview:phoneView];

    _phoneNum = [[UITextField alloc]initWithFrame:CGRectMake(20,263, 280, 40)];
    _phoneNum.borderStyle = UITextBorderStyleNone;
    _phoneNum.font = [UIFont systemFontOfSize:15];
    _phoneNum.placeholder = @"持卡人手机号";
    _phoneNum.textColor = [UIColor lightGrayColor];
    _phoneNum.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_phoneNum];
    
    HisuntechBgView *smsView = [[HisuntechBgView alloc]initWithFrame:CGRectMake(0, 303, [UIScreen mainScreen].bounds.size.width, 40)];
    [self.view addSubview:smsView];
    _SMSNum = [[UITextField alloc]initWithFrame:CGRectMake(19, 303, 169, 40)];
    _SMSNum.keyboardType = UIKeyboardTypeNumberPad;
    _SMSNum.font = [UIFont systemFontOfSize:15];
    _SMSNum.borderStyle = UITextBorderStyleNone;
    _SMSNum.placeholder = @"短信验证码";
    [self.view addSubview:_SMSNum];
    
    UIButton *send = [UIButton buttonWithType:UIButtonTypeSystem];
    send.frame = CGRectMake(196, 303, 124, 40);
    [send setTitle:@"发送验证码" forState:UIControlStateNormal];
    send.titleLabel.font = [UIFont systemFontOfSize:14];
    [send addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:send];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(196, 303, 1, 40)];
    line.backgroundColor =[UIColor colorWithRed:0.769 green:0.779 blue:0.787 alpha:1.000];
    [self.view addSubview:line];
    
    UIButton *addCredit = [UIButton buttonWithType:UIButtonTypeCustom];
    addCredit.frame = CGRectMake(20, 363, 280, 40);
    [addCredit setTitle:@"添加信用卡"forState:UIControlStateNormal];
    path = ResourcePath(@"login_btn_n.9.png");
    [addCredit setBackgroundImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateNormal];
    [addCredit addTarget:self action:@selector(addCreditCard) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addCredit];
    
}
- (void)addCreditCard{
    HisuntechValidateCheck *validate = [[HisuntechValidateCheck alloc]init];
    //校验手机号码
    BOOL checkPhoneNumMsg = [validate checkMdn:_phoneNum.text];
    //校验身份证号
    BOOL checkIDNum = [validate validateIDCardNumber:_IDnum.text];
    //校验银行卡号
    //BOOL checkCardNo = [validate checkBankCardNum:_cardNo.text];
    if (_bankName.text == nil||[@"" isEqual:_bankName.text]) {
        [self toastResult:@"请选择开户行"];
        return;
    }
    if (_cardNo.text == nil ||[@"" isEqual:_cardNo.text]) {
        [self toastResult:@"请输入银行卡号"];
        return;
    }
    if (_name.text == nil ||[@"" isEqual:_name.text]) {
        [self toastResult:@"请输入持卡人姓名"];
        return;
    }
    if (_IDnum.text == nil ||[@"" isEqual:_IDnum.text]) {
        [self toastResult:@"请输入持卡人身份证号"];
        return;
    }
    if (checkIDNum == NO) {
        [self toastResult:@"请输入正确的身份证号"];
        return;
    }
    if (_date.text == nil ||[@"" isEqual:_date.text]) {
        [self toastResult:@"请输入有效期"];
        return;
    }
    if (_cvn2.text == nil ||[@"" isEqual:_cvn2.text]) {
        [self toastResult:@"请输入CVN2"];
        return;
    }
    if (_phoneNum.text == nil ||[@"" isEqual:_phoneNum.text]) {
        [self toastResult:@"请输入手机号"];
        return;
    }
    if (checkPhoneNumMsg==NO){
        [self toastResult:@"输入手机号有误"];
        return;
    }
    if (_SMSNum.text == nil ||[@"" isEqual:_SMSNum.text]) {
        [self toastResult:@"请输入短信验证码"];
        return;
    }
    NSDictionary *requestDict = [HisuntechBuildJsonString addBankCardWithUserNO:[HisuntechUserEntity Instance].userNo bankNo:[HisuntechUserEntity Instance].bankNo bankcardNo:self.cardNo.text bnkPhone:self.phoneNum.text cardType:@"1" chkNO:self.SMSNum.text cardHolderName:self.name.text IDnum:self.IDnum.text userType:@"3" crdexpDt:_date.text
                                                                  cvn2:_cvn2.text];
    [self requestServer:requestDict requestType:APP_CODE_ADDBankCard codeType:18];
}
/**
 发送验证码
*/
- (void)sendMessage
{
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
    
    //请求参数  _phoneNum.text  3
    NSDictionary *requestDict = [HisuntechBuildJsonString getSendPhoneCodeJsonString:_phoneNum.text userType:@"3"];
    // 请求服务器 发送短信验证码
    [self requestServer:requestDict requestType:APP_CODE_SmsCode codeType:2];
    

}
/**
 *  请求服务器成功
 */
-(void)resquestSuccess:(id)response{
//    NSLog(@" %@ resquestSuccess  JSON: %@", [self class],[response description]);
    
    NSError *error;
    NSData * dataResponse = [NSJSONSerialization dataWithJSONObject:response options:NSJSONWritingPrettyPrinted error:&error];
    NSDictionary *dictJson = [NSJSONSerialization JSONObjectWithData:dataResponse options:NSJSONReadingMutableLeaves error:&error];
    
    if (codeType==2) {
        // MCAOOOOO表示请求成功
        if ([@"MCA00000" isEqual:[dictJson objectForKey:@"RSP_CD"] ] ) {
            [self toastResult:@"短信已发送，请尽快输入"];
        }else{
            [self toastResult:[dictJson objectForKey:@"RSP_MSG"]];
        }
        return;
    }
    NSLog(@"codeType = %d",codeType);
    if (codeType==18) {
        // MCAOOOOO表示请求成功
        if ([@"MCA00000" isEqual:[dictJson objectForKey:@"RSP_CD"] ] ) {
            //跳转到主页支付平台 传值
            [self.delegate passValue:@{@"BNKNO":mBnkNo,//银行简称
                                       @"BNKCRDNO":_cardNo.text,//银行卡号
                                       @"BNKPHONE": _phoneNum.text,//银行预留手机号
                                       @"CRDTYP": @"1",//绑定类型
                                       @"SMSCD": _SMSNum.text,//短信验证码
                                       @"CRDHOLDERNM": _name.text,//持卡人姓名
                                       @"ID_NO": _cvn2.text,//cvn2
                                       @"ID_NO": _date.text,//有效期
                                       @"ID_NO": _IDnum.text}];
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
- (void)selectBankNo:(UIButton *)btn
{
    HisuntechBankController *bank = [[HisuntechBankController alloc]init];
    bank.delegate = self;
    [self.navigationController pushViewController:bank animated:YES];
    
}
/**
 *  dialog提示框
 *
 *  @param toastMsg 提示内容
 */
-(void)toastResult:(NSString *) toastMsg{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:toastMsg
                          message:nil
                          delegate:self
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil];
    [alert show];
}
- (void)passValue1:(NSDictionary *)bankDic
{
    self.bankName.text = [bankDic objectForKey:[HisuntechUserEntity Instance].bankNo];
}
@end
