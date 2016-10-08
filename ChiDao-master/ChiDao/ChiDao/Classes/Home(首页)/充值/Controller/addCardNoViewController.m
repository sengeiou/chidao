//
//  addCardNoViewController.m
//  ChiDao
//
//  Created by 赵洋 on 16/8/18.
//  Copyright © 2016年 赵洋. All rights reserved.
//

#import "addCardNoViewController.h"

#define KScreenHeight [UIScreen mainScreen].bounds.size.height
#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define kKeyBoardBackGroundColor [UIColor colorWithRed:221/255.0 green:225/255.0 blue:226/255.0 alpha:1]
#define kDarkKeyColor [UIColor colorWithRed:179/255.0 green:183/255.0 blue:188/255.0 alpha:1]
#define kKeyBoardHeight (KScreenHeight <= 480 ? KScreenHeight * 0.4 : KScreenHeight * 0.35)
#define kKeyHorizontalSpace 5
#define kKeyVerticalSpace 7.5
#define kKeyWidth (KScreenWidth / 10.0 - kKeyHorizontalSpace * 2)
#define kKeyHeight (kKeyBoardHeight / 4.0 - kKeyVerticalSpace * 2)
@interface addCardNoViewController ()<UITextFieldDelegate>
{
    NSString *cardNo;
    NSString *licenceNo;
    
    //省份键盘
    UIView *_provinceKeyBoard;
    //英数字键盘
    UIView *_englishNumberKeyBoard;
    
    BOOL _isProvinceKeyBoard;
    
    NSArray *_provinceArr;
    
    NSArray *_englishNumberArr;
    
    NSMutableString *_textStr;
}
@property (nonatomic,strong) UITextField *cardNoTF;
@property (nonatomic,strong) UITextField *licenceNoTF;
@property (nonatomic,strong) UIButton *okBtn;
@end

@implementation addCardNoViewController

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
    self.title = @"添加卡片";
    self.view.backgroundColor = NavBarColor;
    [self CreateKeyBoard];
    [self addNavButton];
    [self creatUI];

    _textStr = [[NSMutableString alloc] init];
    
}
-(void)creatUI{
    
    //画线
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 20.0f, myScreenWidth, myLineHight1)];
    [iv setImage:[UIImage imageNamed:@"line.png"]];
    UIImageView *iv2 = [[UIImageView alloc] initWithFrame:CGRectMake(20.0f, 21.0f+50, myScreenWidth, myLineHight1)];
    [iv2 setImage:[UIImage imageNamed:@"line.png"]];
    UIImageView *iv3 = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 22.0f+100, myScreenWidth, myLineHight1)];
    [iv3 setImage:[UIImage imageNamed:@"line.png"]];
    [self.view addSubview:iv];
    [self.view addSubview:iv2];
    [self.view addSubview:iv3];
    
    //左边卡号和车牌号图标
    UIView *card_img = [[UIView alloc] initWithFrame:CGRectMake(0, 21, 52, 50.0f)];
    card_img.backgroundColor = [UIColor whiteColor];
    UIImageView *card_img1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 9, 32, 32.0f)];
    card_img1.image = [UIImage imageNamed:@"card1"];
    [card_img addSubview:card_img1];
    [self.view addSubview:card_img];
    
    UIView *licence_img = [[UIView alloc] initWithFrame:CGRectMake(0, 21+50, 52, 51.0f)];
    licence_img.backgroundColor = [UIColor whiteColor];
    UIImageView *licence_img1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 9, 32, 32.0f)];
    licence_img1.image = [UIImage imageNamed:@"card2"];
    [licence_img addSubview:licence_img1];
    [self.view addSubview:licence_img];
    
    
    self.cardNoTF= [[UITextField alloc] initWithFrame:CGRectMake(52, 21, myScreenWidth-52, 50.0f)];
    [self.cardNoTF setBackgroundColor:BackgroundColor];
    self.cardNoTF.placeholder = @"请输入卡号";
    [self.cardNoTF setBorderStyle:UITextBorderStyleNone];
    [self.cardNoTF setTextAlignment:NSTextAlignmentLeft];
    self.cardNoTF.leftViewMode = UITextFieldViewModeAlways;
    [self.cardNoTF setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self.cardNoTF setReturnKeyType:UIReturnKeyNext];
    [self.cardNoTF setKeyboardType:UIKeyboardTypeNumberPad];
    self.cardNoTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.cardNoTF setDelegate:self];
    [self.view addSubview:self.cardNoTF];
    
    
    self.licenceNoTF = [[UITextField alloc] initWithFrame:CGRectMake(52.0f, 22+50, myScreenWidth-52, 50.0f)];
    self.licenceNoTF.tag = 1900;
    self.licenceNoTF.inputView = [[UIView alloc]initWithFrame:CGRectZero];
    self.licenceNoTF.inputAccessoryView =[[UIView alloc]initWithFrame:CGRectZero];
    self.licenceNoTF.placeholder = @"请输入车牌号";
    [self.licenceNoTF setBackgroundColor:BackgroundColor];
    [self.licenceNoTF setBorderStyle:UITextBorderStyleNone];
    [self.licenceNoTF setTextAlignment:NSTextAlignmentLeft];
    self.licenceNoTF.leftViewMode = UITextFieldViewModeAlways;
    [self.licenceNoTF setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    self.licenceNoTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.licenceNoTF setDelegate:self];
    [self.view addSubview:self.licenceNoTF];
    
    //确定btn
    self.okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _okBtn.backgroundColor = btnColor;
    _okBtn.layer.cornerRadius = myCornerRadius;
    _okBtn.clipsToBounds = YES;
    [_okBtn setTitle:@"确 定" forState:UIControlStateNormal];
    [_okBtn addTarget:self action:@selector(okClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_okBtn];
    
    [_okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (self.licenceNoTF.mas_bottom).offset (20);
        make.left.mas_equalTo (self.view.mas_left).offset (10);
        make.right.mas_equalTo (self.view.mas_right).offset (-10);
        make.height.mas_equalTo (44);
    }];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField==self.cardNoTF) {
        [self.cardNoTF resignFirstResponder];
        [self.licenceNoTF becomeFirstResponder];
    }else{
        [self.licenceNoTF resignFirstResponder];
    }
    
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField==self.cardNoTF) {
       
        
    }else{
       [self.cardNoTF resignFirstResponder];
        [UIView animateWithDuration:0.1 animations:^{
            
            _provinceKeyBoard.frame = CGRectMake(0, KScreenHeight - kKeyBoardHeight-64, KScreenWidth, kKeyBoardHeight);
            //
            _englishNumberKeyBoard.frame = CGRectMake(0, KScreenHeight - kKeyBoardHeight-64, KScreenWidth, kKeyBoardHeight);
        }];
    }
    
}
// 格式化卡号
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *text = [textField text];
    
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
        return NO;
    }
    
    text = [text stringByReplacingCharactersInRange:range withString:string];
    text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *newString = @"";
    while (text.length > 0) {
        NSString *subString = [text substringToIndex:MIN(text.length, 4)];
        newString = [newString stringByAppendingString:subString];
        if (subString.length == 4) {
            newString = [newString stringByAppendingString:@" "];
        }
        text = [text substringFromIndex:MIN(text.length, 4)];
    }
    
    newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
    
    if (newString.length >= 25) {
        return NO;
    }
    
    [textField setText:newString];
    
    return NO;
}
- (void)okClick{
    
    if (![self.cardNoTF.text isEqualToString:@""]&&![self.licenceNoTF.text isEqualToString:@""]) {
        
        if ([self.cardNoTF.text stringByReplacingOccurrencesOfString:@" " withString:@""].length==20) {
            
            
            if ([Tool validateCarNo:[self.licenceNoTF.text substringFromIndex:1]]) {
                //添加鲁通卡
                
                NSDictionary *dic = @{@"cardNum":self.cardNoTF.text,@"plateNum":self.licenceNoTF.text,@"name":@"测试"};
                if (self.addNewCard) {
                    self.addNewCard (dic);
                }
                [Tool showMessage:@"添加卡成功"];
                [self doBack];
                
            }else{
                [Tool showMessage:@"请输入正确车牌号"];
            }
            
        }else{
            [Tool showMessage:@"请输入20位卡号"];
        }
        
    }else{
        [Tool showMessage:@"卡号或车牌号不为空"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark -CreatekeyBoard
- (void)CreateKeyBoard {
    
    _provinceArr = @[@"京", @"津", @"渝", @"沪", @"冀", @"晋", @"辽", @"吉", @"黑", @"苏", @"浙", @"皖", @"闽", @"赣", @"鲁", @"豫", @"鄂", @"湘", @"粤", @"琼", @"川", @"贵", @"云", @"陕", @"甘", @"青", @"蒙", @"桂", @"宁", @"新", @"藏", @"台", @"港", @"澳"];
    
    _englishNumberArr = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0", @"Q", @"W", @"E", @"R", @"T", @"Y", @"U", @"I", @"O", @"P", @"A", @"S", @"D", @"F", @"G", @"H", @"J", @"K", @"L", @"Z", @"X", @"C", @"V", @"B", @"N", @"M"];
    
    //省份键盘
    _provinceKeyBoard = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight, KScreenWidth, kKeyBoardHeight)];
    
    _provinceKeyBoard.backgroundColor = kKeyBoardBackGroundColor;
    
    [self.view addSubview:_provinceKeyBoard];
    //切换键盘按钮
    UIButton *changeToENBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    changeToENBtn.frame = CGRectMake(kKeyHorizontalSpace, kKeyBoardHeight - kKeyHeight - kKeyVerticalSpace, kKeyWidth * 1.5, kKeyHeight);
    [changeToENBtn setBackgroundColor:kDarkKeyColor];
    [changeToENBtn setTitle:@"ABC" forState:UIControlStateNormal];
    changeToENBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    changeToENBtn = [self setShadowWithButton:changeToENBtn];
    [changeToENBtn addTarget:self action:@selector(changeKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    [_provinceKeyBoard addSubview:changeToENBtn];
    
    //删除按钮
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake(KScreenWidth - kKeyWidth * 1.5 - kKeyHorizontalSpace, kKeyBoardHeight - kKeyHeight - kKeyVerticalSpace, kKeyWidth * 1.5, kKeyHeight);
    [deleteBtn setImage:[UIImage imageNamed:@"DeleteEmoticonBtn_ios7"] forState:UIControlStateNormal];
    [deleteBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 5, 0)];
    [deleteBtn setBackgroundColor:kDarkKeyColor];
    deleteBtn = [self setShadowWithButton:deleteBtn];
    [deleteBtn addTarget:self action:@selector(clickDeleteButton) forControlEvents:UIControlEventTouchUpInside];
    [_provinceKeyBoard addSubview:deleteBtn];
    
    for (int i = 0; i < _provinceArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:_provinceArr[i] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor whiteColor]];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        btn = [self setShadowWithButton:btn];
        btn.tag = i + 100;
        [btn addTarget:self action:@selector(clickCharacter:) forControlEvents:UIControlEventTouchUpInside];
        
        int k = i;
        int j = i / 10;
        if (i >= 10 && i < 28) {
            k = i % 10;
        }
        else if (i >= 28) {
            k = i - 28;
            j = 3;
        }
        
        if (i < 20) {
            btn.frame = CGRectMake(kKeyHorizontalSpace + k * (KScreenWidth / 10) , kKeyVerticalSpace + j * (kKeyBoardHeight / 4), kKeyWidth, kKeyHeight);
        }
        else if (i < 28) {
            
            btn.frame = CGRectMake(kKeyHorizontalSpace + (k + 1) * (KScreenWidth / 10), kKeyVerticalSpace + j * (kKeyBoardHeight / 4), kKeyWidth, kKeyHeight);
        }
        else {
            btn.frame = CGRectMake(kKeyHorizontalSpace + (k + 2) * (KScreenWidth / 10), kKeyVerticalSpace + j * (kKeyBoardHeight / 4), kKeyWidth, kKeyHeight);
        }
        
        [_provinceKeyBoard addSubview:btn];
    }
    
    
    //英数字键盘
    _englishNumberKeyBoard = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight, KScreenWidth, kKeyBoardHeight)];
    _englishNumberKeyBoard.backgroundColor = kKeyBoardBackGroundColor;
    [self.view addSubview:_englishNumberKeyBoard];
    
    //切换键盘按钮
    UIButton *changeToProvinceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    changeToProvinceBtn.frame = CGRectMake(kKeyHorizontalSpace, kKeyBoardHeight - kKeyHeight - kKeyVerticalSpace, kKeyWidth * 1.5, kKeyHeight);
    [changeToProvinceBtn setBackgroundColor:kDarkKeyColor];
    [changeToProvinceBtn setTitle:@"省份" forState:UIControlStateNormal];
    changeToProvinceBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    changeToProvinceBtn = [self setShadowWithButton:changeToProvinceBtn];
    [changeToProvinceBtn addTarget:self action:@selector(changeKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    [_englishNumberKeyBoard addSubview:changeToProvinceBtn];
    
    //英数字删除按钮
    UIButton *deleteEnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteEnBtn.frame = CGRectMake(KScreenWidth - kKeyWidth * 1.5 - kKeyHorizontalSpace, kKeyBoardHeight - kKeyHeight - kKeyVerticalSpace, kKeyWidth * 1.5, kKeyHeight);
    [deleteEnBtn setImage:[UIImage imageNamed:@"DeleteEmoticonBtn_ios7"] forState:UIControlStateNormal];
    [deleteEnBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 5, 0)];
    [deleteEnBtn setBackgroundColor:kDarkKeyColor];
    deleteEnBtn = [self setShadowWithButton:deleteEnBtn];
    [deleteEnBtn addTarget:self action:@selector(clickDeleteButton) forControlEvents:UIControlEventTouchUpInside];
    [_englishNumberKeyBoard addSubview:deleteEnBtn];
    
    for (int i = 0; i < _englishNumberArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:_englishNumberArr[i] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor whiteColor]];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        btn = [self setShadowWithButton:btn];
        btn.tag = i + 1000;
        [btn addTarget:self action:@selector(clickCharacter:) forControlEvents:UIControlEventTouchUpInside];
        
        int k = i;
        int j = i / 10;
        if (i >= 10 && i < 29) {
            k = i % 10;
        }
        else if (i >= 29) {
            k = i - 29;
            j = 3;
        }
        
        if (i < 20) {
            btn.frame = CGRectMake(kKeyHorizontalSpace + k * (KScreenWidth / 10) , kKeyVerticalSpace + j * (kKeyBoardHeight / 4), kKeyWidth, kKeyHeight);
        }
        else if (i < 29) {
            
            btn.frame = CGRectMake(kKeyHorizontalSpace + (k + 0.5) * (KScreenWidth / 10), kKeyVerticalSpace + j * (kKeyBoardHeight / 4), kKeyWidth, kKeyHeight);
        }
        else {
            btn.frame = CGRectMake(kKeyHorizontalSpace + (k + 1.5) * (KScreenWidth / 10), kKeyVerticalSpace + j * (kKeyBoardHeight / 4), kKeyWidth, kKeyHeight);
        }
        
        [_englishNumberKeyBoard addSubview:btn];
    }
    
    [self.view bringSubviewToFront:_provinceKeyBoard];
}


//切换键盘
- (void)changeKeyBoard {
    
    _isProvinceKeyBoard = !_isProvinceKeyBoard;
    _provinceKeyBoard.hidden = _isProvinceKeyBoard;
    _englishNumberKeyBoard.hidden = !_isProvinceKeyBoard;
}

- (void)clickDeleteButton {
    if (_textStr.length) {
        NSRange range = {_textStr.length - 1, 1};
        [_textStr deleteCharactersInRange:range];
        self.licenceNoTF.text = _textStr;
    }
}

- (void)clickCharacter:(UIButton *)btn {
    if (btn.tag > 500) {
        [_textStr appendString:_englishNumberArr[btn.tag - 1000]];
    }
    else {
        [_textStr appendString:_provinceArr[btn.tag - 100]];
    }
    self.licenceNoTF.text = _textStr;
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    UITouch *touch = [touches anyObject];
    if (self.view == touch.view) {
        [UIView animateWithDuration:0.1 animations:^{
            _provinceKeyBoard.frame = CGRectMake(0, KScreenHeight , KScreenWidth, 250);
            _englishNumberKeyBoard.frame = CGRectMake(0, KScreenHeight , KScreenWidth, 250);
        }];
    }

}

#pragma mark -Tools

- (UIButton *)setShadowWithButton:(UIButton *)btn {
    btn.layer.cornerRadius = 5;
    btn.layer.shadowOffset =  CGSizeMake(1, 1);
    btn.layer.shadowOpacity = 0.8;
    btn.layer.shadowColor =  [UIColor blackColor].CGColor;
    return btn;
}


@end
