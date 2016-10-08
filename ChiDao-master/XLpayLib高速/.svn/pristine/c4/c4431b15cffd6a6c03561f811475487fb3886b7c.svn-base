//
//  CustomAlertVIew.m
//  customUIAlertView
//
//  Created by allen on 14/11/18.
//  Copyright (c) 2014年 com.hisuntech. All rights reserved.
//

#import "HisuntechCustomAlertView.h"
#import "HisuntechUIColor+YUColor.h"
@implementation HisuntechCustomAlertView

- (id)initWithFrame:(CGRect)frame target:(id)target action:(SEL)action
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        self.bounds = CGRectMake(0, 0, 280, 240);
        //提示信息
        UILabel *message = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, 280, 20)];
        message.font = [UIFont systemFontOfSize:15.0];
        message.text = @"信联支付";
        message.textAlignment = NSTextAlignmentCenter;
        [self addSubview:message];
        
        //信联支付图标
        UIImageView *logoImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width/2- 60, 5, 20, 20)];
        logoImage.image = [UIImage imageWithContentsOfFile:ResourcePath(@"main_logo.png")];
        [self addSubview:logoImage];
        
        
        //密码输入框
        _text = [[PasswordTextField alloc]initWithFrame:CGRectMake(90, 110, self.frame.size.width-110, 30) usingPasswordKeyboard:YES];
        _text.delegate = self;
        _text.kbdRandom = YES;
        _text.kbdType = KeyboardTypePinNumber;
        _text.font = [UIFont boldSystemFontOfSize:15.0];
        _text.encryptType = E_SDHS_DUAL_PLATFORM;
        _text.borderStyle = UITextBorderStyleRoundedRect;
        _text.maxLength = 6;
        _text.placeholder = @"请输入支付密码";
        [self addSubview:_text];
        
        
        _accountField = [[UITextField alloc]initWithFrame:CGRectMake(90, 30, self.frame.size.width-110, 30)];
        _accountField.delegate = self;
        _accountField.userInteractionEnabled = NO;
        _accountField.font = [UIFont boldSystemFontOfSize:15.0];
        _accountField.borderStyle = UITextBorderStyleRoundedRect;
        _accountField.text = [HisuntechUserEntity Instance].userId;
        [self addSubview:_accountField];
        
        HisuntechUserEntity *user = [HisuntechUserEntity Instance];
        if ([user.ACTION isEqualToString:@"PAY_AGAIN"]) {
            _money = user.TOTAL_AMOUNT;
        }
        else if([user.ACTION isEqualToString:@"card_pay"])
        {
            NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:[user.REQ_DATA dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
            _money = [tempDic objectForKey:@"total_amount"];
        }
        
        _moneyField = [[UITextField alloc]initWithFrame:CGRectMake(90, 70, self.frame.size.width-110, 30)];
        _moneyField.delegate = self;
        _moneyField.font = [UIFont boldSystemFontOfSize:15.0];
        _moneyField.borderStyle = UITextBorderStyleRoundedRect;
        _moneyField.userInteractionEnabled = NO;
        _moneyField.text = [NSString stringWithFormat:@"%.2f元",[_money floatValue]];
        [self addSubview:_moneyField];
        
        //两个button按钮
        NSArray *btnTitle = @[@"取消",@"确定"];
        for (int i = 0; i<btnTitle.count; i++) {
            UIButton *b = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            b.layer.cornerRadius = 4;
            b.clipsToBounds = YES;
            b.frame = CGRectMake(10+i*140, 190, 120, 30);
            [b setTitle:[btnTitle objectAtIndex:i] forState:UIControlStateNormal];
            b.tag = i;
            b.titleLabel.font = [UIFont boldSystemFontOfSize:15];
            [b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [b setBackgroundColor:[UIColor colorWithHexString:@"#41b886" withAlpha:1]];
            [b addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:b];
        }
        NSArray *labelTitle = @[@"信联账号",@"付款金额",@"支付密码"];
        for (int i = 0; i<labelTitle.count; i++){
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 30+i*40, 80, 30)];
            label.text = labelTitle[i];
            [self addSubview:label];
        }
        
        UIButton *cutButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        cutButton.frame = CGRectMake(162, 140, 100, 30);
        [cutButton setTitle:@"切换其他账户" forState:UIControlStateNormal];
        cutButton.tag = 2;
        [cutButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        [cutButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:cutButton];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(168, 165, 88, 1)];
        label.backgroundColor = [UIColor blackColor];
        [self addSubview:label];
    }
    return self;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.layer.borderWidth = 1;
    textField.layer.borderColor = [UIColor colorWithHexString:@"#41b886" withAlpha:1].CGColor;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    textField.layer.borderWidth = 1;
    textField.layer.borderColor = [UIColor grayColor].CGColor;
}


@end
