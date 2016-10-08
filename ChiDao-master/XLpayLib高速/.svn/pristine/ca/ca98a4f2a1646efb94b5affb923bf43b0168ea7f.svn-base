//
//  IDViewController.m
//  hisuntechSdk
//
//  Created by zzp on 15/7/30.
//  Copyright (c) 2015年 com.hisuntech. All rights reserved.
//

#import "IDViewController.h"
#import "HisuntechUIColor+YUColor.h"
#import "HisuntechForgetPasswordResetingController.h"

#import "HisuntechValidateCheck.h"

@interface IDViewController ()
{
    UITextField *_IDtextField;
}

@end

@implementation IDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    [self createUI];
    self.title = @"重置登录密码";
    [self setLeftItemToBack];
    
}



-(void)createUI
{
    UILabel *IDAlertLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, [UIScreen mainScreen].bounds.size.width - 20, 40)];
    IDAlertLabel.text = @"请使用实名认证的身份证";
    IDAlertLabel.adjustsFontSizeToFitWidth=  YES;
    IDAlertLabel.font = [UIFont systemFontOfSize:15];
    IDAlertLabel.textColor = [UIColor grayColor];
    [self.view addSubview:IDAlertLabel];
    
    _IDtextField  = [[UITextField alloc] initWithFrame:CGRectMake(0, IDAlertLabel.frame.origin.y + IDAlertLabel.frame.size.height, [UIScreen mainScreen].bounds.size.width, 40)];
    _IDtextField.placeholder = @"  请输入身份证";
    _IDtextField.keyboardType = UIKeyboardTypeNumberPad;
    _IDtextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _IDtextField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_IDtextField];
    
    UIButton *submit = [UIButton buttonWithType:UIButtonTypeCustom];
    submit.frame = CGRectMake(20, _IDtextField.frame.origin.y + _IDtextField.frame.size.height + 10, [UIScreen mainScreen].bounds.size.width - 40, 40);
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
    if (_IDtextField.text.length == 0 || _IDtextField.text == nil) {
        [self toastResult:@"请输入正确的身份证号"];
        return;
    }
    
    HisuntechValidateCheck *IDcheck = [[HisuntechValidateCheck alloc] init];
    BOOL idBool = [IDcheck validateIDCardNumber:_IDtextField.text];
    if (idBool == NO) {
        [self toastResult:@"请输入正确的身份证号"];
        return;
    }
    
    
    
    NSDictionary *requestDic = [HisuntechBuildJsonString findPWDWithPhoneNum:self.phoneNumber.text withOPR_TYP:@"3" withIDCard:_IDtextField.text];
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
