//
//  TestSdkViewController.m
//  ChiDao
//
//  Created by 赵洋 on 16/5/19.
//  Copyright © 2016年 赵洋. All rights reserved.
//

#import "TestSdkViewController.h"
#import "SCButtonsView.h"
#import "SCButton.h"
#import "WJObuSDK.h"
@interface TestSdkViewController ()<SCButtonsViewDelegate>
{
    NSData *obuData;
    NSData *signData;
    NSString *publicKey;
}
@end

@implementation TestSdkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    SCButtonsView *buttonsView = [[SCButtonsView alloc] initWithFrame:CGRectMake(0, 0,myScreenWidth,myScreenHeight-100)];
    buttonsView.delegate = self;
    [self.view addSubview:buttonsView];
    
    
}
- (NSInteger)numberOfButtonsInButtonsView:(SCButtonsView *)buttonsView {
    return 14;
}
- (void)clickBtn:(id)sender{
    switch ([sender tag]-20) {
        case 0:
        {
            if ([WJObuSDK sharedObuSDK].bluetoothState) {
                MyLog(@"打开");
                [[WJObuSDK sharedObuSDK] connectDevice:10 localname:@"0001" callBack:^(BOOL status, id data, NSString *errorMsg) {
                    MyLog(@"obu打开状态=====%d",status);
                }];
            }else{
                MyLog(@"蓝牙关闭");
            }
            
        }
            break;
        case 1:
        {
            [[WJObuSDK sharedObuSDK] disconnectDevice:^(BOOL status, id data, NSString *errorMsg) {
                MyLog(@"断开状态=====%d",status);
            }];
        }
            break;
        case 2:
        {
            [[WJObuSDK sharedObuSDK] getCardInformation:^(BOOL status, id data, NSString *errorMsg) {
                MyLog(@"卡片信息==%@",data);
            }];
        }
            break;
        case 3:
        {
            [[WJObuSDK sharedObuSDK] getObuInformation:^(BOOL status, id data, NSString *errorMsg) {
                MyLog(@"设备信息==%@",data);
            }];
        }
            break;
        case 4:
        {
            
        }
            break;
        case 5:
        {
            //公钥加密
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                // something
                [[WJObuSDK sharedObuSDK] encryptByPublicKey: [@"123" dataUsingEncoding:NSUTF8StringEncoding] publicmodulus:@"c94b0b3a798b7a2877bea17952718cdbb4cfaa7fdd715c0c42db7dc0e804408f49ffddde3828c9422265e5f36c16e45f040a4f1b5931c39845d9a323ea041d64126a8e1e079f579722136486f3cae22d8ed02efab94bb9a98f9f47ea829477c4f677e7b13769cbc992ac26a07127498fe384d97a7960df283888c231700233fb" publickey:@"010001" callBack:^(BOOL status, id data, NSString *errorMsg) {
                   
                    obuData = data;
                    NSLog(@"公钥加密后的数据=====%@",data);
                }];
            });
            
        }
            break;
        case 6:
        {
            //私钥解密
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                // something
                Boolean statuss = [[WJObuSDK sharedObuSDK] ObuWakeUp:^(BOOL status, id data, NSString *errorMsg) {
                    
                }];

                [[WJObuSDK sharedObuSDK] decryptByObuEncryptData:obuData callback:^(BOOL status, id data, NSString *errorMsg) {
                    NSString *str = data;
                    NSLog(@"解密数据===%@===%d",  str,status);
                    
                }];
            });
        }
            break;
        case 7:
        {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                Boolean statuss = [[WJObuSDK sharedObuSDK] ObuWakeUp:^(BOOL status, id data, NSString *errorMsg) {
                    
                    
                }];
                if (statuss) {
                    NSLog(@"唤醒");
                }
                
            });
            
        }
            break;
        case 8:
        {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                Boolean statuss = [[WJObuSDK sharedObuSDK] ObuWakeUp:^(BOOL status, id data, NSString *errorMsg) {
                    if (status) {
                        NSLog(@"唤醒");
                    }
                    
                }];
                            NSLog(@"唤醒obu=====%d",statuss);
                
                if (statuss) {
                    //取公钥
                    [[WJObuSDK sharedObuSDK] getPublicKeylen:1024
                                                    callBack:^(BOOL status, id data, NSString *errorMsg) {
                                                        NSLog(@"公钥=====%d====%@",status,data);
                                                        publicKey = data;
                                                    }];
                }
            });
            
            
            
        }
            break;
        case 9:
        {
            //验证签名
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
                Boolean status = [[WJObuSDK sharedObuSDK] verifyString:[@"123" dataUsingEncoding:NSUTF8StringEncoding] withSign:signData publicmodulus:publicKey publickey:@"010001"];
                
                if(status)NSLog(@"验证签名成功");
            });
            
        }
            break;
        case 10:
        {
            
        }
            break;
        case 11:
        {
            //签名数据
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
                [[WJObuSDK sharedObuSDK] signdata:[@"123" dataUsingEncoding:NSUTF8StringEncoding] callBack:^(BOOL status, id data, NSString *errorMsg) {
                   
                    signData = data;
                    
                }];
            });
        }
            break;
        case 12:
        {
//            闪灯   参数：num，APP传递给sdk的闪灯次数，OBU根据数值进行闪灯，单次闪灯时长1s。
//            index: 5前面板 6后面板
//            返回值：
//            0：正常相应
//            -1：失败
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
                [[WJObuSDK sharedObuSDK] sendLightNums:5 index:5 callback:^(BOOL status, id data, NSString *errorMsg) {
                    MyLog(@"======%d",status);
                }];
                
                [[WJObuSDK sharedObuSDK] listenForLightNum:^{
                    MyLog(@"闪灯");
                }];
            });

            
        }
            break;
        case 13:
        {
            //返回：若执行成功，回调的第二个参数返回弹性柱状态，“00”表示压下，“01”表示弹起，“02”表示通信错误。
            
            [[WJObuSDK sharedObuSDK] qryReaderStates:^(BOOL status, id data, NSString *errorMsg) {
                MyLog(@"弹柱======%@",data);
                
            }];
            
            [[WJObuSDK sharedObuSDK] listenForReaderState:^(BOOL status, id data, NSString *errorMsg) {
                MyLog(@"弹柱监听======%@",data);
                
            }];
        }
            break;
        default:
            break;
    }
}
- (UIButton *)buttonsView:(SCButtonsView *)buttonsView buttonAtIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            SCButton *button = [SCButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@"连接" forState:UIControlStateNormal];
            button.tag = 20+index;
            [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            return button;
        }
            break;
        case 1:
        {
            SCButton *button = [SCButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@"断开" forState:UIControlStateNormal];
            button.tag = 20+index;
            [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            return button;
        }
            break;
        case 2:
        {
            SCButton *button = [SCButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@"读取卡片信息" forState:UIControlStateNormal];
            button.tag = 20+index;
            [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            return button;
        }
            break;
        case 3:
        {
            SCButton *button = [SCButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@"读取设备信息" forState:UIControlStateNormal];
            button.tag = 20+index;
            [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            return button;
        }
            break;
        case 4:
        {
            SCButton *button = [SCButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@"数据透传" forState:UIControlStateNormal];
            button.tag = 20+index;
            [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            return button;
        }
            break;
        case 5:
        {
            SCButton *button = [SCButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@"公钥加密" forState:UIControlStateNormal];
            button.tag = 20+index;
            [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            return button;
        }
            break;
        case 6:
        {
            SCButton *button = [SCButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@"私钥解密" forState:UIControlStateNormal];
            button.tag = 20+index;
            [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            return button;
        }
            break;
        case 7:
        {
            SCButton *button = [SCButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@"设备校验" forState:UIControlStateNormal];
            button.tag = 20+index;
            [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            return button;
        }
            break;
        case 8:
        {
            SCButton *button = [SCButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@"取公钥" forState:UIControlStateNormal];
            button.tag = 20+index;
            [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            return button;
        }
            break;
        case 9:
        {
            SCButton *button = [SCButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@"验证签名" forState:UIControlStateNormal];
            button.tag = 20+index;
            [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            return button;
        }
            break;
        case 10:
        {
            SCButton *button = [SCButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@"OBU加密数据" forState:UIControlStateNormal];
            button.tag = 20+index;
            [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            return button;
        }
            break;
        case 11:
        {
            SCButton *button = [SCButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@"OBU签名数据" forState:UIControlStateNormal];
            button.tag = 20+index;
            [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            return button;
        }
            break;
        case 12:
        {
            SCButton *button = [SCButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@"闪灯" forState:UIControlStateNormal];
            button.tag = 20+index;
            [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            return button;
        }
            break;
        case 13:
        {
            SCButton *button = [SCButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@"弹柱" forState:UIControlStateNormal];
            button.tag = 20+index;
            [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            return button;
        }
            break;
        default:
        {
            return nil;
        }
            break;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
