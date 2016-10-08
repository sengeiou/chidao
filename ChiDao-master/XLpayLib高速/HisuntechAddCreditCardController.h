//
//  AddCreditCardController.h
//  Demo_1
//
//  Created by allen on 14-9-23.
//  Copyright (c) 2014年 itazk. All rights reserved.
//

#import "HisuntechBaseViewController.h"
#import "HisuntechBNDelegate.h"
@interface HisuntechAddCreditCardController : HisuntechBaseViewController<UITextFieldDelegate,UIAlertViewDelegate,HisuntechBNDelegate>{
    NSString *mBnkNo;
}
@property (nonatomic,retain) UILabel *bankName;
@property (nonatomic,retain) UITextField *cardNo;
@property (nonatomic,retain) UITextField *name;
@property (nonatomic,retain) UITextField *IDnum;
@property (nonatomic,retain) UITextField *phoneNum;
@property (nonatomic,retain) UITextField *SMSNum;
@property (nonatomic,retain) UITextField *cvn2;
@property (nonatomic,retain) UITextField *date;
@property (strong, nonatomic) UILabel *creditTitle;//title bar
@property (nonatomic,retain) UIButton *selectBankBt;
@property (nonatomic,retain) UIButton *goToBank;
@property (nonatomic,retain) id<HisuntechBNDelegate>delegate;

@end
