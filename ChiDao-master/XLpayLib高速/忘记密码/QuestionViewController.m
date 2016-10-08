//
//  QuestionViewController.m
//  hisuntechSdk
//
//  Created by zzp on 15/7/30.
//  Copyright (c) 2015年 com.hisuntech. All rights reserved.
//

#import "QuestionViewController.h"
#import "HisuntechUIColor+YUColor.h"
#import "HisuntechForgetPasswordResetingController.h"
@interface QuestionViewController ()
{
    UILabel *_questionLabel;
    UITextField *_answerTextField;
}

@end

@implementation QuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    self.title = @"重置登录密码";
    [self setLeftItemToBack];
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSDictionary *dict = [HisuntechBuildJsonString getPayQuestionMsgJsonString:self.phoneNumber.text userNo:@"" regEmail:@""];
    [self requestServer:dict requestType:APP_CODE_QuerySafeQuestion codeType:-10];
    
}

-(void)createUI
{
    UILabel *IDAlertLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,70, [UIScreen mainScreen].bounds.size.width - 20, 40)];
    IDAlertLabel.text = @" 请填写您预留的密保答案修改登录密码";
    IDAlertLabel.adjustsFontSizeToFitWidth=  YES;
    IDAlertLabel.font = [UIFont systemFontOfSize:15];
    IDAlertLabel.textColor = [UIColor grayColor];
    [self.view addSubview:IDAlertLabel];
    
    _questionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, IDAlertLabel.frame.origin.y + IDAlertLabel.frame.size.height , [UIScreen mainScreen].bounds.size.width, 40)];
    _questionLabel.font = [UIFont boldSystemFontOfSize:15];
    _questionLabel.textColor = [UIColor lightGrayColor];
    _questionLabel.text = [NSString stringWithFormat:@"  %@",@"密保问题："];
    [self.view addSubview:_questionLabel];
    
    
    _answerTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, _questionLabel.frame.origin.y + _questionLabel.frame.size.height , [UIScreen mainScreen].bounds.size.width, 40)];
    _answerTextField.backgroundColor = [UIColor whiteColor];
    _answerTextField.placeholder = @"  请输入安全问题";
    _answerTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:_answerTextField];
    
    
    UIButton *submit = [UIButton buttonWithType:UIButtonTypeCustom];
    submit.frame = CGRectMake(20, _answerTextField.frame.origin.y + _answerTextField.frame.size.height + 10, [UIScreen mainScreen].bounds.size.width - 40, 40);
    [submit setTitle:@"提交" forState:UIControlStateNormal];
    [submit.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [submit setBackgroundColor:[UIColor colorWithHexString:@"#41b886" withAlpha:1]];
    submit.layer.cornerRadius = 4;
    submit.clipsToBounds = YES;
    [submit addTarget:self action:@selector(submitVerify) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submit];
    
}

-(void)submitVerify
{
    if (_answerTextField.text.length == 0 || _answerTextField.text == nil) {
        [self toastResult:@"请输入正确的信息"];
        return;
    }
    NSDictionary *requestDic = [HisuntechBuildJsonString findPWDWithPhoneNum:self.phoneNumber.text withOPR_TYP:@"2" withCHW_QUES1:_questionLabel.text  withCHW_ANS1:_answerTextField.text];
    [self requestServer:requestDic requestType:APP_CODE_FindPWD codeType:-300];
}


/**
 *  请求服务器成功
 */
-(void)resquestSuccess:(id)response{
    
    NSError *error;
    NSData * dataResponse = [NSJSONSerialization dataWithJSONObject:response options:NSJSONWritingPrettyPrinted error:&error];
    NSDictionary *dictJson = [NSJSONSerialization JSONObjectWithData:dataResponse options:NSJSONReadingMutableLeaves error:&error];
    
    if (codeType == -10) {
        if ([@"MCA00000" isEqual:[dictJson objectForKey:@"RSP_CD"]]) {
            
            _questionLabel.text = [NSString stringWithFormat:@"   %@",[dictJson objectForKey:@"QUES1"]];
            
        }else{
            [self toastResult:[dictJson objectForKey:@"RSP_MSG"]];
        }
    }
    
    if (codeType == -300) {
        if ([@"MCA00000" isEqual:[dictJson objectForKey:@"RSP_CD"]]) {
            HisuntechForgetPasswordResetingController *rpw = [[HisuntechForgetPasswordResetingController alloc]init];
            rpw.phoneNumber = self.phoneNumber;
            
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
