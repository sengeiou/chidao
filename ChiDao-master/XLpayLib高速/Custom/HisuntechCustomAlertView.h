//
//  CustomAlertVIew.h
//  customUIAlertView
//
//  Created by allen on 14/11/18.
//  Copyright (c) 2014年 com.hisuntech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iProtect.h"

@interface HisuntechCustomAlertView : UIView<UITextFieldDelegate>

@property (nonatomic,retain)PasswordTextField *text;

@property (nonatomic,retain)UITextField *accountField;//账户

@property (nonatomic,retain)UITextField *moneyField;//支付金额

@property (nonatomic,retain)UIButton *btn;

@property (nonatomic,retain)NSString *money;

- (id)initWithFrame:(CGRect)frame target:(id)target action:(SEL)action;

@end
