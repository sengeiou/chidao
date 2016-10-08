//
//  IdCardViewController.m
//  HisunPay
//
//  Created by scofield on 14-11-5.
//  Copyright (c) 2014年 com.hisuntech. All rights reserved.
//

#import "HisuntechIdCardViewController.h"
#import "HisuntechNormalTextField.h"
#import "HisuntechMixPayViewController.h"
#import "HisuntechUIColor+YUColor.h"

#import "HisuntechValidateCheck.h"

@interface HisuntechIdCardViewController ()

// 身份证号
@property (nonatomic,strong) UITextField *idField;
// 姓名
@property (nonatomic,strong) UITextField *nameField;

@end

@implementation HisuntechIdCardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.nameField becomeFirstResponder];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    self.title = @"身份信息";
    [self setLeftItemToBack];
    self.view.backgroundColor = registerViewBackgroundColor;
    
    
    UIImageView *succeImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100,100)];
    succeImage.image = [UIImage imageWithContentsOfFile:ResourcePath(@"PersonMessage_btn.png")];
    succeImage.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, 64+60);
    [self.view addSubview:succeImage];
    
    
    
    UILabel *request = [[UILabel alloc]initWithFrame:CGRectMake(0, 100+18 + 64, [UIScreen mainScreen].bounds.size.width, 30)];
    request.text = @"      请填写您的真实信息,在修改密码时验证使用";
    request.textColor = registerLabelColor;
    request.font = registerLabelFont;
    [self.view addSubview:request];
    
    self.nameField = [[HisuntechNormalTextField alloc]init];
    self.nameField.frame = CGRectMake(0, request.frame.origin.y + request.frame.size.height + 5, screenWidth, 50);
    self.nameField.placeholder = @"请输入姓名";
    [self.view addSubview:self.nameField];
    
    self.idField = [[HisuntechNormalTextField alloc]init];
    self.idField.frame = CGRectMake(0, _nameField.frame.origin.y + _nameField.frame.size.height + 10, screenWidth, 50);
    self.idField.placeholder = @"请输入身份证号";
    [self.view addSubview:self.idField];
    
    UIButton *submit = [UIButton buttonWithType:UIButtonTypeCustom];
    submit.frame = CGRectMake((screenWidth - 300)/2, self.idField.frame.origin.y + self.idField.frame.size.height + 20, 300, 40);
    [submit setTitle:@"提交" forState:UIControlStateNormal];
    [submit.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [submit setBackgroundColor:[UIColor colorWithHexString:@"#41b886" withAlpha:1]];
    submit.layer.cornerRadius = 4;
    submit.clipsToBounds= YES;
    [submit addTarget:self action:@selector(submitID) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:submit];
    
}

- (void)submitID
{
    if (self.nameField.text == nil||self.nameField.text.length == 0) {
        [self toastResult:@"请输入姓名!"];
        return;
    }
    
    if (self.idField.text == nil||self.idField.text.length == 0) {
        [self toastResult:@"请输入身份证号!"];
        return;
    }
    
    HisuntechValidateCheck *IDcheck = [[HisuntechValidateCheck alloc] init];
    BOOL idBool = [IDcheck validateIDCardNumber:self.idField.text];
    if (idBool == NO) {
        [self toastResult:@"请输入正确的身份证号"];
        //清空 身份证输入框
        self.idField.text = @"";
        return;
    }

//    NSString *IDStr;
//    if (self.idField.text.length == 15) {
//        IDStr = @"^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$";
//    }else
//    {
//        IDStr = @"^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{4}$";
//    }
//    
//    
//    NSPredicate *IDPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",IDStr];
//    BOOL isMatch = [IDPre evaluateWithObject:self.idField.text];
//    if (isMatch == NO) {
//        [self toastResult:@"请输入正确的身份证信息!"];
//        return;
//    }
    
//    HisuntechMixPayViewController *mixPayViewController = [[HisuntechMixPayViewController alloc] init];
//    mixPayViewController.dic = @{
//                                 @"SERTM": [HisuntechUserEntity Instance].serverTime,
//                                 @"DRW_BAL":[HisuntechUserEntity Instance].drwBal,
//                                 @"USRCNM":[HisuntechUserEntity Instance].userNm,
//                                 @"MBLNO":[HisuntechUserEntity Instance].userId,
//                                 @"RELFLG":[HisuntechUserEntity Instance].relFlg,
//                                 @"USRNO":[HisuntechUserEntity Instance].userNo,
//                                 @"MAX_CHARGE_DT":[HisuntechUserEntity Instance].changeDate,
//                                 @"USRID":[HisuntechUserEntity Instance].userId
//                                 };
    
//    [self.navigationController pushViewController:mixPayViewController animated:NO];
    
    [self getRandomKey];
}
#pragma mark -获取随机因子
-(void) getRandomKey{
    
    //上行参数
    NSDictionary *requestDict = [HisuntechBuildJsonString getRandomKeyJsonString];
    //请求服务器 获取公钥
    [self requestServer:requestDict requestType:APP_CODE_RandomKey codeType:4];
}




/**
 *  请求服务器成功
 */
-(void)resquestSuccess:(id)response{
    
    NSError *error;
    NSData * dataResponse = [NSJSONSerialization dataWithJSONObject:response options:NSJSONWritingPrettyPrinted error:&error];
    NSDictionary *dictJson = [NSJSONSerialization JSONObjectWithData:dataResponse options:NSJSONReadingMutableLeaves error:&error];
    //获取随机因子
    if (codeType == 4) {
        if ([@"MCA00000" isEqual:[dictJson objectForKey:@"RSP_CD"] ] ) {
            //得到服务器时间之后，进行登录
            [self regesiterRequest];
        }else{
            [self toastResult:[dictJson objectForKey:@"RSP_MSG"]];
        }
        return;
    }
    
    
    //注册
    if (codeType==35) {
        if ([@"MCA00000" isEqual:[dictJson objectForKey:@"RSP_CD"] ] ) {
            
            
            [self.view endEditing:YES];
            //注册成功了 把手机号 存 单利里
            [HisuntechUserEntity Instance].userId = self.sendMessagePhone;
            
            UIView *bgView = [[UIView alloc] initWithFrame:self.view.bounds];
            bgView.backgroundColor = [UIColor lightGrayColor];
            bgView.alpha = 0.6;
            [self.view addSubview:bgView];
            
            UIView *alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 20, 180)];
            
            alertView.layer.cornerRadius = 4;
            alertView.clipsToBounds = YES;
            alertView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
            alertView.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:alertView];
            
            UILabel *succLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, alertView.bounds.size.width - 20, 30)];
            succLabel.text = @"注册成功";
            succLabel.textAlignment = NSTextAlignmentCenter;
            succLabel.font  = [UIFont boldSystemFontOfSize:20];
            succLabel.textColor = [UIColor blackColor];
            [alertView addSubview:succLabel];
            
            UIButton *tureBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            tureBtn.frame = CGRectMake(30, alertView.frame.size.height - 70,  alertView.bounds.size.width - 60, 40);
            [tureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            tureBtn.layer.cornerRadius = 4;
            tureBtn.clipsToBounds = YES;
            [tureBtn setBackgroundColor:[UIColor colorWithHexString:@"41b886" withAlpha:1]];
            [tureBtn setTitle:@"确定" forState:UIControlStateNormal];
            tureBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
            [tureBtn addTarget:self action:@selector(tureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [alertView addSubview:tureBtn];
            }else{
            [self toastResult:[dictJson objectForKey:@"RSP_MSG"]];
        }
        return;
    }
    
}

-(void)tureBtnClick:(UIButton *)btn
{
    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
}

-(void)regesiterRequest
{

    
    
    NSDictionary *requestDict = [HisuntechBuildJsonString getRegisterJsonString:self.sendMessagePhone
                                                                       regEmail:@""
                                                                       loginPwd:[HisuntechUserEntity Instance].loginPwd
                                                                         payPwd:[HisuntechUserEntity Instance].payPwd
                                                                         pswQue:self.question pswAns:self.answer smsCode:[HisuntechUserEntity Instance].smsCode
                                                                            idName:self.nameField.text
                                                                        idCardNum:self.idField.text];
    [self requestServer:requestDict requestType:APP_CODE_UserRegister codeType:35];
}

/**
 *  请求服务器失败
 */
-(void)resquestFail:(id)response{
    if (codeType==35||codeType==4) {
        [self toastResult:@"请检查您当前网络"];
        return;
    }
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
