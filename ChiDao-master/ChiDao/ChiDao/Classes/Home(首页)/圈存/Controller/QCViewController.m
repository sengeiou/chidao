//
//  QCViewController.m
//  QCDemo
//
//  Created by 赵洋 on 16/8/4.
//  Copyright © 2016年 com.sdhs. All rights reserved.
//

#import "QCViewController.h"
#import "TransferenceSDK.h"
#import "InfoOBU.h"
#import "SVProgressHUD.h"
@interface QCViewController (){
    NSString *cardID;
}
@property (nonatomic,strong)UIButton *connectBtn;
@property (nonatomic,strong)UIButton *qcBtn;

@property (nonatomic,strong)UIButton *readBtn;

@property (nonatomic,strong)UIButton *resetBtn;

@property (nonatomic,strong)UIButton *chooseBtn;
@end

@implementation QCViewController
@synthesize connectBtn = _connectBtn;
@synthesize qcBtn = _qcBtn;

@synthesize readBtn = _readBtn;
@synthesize resetBtn = _resetBtn;

@synthesize chooseBtn = _chooseBtn;

- (void)addNavButton{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    [backBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(doBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
}

-(void)doBack
{


    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"寻卡圈存";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.connectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_connectBtn setFrame:CGRectMake(10, 64, myScreenWidth-20, 60)];
    _connectBtn.backgroundColor = btnColor;
    _connectBtn.layer.cornerRadius = myCornerRadius;
    _connectBtn.clipsToBounds = YES;
    [_connectBtn setTitle:@"读卡" forState:UIControlStateNormal];
    [_connectBtn addTarget:self action:@selector(readCard) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_connectBtn];
    
    
    self.qcBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_qcBtn setFrame:CGRectMake(10, 150, myScreenWidth-20, 60)];
    _qcBtn.backgroundColor = btnColor;
    _qcBtn.layer.cornerRadius = myCornerRadius;
    _qcBtn.clipsToBounds = YES;
    [_qcBtn setTitle:@"圈存" forState:UIControlStateNormal];
    [_qcBtn addTarget:self action:@selector(qcCard) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_qcBtn];
    
    self.readBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_readBtn setFrame:CGRectMake(10, 250, myScreenWidth-20, 60)];
    _readBtn.backgroundColor = btnColor;
    _readBtn.layer.cornerRadius = myCornerRadius;
    _readBtn.clipsToBounds = YES;
    [_readBtn setTitle:@"余额" forState:UIControlStateNormal];
    [_readBtn addTarget:self action:@selector(readCardBalance) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_readBtn];
    
    self.resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_resetBtn setFrame:CGRectMake(10, 320, myScreenWidth-20, 60)];
    _resetBtn.backgroundColor = btnColor;
    _resetBtn.layer.cornerRadius = myCornerRadius;
    _resetBtn.clipsToBounds = YES;
    [_resetBtn setTitle:@"卡复位" forState:UIControlStateNormal];
    [_resetBtn addTarget:self action:@selector(resetCard) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_resetBtn];
    
    self.chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_chooseBtn setFrame:CGRectMake(10, 400, myScreenWidth-20, 60)];
    _chooseBtn.backgroundColor = btnColor;
    _chooseBtn.layer.cornerRadius = myCornerRadius;
    _chooseBtn.clipsToBounds = YES;
    [_chooseBtn setTitle:@"断开连接" forState:UIControlStateNormal];
    [_chooseBtn addTarget:self action:@selector(chooseCard) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_chooseBtn];
}

- (void)readCard{
    [[TransferenceSDK sharedClient] getCarInformation:^(NSMutableDictionary *dic) {
        
        if ([[dic objectForKey:@"status"] isEqualToString:@"1"]) {
            [SVProgressHUD showSuccessWithStatus:@"读卡成功"];
           cardID =[[dic objectForKey:@"data"] objectForKey:@"cardId"];
        }
    }];
    
}
- (void)qcCard{
    [InfoOBU shareInstance].phoneNum = @"18668923919";
    [InfoOBU shareInstance].loadseq = @"000000";
    
    [[TransferenceSDK sharedClient] qzCar:@"1" withCarID:cardID complete:^(NSString *status, NSString *desc) {
        
        if ([status isEqualToString:@"0"]) {
            [SVProgressHUD showSuccessWithStatus:@"圈存成功"];
        }else{
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"圈存失败===%@",desc]];
        }
    }];
    
    
}
- (void)readCardBalance{

}
- (void)resetCard{
    [[TransferenceSDK sharedClient]cardReset:^(NSString *status) {
        
        if ([status isEqualToString:@"0"]) {
            [SVProgressHUD showSuccessWithStatus:@"复位成功"];
        }else{
        }
    }];
     
}
- (void)chooseCard{
//    [[TransferenceSDK sharedClient]chooseCard:^(NSString *status) {
//        
//        if ([status isEqualToString:@"0"]) {
//            [SVProgressHUD showSuccessWithStatus:@"选择应用成功"];
//        }else{
//        }
//    }];
    [[TransferenceSDK sharedClient] disconnectDevice:^(NSString *status) {
        if ([status isEqualToString:@"0"]) {
            [SVProgressHUD showSuccessWithStatus:@"断开成功"];
        }else{
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
