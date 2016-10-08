//
//  retrievePayPwdController.m
//  HisunPay
//
//  Created by 王鑫 on 14-11-4.
//  Copyright (c) 2014年 com.hisuntech. All rights reserved.
//

#import "retrievePayPwdController.h"
#import "GetPayPasswordViewController.h"

@interface retrievePayPwdController ()<UIAlertViewDelegate>

@end

@implementation retrievePayPwdController

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
    self.view.backgroundColor = [UIColor colorWithRed:225/255.0 green:235/255.0 blue:239/255.0 alpha:1];
    [self setLeftItemToBack];
    self.title = @"重置支付密码";
    [self createUI];

    NSDictionary *dict = [HisuntechBuildJsonString getPayQuestionMsgJsonString:[HisuntechUserEntity Instance].userId userNo:[HisuntechUserEntity Instance].userNo regEmail:@""];
    
    [self requestServer:dict requestType:APP_CODE_QuerySafeQuestion successSel:@selector(securyQuestionBack:) failureSel:@selector(failure:)];
    
    // Do any additional setup after loading the view.
}

/**
 *  请求安全问题返回
 */
- (void)securyQuestionBack:(id)response
{
    NSError *error;
    NSData * dataResponse = [NSJSONSerialization dataWithJSONObject:response options:NSJSONWritingPrettyPrinted error:&error];
    NSDictionary *dictJson = [NSJSONSerialization JSONObjectWithData:dataResponse options:NSJSONReadingMutableLeaves error:&error];
    
    if ([@"MCA00000" isEqual:[dictJson objectForKey:@"RSP_CD"]]) {
        self.questionLab.text = [dictJson objectForKey:@"QUES1"];
    }else{
        [self toastResult:[dictJson objectForKey:@"RSP_MSG"]];
    }
}

- (void)failure:(NSError *)error
{
    [self toastResult:@"检查网络"];
}

-(void)createUI
{
    UILabel *headerLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 10 + 64, 300, 30)];
    headerLab.text = @" 请填写您预留的密保答案重置支付密码";
    headerLab.textColor = [UIColor lightGrayColor];
    headerLab.font =[UIFont systemFontOfSize:13];
    [self.view addSubview:headerLab];
    
    self.questionLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 50 + 64, 300, 30)];
    self.questionLab.text = @"耐心等待您预留问题";
    self.questionLab.textColor = [UIColor lightGrayColor];
    self.questionLab.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:self.questionLab];
    
    UIView *answerView = [[UIView alloc]initWithFrame:CGRectMake(0, 90 + 64, [UIScreen mainScreen].bounds.size.width, 50)];
    answerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:answerView];
    
    self.answerField = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, 300, 50)];
    self.answerField.placeholder = @"  请输入安全问题答案";
    self.answerField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [answerView addSubview:self.answerField];
    
    self.commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.commitBtn.frame = CGRectMake(20, 200+64, 280, 36);
    [self.commitBtn setTitle:@"下一步" forState:UIControlStateNormal];
    self.commitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.commitBtn.layer.cornerRadius = 5;
    self.commitBtn.clipsToBounds = YES;
    self.commitBtn.backgroundColor = [UIColor colorWithRed:37/255.0 green:183/255.0 blue:148/255.0 alpha:1];
    [self.commitBtn addTarget:self action:@selector(commitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.commitBtn];
    
}


-(void)commitBtnClick
{
    
    if (self.answerField.text.length == 0 || self.answerField.text == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码答案不能为空!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    [HisuntechUserEntity Instance].pwdAns = self.answerField.text;
    [HisuntechUserEntity Instance].pwdQes = self.questionLab.text;
    
    
    NSDictionary *requestDic = [HisuntechBuildJsonString findPWDWithPhoneNum:[HisuntechUserEntity Instance].userId withOPR_TYP:@"2" withCHW_QUES1:self.questionLab.text  withCHW_ANS1:self.answerField.text];
    [self requestServer:requestDic requestType:APP_CODE_FindPWD codeType:-300];
    

}


/**
 *  请求服务器成功
 */
-(void)resquestSuccess:(id)response{
    
    NSError *error;
    NSData * dataResponse = [NSJSONSerialization dataWithJSONObject:response options:NSJSONWritingPrettyPrinted error:&error];
    NSDictionary *dictJson = [NSJSONSerialization JSONObjectWithData:dataResponse options:NSJSONReadingMutableLeaves error:&error];
    
    
    if (codeType == -300) {
        if ([@"MCA00000" isEqual:[dictJson objectForKey:@"RSP_CD"]]) {
            GetPayPasswordViewController *rppc =[[GetPayPasswordViewController alloc]init];
            [self.navigationController pushViewController:rppc animated:YES];
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


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.answerField becomeFirstResponder];
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
