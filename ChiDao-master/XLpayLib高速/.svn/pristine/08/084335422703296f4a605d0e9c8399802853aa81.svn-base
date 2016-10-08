//
//  PayFailedViewController.m
//  Demo_1
//
//  Created by allen on 14-9-23.
//  Copyright (c) 2014年 itazk. All rights reserved.
//

#import "HisuntechPayFailedViewController.h"
#import "HisuntechUIColor+YUColor.h"
@interface HisuntechPayFailedViewController ()

@end

@implementation HisuntechPayFailedViewController

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
    
    
    UIImageView *failImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    failImage.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, 90);
    failImage.image = [UIImage imageWithContentsOfFile:ResourcePath(@"Fail_Logo.png")];
    [self.view addSubview:failImage];
    
    UILabel *messLab = [[UILabel alloc]initWithFrame:CGRectMake(110, 115, 120, 40)];
    messLab.font = [UIFont boldSystemFontOfSize:25];
    messLab.textColor = [UIColor blackColor];
    messLab.text = @"支付失败";
    [self.view addSubview:messLab];
    
    UIView *View1 = [[UIView alloc]initWithFrame:CGRectMake(0, 150, [UIScreen mainScreen].bounds.size.width, 50)];
    View1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:View1];
    
    UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 100, 30)];
    lab1.text = @"交易金额:";
    lab1.textColor = [UIColor lightGrayColor];
    [View1 addSubview:lab1];
    
    self.payNum = [[UILabel alloc]initWithFrame:CGRectMake(120, 10, 100, 30)];
    self.payNum.textColor =[UIColor colorWithRed:253/255.0 green:95/255.0 blue:100/255.0 alpha:1];
    self.payNum.text = [[NSString alloc]initWithFormat:@"￥%.2f",[self.payNumStr floatValue]];
    [View1 addSubview:self.payNum];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10, 200, 300, 1)];
    line.backgroundColor = [UIColor colorWithWhite:0.808 alpha:1.000];
    [self.view addSubview:line];
    
    UIView *View2 = [[UIView alloc]initWithFrame:CGRectMake(0, 201, [UIScreen mainScreen].bounds.size.width, 50)];
    View2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:View2];
    
    UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 100, 30)];
    lab2.text = @"交易代码:";
    lab2.textColor = [UIColor lightGrayColor];
    [View2 addSubview:lab2];
    
    self.vouNUm = [[UILabel alloc]initWithFrame:CGRectMake(120, 10, 100, 30)];
    self.vouNUm.text = self.vouNumStr;
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

-(void)backPop
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)btnClick
{
//    self.navigationController.navigationBarHidden = NO;

    [self.navigationController popViewControllerAnimated:YES];
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
