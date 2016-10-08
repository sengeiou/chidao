//
//  ReceiptHeaderViewController.m
//  ChiDao
//
//  Created by 赵洋 on 16/8/24.
//  Copyright © 2016年 赵洋. All rights reserved.
//

#import "ReceiptHeaderViewController.h"

@implementation ReceiptHeaderViewController
@synthesize sceneName = _sceneName;
@synthesize sstr = _sstr;
- (void)addNavButton{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    [backBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(doBack2) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(0, 0, 48, 46);
    [saveBtn setTitle:@"确定" forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveSceneName:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
    self.navigationItem.rightBarButtonItem = saveItem;
}

-(void)saveNickName{
    
    if ([self.delegate respondsToSelector:@selector(getReceiptHeader:)]) {
        [self.delegate getReceiptHeader:self.sceneName.text];
    }
    [self.navigationController popViewControllerAnimated:YES];
    [Tool showMessage:@"保存发票抬头成功"];
}
-(void)saveSceneName:(id)sender
{
    
    if ([self.sceneName.text isEqualToString:@""]) {
        [Tool showMessage:@"发票抬头不能为空"];
    }else{
        [self saveNickName];
    }
    
}
-(void)doBack2
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发票抬头";
    [self addNavButton];
    self.view.backgroundColor = BackgroundColor;
    
    self.sceneName = [[UITextField alloc] initWithFrame:CGRectMake(5, 20, myScreenWidth-10, 44)];
    [self.sceneName setBackgroundColor:[UIColor clearColor]];
    [self.sceneName setTag:101];
    self.sceneName.text = self.sstr;
    self.sceneName.borderStyle = UITextBorderStyleRoundedRect;
    self.sceneName.layer.borderColor = [[UIColor colorWithRed:197/255.0 green:198/255.0 blue:201/255.0 alpha:1] CGColor];
    self.sceneName.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.sceneName.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.sceneName setReturnKeyType:UIReturnKeyDone];
    [self.sceneName setFont:[UIFont systemFontOfSize:16]];
    [self.sceneName setKeyboardType:UIKeyboardTypeDefault];
    
    [self.sceneName setDelegate:self];
    [self.view addSubview:self.sceneName];
}
#pragma mark - UITextFieldDelegate
#pragma mark 键盘消失

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.sceneName resignFirstResponder];
    
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField {
    [self.sceneName resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}
- (void)setDelegate:(id<updateReceiptHeaderDelegate>)delegate{
    _delegate = delegate;
}


@end
