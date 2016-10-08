//
//  AddDebitCardController.h
//  Demo_1
//
//  Created by allen on 14-9-23.
//  Copyright (c) 2014年 itazk. All rights reserved.
//

#import "HisuntechBaseViewController.h"
#import "HisuntechBNDelegate.h"
@interface HisuntechAddDebitCardController : HisuntechBaseViewController<UITextFieldDelegate,UIAlertViewDelegate,HisuntechBNDelegate>{
    NSString *mBnkNo;
}
@property(nonatomic,retain)UILabel *bankName;
@property(nonatomic,retain)UITextField *cardNo;
@property(nonatomic,retain)UITextField *name;
@property(nonatomic,retain)UITextField *IDNum;
@property(nonatomic,retain)UITextField *phoneNum;
@property(nonatomic,retain)UITextField *SMSNum;
@property(nonatomic,retain)UIButton *selectBankBtn;
@property(nonatomic,retain)UIButton *goToBank;
@property(nonatomic,strong)UILabel *debitTitle;
@property(nonatomic,retain)id<HisuntechBNDelegate>delegate;

@end
