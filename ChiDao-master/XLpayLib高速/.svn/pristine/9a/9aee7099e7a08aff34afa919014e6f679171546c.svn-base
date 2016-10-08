//
//  PaySucceedController.m
//  Demo_1
//
//  Created by allen on 14-9-23.
//  Copyright (c) 2014年 itazk. All rights reserved.
//

#import "HisuntechPaySucceedController.h"
#import "HisuntechUIColor+YUColor.h"
#import "HisuntechUserEntity.h"

@interface HisuntechPaySucceedController ()
@end

@implementation HisuntechPaySucceedController

@synthesize paySucceedTitle;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
     
        self.title = @"交易结果";  //设置标题
        
        self.navigationItem.hidesBackButton = YES;
    }
    return self;
}
- (void)createUI
{
    UIView *bgView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 150)];//46 194 159
    bgView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    [self.view addSubview:bgView];
    
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(70,95, 30, 30)];
    NSString *path = ResourcePath(@"register_Login_Btn.png");
    icon.image = [UIImage imageWithContentsOfFile:path];
    [self.view addSubview:icon];
    
    UILabel *messLab = [[UILabel alloc]initWithFrame:CGRectMake(110, 90, 120, 40)];
    messLab.font = [UIFont boldSystemFontOfSize:25];
    messLab.textColor = [UIColor blackColor];
    messLab.text = @"支付成功";
    [self.view addSubview:messLab];
    
    UIView *View1 = [[UIView alloc]initWithFrame:CGRectMake(0, 150, [UIScreen mainScreen].bounds.size.width, 50)];
    View1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:View1];
    
    UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 100, 30)];
    lab1.text = @"交易金额:";
    lab1.textColor = [UIColor lightGrayColor];
    [View1 addSubview:lab1];
    
    self.payNum = [[UILabel alloc]initWithFrame:CGRectMake(120, 10, 100, 30)];
    self.payNum.textColor = [UIColor colorWithRed:46/255.0 green:194/255.0 blue:150/255.0 alpha:1];
    //self.payNum.text = @"￥100.00";
    self.payNum.text = [[NSString alloc]initWithFormat:@"￥%.2f",[self.payNumStr floatValue]];
    [View1 addSubview:self.payNum];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10, 200, 300, 1)];
    line.backgroundColor = [UIColor colorWithWhite:0.808 alpha:1.000];
    [self.view addSubview:line];
    
    UIView *View2 = [[UIView alloc]initWithFrame:CGRectMake(0, 201, [UIScreen mainScreen].bounds.size.width, 50)];
    View2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:View2];
    
    UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 100, 30)];
    lab2.text = @"支付流水号:";
    lab2.adjustsFontSizeToFitWidth = YES;
    lab2.textColor = [UIColor lightGrayColor];
    [View2 addSubview:lab2];
    
    self.vouNUm = [[UILabel alloc]initWithFrame:CGRectMake(120, 10, [UIScreen mainScreen].bounds.size.width - (140), 30)];
    self.vouNUm.text = self.dealNum;
    self.vouNUm.textColor = [UIColor lightGrayColor];
    self.vouNUm.adjustsFontSizeToFitWidth = YES;
    [View2 addSubview:self.vouNUm];
    
    UILabel *alertLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 260, [UIScreen mainScreen].bounds.size.width - 20, 30)];
    alertLabel.text = @"如有疑问,请致电95011";
    alertLabel.textAlignment = NSTextAlignmentRight;
    alertLabel.textColor = [UIColor grayColor];
    [self.view addSubview:alertLabel];
    
    
    UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    finishBtn.frame = CGRectMake(20, 330, 280, 40);
    [finishBtn setBackgroundColor:[UIColor colorWithHexString:@"#41b886" withAlpha:1]];
    finishBtn.layer.cornerRadius = 4;
    finishBtn.clipsToBounds = YES;
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [self.view addSubview:finishBtn];
    [finishBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setLeftItemToBack];
//    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor colorWithRed:235/255.0 green:241/255.0 blue:245/255.0 alpha:1];
    [self createUI];
}
//getUpdateAccountMsgJsonString
-(void)btnClick
{
//    self.navigationController.anavigationBarHidden = NO;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)backPop
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)updateUserInfo
{
    //上行参数
    NSDictionary *requestDict = [HisuntechBuildJsonString getUpdateAccountMsgJsonString:[HisuntechUserEntity Instance].userId userNo:[HisuntechUserEntity Instance].userNo regEmail:@""];
    //请求服务器
    [self requestServer:requestDict requestType:APP_CODE_UpdateAccountMsg codeType:15];
}
-(void)resquestSuccess:(id)response{
    NSError *error;
    NSData * dataResponse = [NSJSONSerialization dataWithJSONObject:response options:NSJSONWritingPrettyPrinted error:&error];
    NSDictionary *dictJson = [NSJSONSerialization JSONObjectWithData:dataResponse options:NSJSONReadingMutableLeaves error:&error];
    if (codeType == 15) {
        if ([@"MCA00000" isEqual:[dictJson objectForKey:@"RSP_CD"] ] )
        {
            [HisuntechUserEntity Instance].drwBal = [dictJson objectForKey:@"CURACBAL"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
@end
