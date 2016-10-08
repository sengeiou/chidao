//
//  LoginController.h
//  Demo_1
//
//  Created by allen on 14-9-18.
//  Copyright (c) 2014年 itazk. All rights reserved.
//

#import "HisuntechBaseViewController.h"
@interface HisuntechLoginController : HisuntechBaseViewController<UITextFieldDelegate,UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    UILabel *orderName;
    UILabel *customerName;
    UILabel *orderSum;
    UITextField *phoneNum;
    UIButton *loginBt;
    UIButton *registerBt;
    UIButton *saveAccountBt;
    NSString* loginPwd;
    NSString *publicKey;
    NSString *randomKey;
    NSString *clientOrder;
    int readAgreementFlag;
    BOOL saveFlag;
    UIButton *doneButton;
    UIImageView* navigationView;
    
    //创建一个 关于是否登录过的回调 block
    void(^hadLoginBlock)(BOOL judgeLogin);
    
}

//是否登录过block回调属性
-(void)judgeTheUserWhetherLoginBlock:(void(^)(BOOL judgeLogin))LoginBlock;

//清除 用户名 标示
@property(nonatomic,assign)BOOL clearUserNameBool;

@property (nonatomic,retain) UITableView *loginTab;
@property (nonatomic,retain) UIImageView *navigationView;
@property (nonatomic,retain) UILabel *orderName;
@property (nonatomic,retain) UILabel *customerName;
@property (nonatomic,retain) UILabel *orderSum;
@property (nonatomic,retain) UITextField *phoneNum;
@property (nonatomic,retain) UIButton *loginBt;
@property (nonatomic,retain) UIButton *registerBt;
@property (nonatomic,retain) UIButton *saveAccountBt;
@property (nonatomic,retain) UIButton *doneButton;
@property (nonatomic,retain) UIButton *openBtn;
@property (strong, nonatomic) UILabel *loginTitle;//title bar

@property (nonatomic,retain) NSString *clientOrder;
@property (nonatomic,retain) NSString *publicKey;
@property (nonatomic,retain) NSString *randomKey;

@property (nonatomic, copy) NSString *merchantCert;//公钥
@property (nonatomic, copy) NSString *signData;//签名
@property (nonatomic,copy) NSString *req_data;//上传数据
@property (nonatomic, copy) NSString *bankTN;//流水号
@property (nonatomic,retain)NSString *money;



- (void)goToMixPayView;//跳转到支付平台
- (void)login;
- (void)addButtonToKeyboard ;
- (void)doneButton:(id)sender;
- (void)getRandomKey;
- (void)getPublicKey;




@end
