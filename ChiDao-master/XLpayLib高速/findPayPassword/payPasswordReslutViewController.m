


//
//  payPasswordReslutViewController.m
//  hisuntechSdk
//
//  Created by zzp on 15/8/28.
//  Copyright (c) 2015年 com.hisuntech. All rights reserved.
//

#import "payPasswordReslutViewController.h"
#import "HisuntechLoginController.h"
#import "HisuntechUIColor+YUColor.h"
@interface payPasswordReslutViewController ()
{
    UILabel *_finshLabel;
    BOOL _hadBool;
}
@end

@implementation payPasswordReslutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _hadBool = NO;
    self.title = @"重置支付密码";
    [self setLeftItemToBack];
    [self crateUI];
}

-(void)backPop
{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
//    for (id temp in self.navigationController.viewControllers) {
//        if ([temp isKindOfClass:[HisuntechLoginController class]]) {
//            _hadBool= YES;
//            int index = (int)[self.navigationController.viewControllers indexOfObject:temp];
//            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index] animated:YES];
//            return;
//        }
//    }
//    
//    if (_hadBool) {
//        return;
//    }else
//    {
//        HisuntechLoginController *login = [[HisuntechLoginController alloc] init];
//        [self.navigationController pushViewController:login animated:YES];
//    }
}

-(void)crateUI
{
    CGRect rect = [@"支付密码设置成功" boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 100, 50) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20]} context:nil];
    _finshLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 0,rect.size.width,rect.size.height)];
    _finshLabel.text = @"支付密码设置成功";
    _finshLabel.adjustsFontSizeToFitWidth = YES;
    _finshLabel.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2 + (rect.size.height), 120);
    [self.view addSubview:_finshLabel];
    
    UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    finishBtn.frame = CGRectMake(50, 150, [UIScreen mainScreen].bounds.size.width - 100, 40);
    finishBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    finishBtn.layer.cornerRadius = 5;
    finishBtn.clipsToBounds = YES;
    [finishBtn setBackgroundColor:[UIColor colorWithHexString:@"#41b880" withAlpha:1]];
    [finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [finishBtn addTarget:self action:@selector(finshBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:finishBtn];
    
    
    UIImageView *finishImage = [[UIImageView alloc] initWithFrame:CGRectMake(_finshLabel.frame.origin.x - (rect.size.height+5), 120 - (rect.size.height/2) , rect.size.height, rect.size.height)];
    finishImage.image = [UIImage imageWithContentsOfFile:ResourcePath(@"register_Login_Btn.png")];
    [self.view addSubview:finishImage];
    
}


-(void)finshBtnClick:(UIButton *)btn
{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
//    for (id temp in self.navigationController.viewControllers) {
//        if ([temp isKindOfClass:[HisuntechLoginController class]]) {
//            _hadBool= YES;
//            int index = (int)[self.navigationController.viewControllers indexOfObject:temp];
//            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index] animated:YES];
//            return;
//        }
//    }
//    
//    if (_hadBool) {
//        return;
//    }else
//    {
//        HisuntechLoginController *login = [[HisuntechLoginController alloc] init];
//        [self.navigationController pushViewController:login animated:YES];
//    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
