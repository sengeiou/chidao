//
//  ConnectionOBUViewController.m
//  ChiDao
//
//  Created by 赵洋 on 16/6/23.
//  Copyright © 2016年 赵洋. All rights reserved.
//

#import "ConnectionOBUViewController.h"
#import "UITextField+LimitLength.h"
#import "WJObuSDK.h"
#import "InVideoViewController.h"
#import "ActiveViewController.h"
#import "OutVideoViewController.h"
#import "FileUploadViewController.h"
@interface ConnectionOBUViewController ()<UITextFieldDelegate>
{
    
}
@property (nonatomic,strong)UITextField *obuTF;
@property (nonatomic,strong)UIButton *connectBtn;
@end

@implementation ConnectionOBUViewController

@synthesize obuTF = _obuTF;
@synthesize connectBtn = _connectBtn;

- (void)getLight{
    
    NSURLSessionDataTask *task = [[NewsClient sharedClient] getLightNums:OBULightURL withToken:@"3090fcceb96b4f85a6e029329520563c" withObuID:@"3701081320651001" completion:^(NSMutableDictionary *dic, NSError *error) {
        
        if (!error) {
            
            if ([[dic objectForKey:@"code"] isEqualToString:@"000000"]) {

//                 0x00都未上传
//                 0x11车内上传成功，车外失败
//                 0x12车外上传成功，车内失败
//                 0x20未审核
//                 0x21审核通过

                switch ([[[dic objectForKey:@"data"] objectForKey:@"status"] intValue]) {
                    case 0x00:
                    {
                        if (![Tool isExistFile:@"ios_in"]) {
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [[APPConfig getInstance] setCurrentStatus:@"0"];
                                InVideoViewController *InVC = [[InVideoViewController alloc] init];
                                [self.navigationController pushViewController:InVC animated:YES];
                            });
                            
                        }else if ([Tool isExistFile:@"ios_in"]&&![Tool isExistFile:@"ios_out"]){
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [[APPConfig getInstance] setCurrentStatus:@"1"];
                                OutVideoViewController *outVC = [[OutVideoViewController alloc] init];
                                outVC.lightOut2 = [[[dic objectForKey:@"data"] objectForKey:@"out_count"] intValue];
                                [self.navigationController pushViewController:outVC animated:YES];
                            });
                            
                            
                        }else if ([Tool isExistFile:@"ios_in"]&&[Tool isExistFile:@"ios_out"]){
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [[APPConfig getInstance] setCurrentStatus:@"2"];
                                FileUploadViewController *fileVC = [[FileUploadViewController alloc] init];
                                [self.navigationController pushViewController:fileVC animated:YES];
                            });
                            
                        }
                        
                    }
                        break;
                    case 0x11:
                    {
                        if ([Tool isExistFile:@"ios_in"]&&[Tool isExistFile:@"ios_out"]) {
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [[APPConfig getInstance] setCurrentStatus:@"2"];
                                FileUploadViewController *fileVC = [[FileUploadViewController alloc] init];
                                [self.navigationController pushViewController:fileVC animated:YES];
                            });
                            
                        }else if([Tool isExistFile:@"ios_in"]&&![Tool isExistFile:@"ios_out"]){
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [[APPConfig getInstance] setCurrentStatus:@"1"];
                                OutVideoViewController *outVC = [[OutVideoViewController alloc] init];
                                outVC.lightOut2 = [[[dic objectForKey:@"data"] objectForKey:@"out_count"] intValue];
                                [self.navigationController pushViewController:outVC animated:YES];
                            });
                            
                            
                        }
                    }
                        break;
                    case 0x12:
                    {
                        if ([Tool isExistFile:@"ios_in"]&&[Tool isExistFile:@"ios_out"]) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [[APPConfig getInstance] setCurrentStatus:@"2"];
                                FileUploadViewController *fileVC = [[FileUploadViewController alloc] init];
                                [self.navigationController pushViewController:fileVC animated:YES];
                            });
                            
                        }else{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [[APPConfig getInstance] setCurrentStatus:@"0"];
                                InVideoViewController *InVC = [[InVideoViewController alloc] init];
                                [self.navigationController pushViewController:InVC animated:YES];
                            });
                            
                        }
                    }
                        break;
                    case 0x20:
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[APPConfig getInstance] setCurrentStatus:@"3"];
                            ActiveViewController *activeVC = [[ActiveViewController alloc] init];
                            [self.navigationController pushViewController:activeVC animated:YES];
                        });
                        
                        
                    }
                        break;
                    case 0x21:
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[APPConfig getInstance] setCurrentStatus:@"3"];
                            ActiveViewController *activeVC = [[ActiveViewController alloc] init];
                            [self.navigationController pushViewController:activeVC animated:YES];
                        });
                        
                    }
                        break;
                        
                    default:
                        break;
                }
                
            }
            
        }
        
    }];
    [task resume];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"连接OBU";
    self.view.backgroundColor = BackgroundColor;
    
    if ([WJObuSDK sharedObuSDK].bluetoothState) {
        
        
    }else{
        [Tool showMessage:@"请打开手机蓝牙"];
    }
    
    self.obuTF = [[UITextField alloc] initWithFrame:CGRectMake(5, 20, myScreenWidth-10, 44)];
    [self.obuTF setBackgroundColor:[UIColor clearColor]];
    [self.obuTF limitTextLength:4];
    [self.obuTF setTextFieldInputAccessoryView];
    self.obuTF.placeholder = @"请输入镭雕号后四位";
    self.obuTF.borderStyle = UITextBorderStyleRoundedRect;
    self.obuTF.layer.borderColor = myBorderColor;
    self.obuTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.obuTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.obuTF setReturnKeyType:UIReturnKeyDone];
    [self.obuTF setFont:[UIFont systemFontOfSize:16]];
    [self.obuTF setKeyboardType:UIKeyboardTypeNumberPad];
    
    [self.obuTF setDelegate:self];
    [self.view addSubview:self.obuTF];
    
    self.connectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _connectBtn.backgroundColor = btnColor;
    _connectBtn.layer.cornerRadius = myCornerRadius;
    _connectBtn.clipsToBounds = YES;
    [_connectBtn setTitle:@"连 接" forState:UIControlStateNormal];
    [_connectBtn addTarget:self action:@selector(connectOBU) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_connectBtn];
    
    [_connectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (self.obuTF.mas_bottom).offset (20);
        make.left.mas_equalTo (self.view.mas_left).offset (5);
        make.right.mas_equalTo (self.view.mas_right).offset (-5);
        make.height.mas_equalTo (44);
    }];
    
    
}
#pragma mark 连接obu设备
-(void)connectOBU{
    [self.obuTF resignFirstResponder];
    if (self.obuTF.text.length==4) {
        
        __weak __typeof(self)weakSelf = self;
        
        [_connectBtn setTitle:@"连 接 中..." forState:UIControlStateNormal];
        _connectBtn.userInteractionEnabled=NO;
        _connectBtn.alpha=0.4;
        
        [[WJObuSDK sharedObuSDK] connectDevice:10 localname:self.obuTF.text callBack:^(BOOL status, id data, NSString *errorMsg) {
            if (status) {
                MyLog(@"车内视频拍摄");
                
                [_connectBtn setTitle:@"连 接" forState:UIControlStateNormal];
                _connectBtn.userInteractionEnabled=YES;
                _connectBtn.alpha=1;
                
                [[APPConfig getInstance] setCurrentKey:self.obuTF.text];
                
                //obu防拆位是否弹起
                //返回：若执行成功，回调的第二个参数返回弹性柱状态，“00”表示压下，“01”表示弹起，“02”表示通信错误。
                
                [[WJObuSDK sharedObuSDK] qryReaderStates:^(BOOL status, id data, NSString *errorMsg) {
                    
                    
                    switch ([data intValue]) {
                        case 00:{
                            //判断后台obu状态
                            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                                [self getLight];
                            });
                        }
                            
                            break;
                        case 01:{
                            
                            dispatch_async(dispatch_get_main_queue(), ^{

                                [[APPConfig getInstance] setCurrentStatus:@"0"];
                                __strong __typeof(weakSelf) strongSelf = weakSelf;
                                InVideoViewController *InVC = [[InVideoViewController alloc] init];
                                [strongSelf.navigationController pushViewController:InVC animated:YES];
                            });
                            
                            
                        }
                            
                            break;
                        case 02:{
                            
                            [Tool showMessage:@"通信错误,请重新连接"];
                            
                        }
                            
                            break;
                            
                        default:
                            break;
                    }
                    
                }];
                
                
                
            }
        }];
    }else{
        [Tool showMessage:@"请输入四位镭雕号"];
    }
}

#pragma mark - UITextFieldDelegate
#pragma mark 键盘消失

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.obuTF resignFirstResponder];
    
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField {
    [self.obuTF resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
