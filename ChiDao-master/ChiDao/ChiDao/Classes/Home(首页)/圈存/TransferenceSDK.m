//
//  TransferenceSDK.m
//  TransferenceSDK
//
//  Created by 赵洋 on 16/8/4.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "TransferenceSDK.h"
#import "HisuntechAFNetworking.h"
#import "InfoOBU.h"
#import "MYEncryptedFile.h"

#import "FYNetworkRequest.h"
#import "ZFBLEManage.h"
#import "PubFunctions.h"
#import "JLObuSDK.h"
#import "ObuSDK.h"   //金逸sdk  不需要认证

#define sw16(x) \
((short)(\
(((short)(x)& (short)0x00ffU)<<8) | \
(((short)(x)& (short)0xff00U)>>8) ))
#include <stdio.h>
#include <CardTool.h>

#define kIdentifierForVendor12   [[[[UIDevice currentDevice].identifierForVendor UUIDString] stringByReplacingOccurrencesOfString:@"-" withString:@""]substringToIndex:12]// 获取iOS设备唯一标识
#define DeviceID kIdentifierForVendor12

static NSString *ccID;
static NSString *keyID;
typedef enum{
    ENUM_DEVICE_JY = 0,
    ENUM_DEVICE_ZF,
    ENUM_DEVICE_JL
} DeviceType;

static dispatch_source_t _timer;
//异常timer
static dispatch_source_t _timer2;
static dispatch_semaphore_t semaphore;

static DeviceType deviceType;

NSString *macStr;

@implementation TransferenceSDK

+ (TransferenceSDK *)sharedClient{
    static TransferenceSDK *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _sharedClient = [[TransferenceSDK alloc] init];
        
        
    });
    return _sharedClient;
}

//连接设备
-(void)connectDeviceWithName:(NSString *)peripheralName withAddress:(NSString *)address complete:(CarResult)callBack{
    

    if([peripheralName rangeOfString:@"JY"].location !=NSNotFound)
    {
        deviceType = ENUM_DEVICE_JY;
        [[ObuSDK sharedObuSDK] connectDevice:10 withName:peripheralName callBack:^(Boolean status, NSObject *data, NSString *errorMsg) {
            
            if (status) {
                
                callBack(@"0");
                
            }else{
                callBack(@"1");
            }
        }];
        
    }
    else if([peripheralName rangeOfString:@"ZF"].location !=NSNotFound)
    {
        
        deviceType = ENUM_DEVICE_ZF;
        [[ZFBLEManage ZFBLEManage_SharedZFBLEManage] ZFBLEManage_Connect:address callBack:^(Boolean status, NSObject *data, NSString *errorMsg) {
           
            if (status) {
                
                //连接上设备读取id
                [[ZFBLEManage ZFBLEManage_SharedZFBLEManage] ZF_GetDevInfo:^(Boolean status, NSData *data, NSString *errorMsg) {
                    
                    if (status) {
                        NSString *mStr = [[PubFunctions nsdataToHexString:data] substringWithRange:NSMakeRange(2, 24)];
                       const char *ccc = [mStr UTF8String];
                        char device[13] = {0};
                        asc_to_bcd_2(device, ccc, 24);
                        
                        ccID =[NSString stringWithFormat:@"%s",device];
                        //先取key值 本地优先 进行请求
                        if ([[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@",ccID]]!=nil) {
                            //本地取ID
                            keyID =[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@",ccID]];
                            callBack(@"0");
                        }else{
                            //进行网络请求
                            [self getkeyID:@"" withNum1:ccID completion:^(NSMutableDictionary *dic, NSError *error) {
                               
                                NSString *keyStr =[[dic objectForKey:@"data"] objectForKey:@"devkey"];
                                
                                //存储keyID
                                [[NSUserDefaults standardUserDefaults] setObject:keyStr forKey:ccID];
                                [[NSUserDefaults standardUserDefaults] synchronize];
                                callBack(@"0");
                                
                            }];
                            
                            
                        }
                        
                        
                        
                        
                    }else{
                        callBack(@"1");
                    }
                }];
                
            }else{
                callBack(@"1");
            }
        }];

        
    }
    else if([peripheralName rangeOfString:@"JL"].location !=NSNotFound)
    {
        deviceType = ENUM_DEVICE_JL;
        [[JLObuSDK sharedObuSDK] connectDevice:peripheralName address:address callBack:^(Boolean status, NSObject *data, NSString *errorMsg) {
            if (status) {
                
                //连接上设备读取id
                [[JLObuSDK sharedObuSDK] getDevInformation:^(Boolean status, NSObject *data, NSString *errorMsg) {
                    
                    if (status) {
                        NSDictionary *dic = (NSDictionary *)data;
                        
                        ccID =[dic objectForKey:@"devid"];
                        //先取key值 本地优先 进行请求
                        if ([[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@",ccID]]!=nil) {
                            //本地取ID
                            keyID =[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@",ccID]];
                            callBack(@"0");
                        }else{
                            //进行网络请求
                            [self getkeyID:@"" withNum1:ccID completion:^(NSMutableDictionary *dic, NSError *error) {
                                
                                NSString *keyStr =[[dic objectForKey:@"data"] objectForKey:@"devkey"];
                                
                                //存储keyID
                                [[NSUserDefaults standardUserDefaults] setObject:keyStr forKey:ccID];
                                [[NSUserDefaults standardUserDefaults] synchronize];
                                
                                callBack(@"0");
                                
                            }];
                            
                            
                        }
                        
                        
                        
                        
                    }else{
                        callBack(@"1");
                    }
                }];
                
            }else{
                callBack(@"1");
            }
            
        }];
        
        
    }else{
        callBack(@"2");
    }
    
}
- (void)BleConnect{
    
}
/* 断开OBU设备 */
-(void)disconnectDevice:(CarResult)callBack{
    switch (deviceType) {
        case ENUM_DEVICE_JY:
        {
            [[ObuSDK sharedObuSDK] disconnectDevice:^(Boolean status, NSObject *data, NSString *errorMsg) {
                if (status) {
                    callBack(@"0");
                    
                }else{
                    callBack(@"1");
                }
            }];
        }
            break;
        case ENUM_DEVICE_ZF:
        {
            
            [[ZFBLEManage ZFBLEManage_SharedZFBLEManage] ZFBLEManage_Disconnect:^(Boolean status, NSData *data, NSString *errorMsg) {
                
                if (status) {
                    callBack(@"0");
                    
                }else{
                    callBack(@"1");
                }
            }];
            
        }
            break;
        case ENUM_DEVICE_JL:
        {
            [[JLObuSDK sharedObuSDK]disconnectDevice:^(Boolean status, NSObject *data, NSString *errorMsg) {
                
                if (status) {
                    callBack(@"0");
                    
                }else{
                    callBack(@"1");
                }
                
            }];
        }
            break;
        default:
            break;
    }
}
-(void)cardReset:(CarResult)callBack{
    
    
    switch (deviceType) {
        case ENUM_DEVICE_JY:
        {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                semaphore = dispatch_semaphore_create(0);
            });
            NSString * cmd = @"A2";
            unsigned char info[cmd.length / 2];
            [self hexStringToBytes:cmd bytes:info];
            
            NSData* reqData = [NSData dataWithBytes:info length:(cmd.length / 2)];
            
            NSString *indetify = @"indetify";
            const char *label = [indetify UTF8String];
            //串行队列 只有一个线程
            
            dispatch_queue_t queue = dispatch_queue_create(label, DISPATCH_QUEUE_SERIAL);
            
            dispatch_async(queue, ^{
                
                
                [[ObuSDK sharedObuSDK] transCommand:0 reqData:reqData callBack:^(Boolean status, NSObject *data, NSString *errorMsg) {
                    
                    if (status) {
                        callBack(@"0");
                        
                    }else{
                        callBack(@"1");
                    }
                    
            //            // 完成一次读卡回调之后  才在串行队列里面发送信号量
            //            dispatch_semaphore_signal(semaphore);
                    
                    
                }];
                
                
            });
            
            //    //等待发送信号量之后  才继续执行 ,否则不会继续
            //    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            
        }
            break;
        case ENUM_DEVICE_ZF:
        {
            //先卡片复位操作  如果返回(NSInteger 1101  原因:设备对系统做认证,不能进行业务) 进行设备对系统的认证
            
            unsigned char *bytes = (unsigned char *)[[self replaceData:@"0000000000000000"] bytes];
            unsigned char *bytes2 = (unsigned char *)[[self replaceData:keyID] bytes];
            Byte * bytes3= malloc(4);
            memset(bytes3, 0x00, 4);
            
            //生成的随机数
            unsigned char *ccc = malloc(4);
            GenerateRandomStr(ccc, 4);
            
            
            PBOC_3DES_MAC(ccc,4, bytes2, bytes3, bytes);
            
               
               [[ZFBLEManage ZFBLEManage_SharedZFBLEManage] ZF_IntAuthDev:ccc srcLength:4 mac:bytes3 callBack:^(Boolean status, NSData *data, NSString *errorMsg) {
                   
                   
                   if (status) {
                       NSLog(@"认证成功");
                       [[ZFBLEManage ZFBLEManage_SharedZFBLEManage]ZF_CardReaderReboot:^(Boolean status, NSData *data, NSString *errorMsg) {
                           if (status) {
                               NSLog(@"复位成功");
                               callBack(@"0");
                           }else{
                               callBack(@"1");
                           }
                           
                       } ];
                       
                   }else{
                       //认证失败
                       callBack(@"1");
                   }
                   
               }];
            
            
        }
            break;
        case ENUM_DEVICE_JL:
        {

            //先卡片复位操作  如果返回(Oa02  原因:设备对系统做认证,不能进行业务) 进行设备对系统的认证
            [[JLObuSDK sharedObuSDK] resetCardCommandWithcallBack:^(Boolean status, NSObject *data, NSString *errorMsg) {
                
                if (status) {
                    //复位成功
                    callBack(@"0");
                    
                }else{
                    //复位失败
                    if ([data isKindOfClass:[NSData class]]) {
                        
                        unsigned char *bytes = (unsigned char *)((NSData *)data).bytes;
                        if (bytes[1] == 0x02) {
                            //进行设备对系统的认证
                            unsigned char *bytes = (unsigned char *)[[self replaceData:@"0000000000000000"] bytes];
                            unsigned char *bytes2 = (unsigned char *)[[self replaceData:keyID] bytes];
                            Byte * bytes3= malloc(4);
                            memset(bytes3, 0x00, 4);
                            
                            //生成的随机数
                            unsigned char *ccc = malloc(4);
                            GenerateRandomStr(ccc, 4);
                            
                            PBOC_3DES_MAC(ccc,4, bytes2, bytes3, bytes);
                            
                            NSData *data = [NSData dataWithBytes:ccc length:4];
                            NSData *macData =[NSData dataWithBytes:bytes3 length:4];
                            
                            [[JLObuSDK sharedObuSDK]intAuthDevWithSrc:data Mac:macData callBack:^(Boolean status, NSObject *data, NSString *errorMsg) {
                                
                                if (status) {
                                    //认证成功
                                    [[JLObuSDK sharedObuSDK] resetCardCommandWithcallBack:^(Boolean status, NSObject *data, NSString *errorMsg) {
                                        if (status) {
                                            //复位成功
                                            callBack(@"0");
                                            
                                        }else{
                                            //复位失败
                                            callBack(@"1");
                                        }
                                        
                                    }];
                                        
                                }else{
                                    //认证失败
                                    callBack(@"1");
                                }
                                
                            }];
                            
                        }else{
                            callBack(@"1");
                        }
                    }
                   
                }
                
            }];
            
            
        }
            break;
        default:
            break;
    }
    
    


}
//开始监听
-(void)startListenCar:(CarResult)callBack{
    
    NSTimeInterval period = 5.0; //设置时间间隔
    
    dispatch_queue_t queue = dispatch_queue_create("my queue", 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0); //每秒执行
    //设置回调
    dispatch_resume(_timer);
    
    dispatch_source_set_event_handler(_timer, ^()
                                      
                                      {
                                          dispatch_async(dispatch_get_global_queue(0, 0), ^{
                                              
                                              [[TransferenceSDK sharedClient] cardReset:^(NSString *status) {
                                                  
                                                  
                                                  if ([status isEqualToString:@"0"]) {
                                                      callBack(@"1");
                                                      //有卡挂起计时器
                                                      
                                                      NSLog(@"读卡成功");
                                                      
                                                  }else{
                                                      //无卡继续轮询
                                                      callBack(@"0");
                                                      NSLog(@"读卡失败");
                                                      
                                                     
                                                  }
                                                  
                                                  
                                              }];
                                              
                                              
                                          });
                                          
                                          
                                          
                                          
                                      });
    
    
    
}
//取消监听
-(void)cancelListenCar:(CarResult)callBack{
    
    dispatch_suspend(_timer);
    dispatch_source_set_cancel_handler(_timer, ^{
        
        //销毁计时器
        dispatch_source_cancel(_timer);
        
        //2 表示成功销毁计时器
        callBack(@"2");
    });
    
}
-(void)qzCar:(NSString *)money withCarID:(NSString *)cardID  complete:(QZResult)callBack{
    
    __block NSString *balance;
    dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t queueGroup = dispatch_group_create();
    //任务1
    dispatch_group_async(queueGroup, aQueue, ^{
        
        [self getCarInformation:^(NSMutableDictionary *dic) {
            
            if ([[dic objectForKey:@"data"] count]!=0 &&[cardID isEqualToString:[[dic objectForKey:@"data"] objectForKey:@"cardId"]]) {
                
                if ([[dic objectForKey:@"status"] isEqualToString:@"0"]) {
                    
                    callBack(@"1",@"读卡失败,请重试");
                    
                }else{
                    //继续 pin码认证
                    balance =[[dic objectForKey:@"data"] objectForKey:@"balance"];
                    [self pinVerify:^(NSMutableDictionary *dic) {
                        
                        if ([[dic objectForKey:@"status"] isEqualToString:@"0"]) {
                            
                            callBack(@"1",@"PIN校验失败，请尽快联系客服");
                        }else{
                            char len1[9];
                            memset(len1, 0, 9);
                            sprintf(len1, "%08X", [money intValue]);
                            
                            NSString * vvv = [NSString stringWithCString:len1 encoding:NSUTF8StringEncoding];
                            
                            //圈存金额（十进制）
                            char len9[11];
                            memset(len9, 0, 11);
                            sprintf(len9, "%010d", [money intValue]);
                            
                            NSString * tmpMoney = [NSString stringWithCString:len9 encoding:NSUTF8StringEncoding];
                            
                            __block NSString *syswastesn;
                            //圈存初始化
                            [self etcLoad:vvv withDeviceID:DeviceID complete:^(NSMutableDictionary *dic) {
                                
                                if ([[dic objectForKey:@"status"] isEqualToString:@"0"]) {
                                    
                                    callBack(@"1",@"圈存初始化失败,请重试");
                                }else{
                                    
                                    int seri;
                                    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"zf_loadseq"]!=nil) {
                                        //本地取流水
                                        seri =[[[NSUserDefaults standardUserDefaults] objectForKey:@"zf_loadseq"] intValue];
                                        seri++;
                                        
                                        
                                    }else{
                                        seri =[[[InfoOBU shareInstance]loadseq] intValue]%999999;
                                        seri++;
                                        
                                    }
                                    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",seri] forKey:@"zf_loadseq"];
                                    [[NSUserDefaults standardUserDefaults] synchronize];
                                    
                                    NSString *seariy = [NSString stringWithFormat:@"%@%d",[self getTime],seri];
                                    __block int flag = 0;//0成功 1失败
                                    do {
                                        
                                        NSString *tmp= [dic objectForKey:@"data"];
                                        NSString *tmpOldBalance =[tmp substringWithRange:
                                                                  NSMakeRange(tmp.length- 36,8)];
                                        
                                        char len1[11];
                                        memset(len1, 0, 11);
                                        sprintf(len1, "%010d", [balance intValue]);
                                        
                                        NSString * tmpOld = [NSString stringWithCString:len1 encoding:NSUTF8StringEncoding];
                                        
                                        
                                        
                                        NSString *tmpTradeCode =[tmp substringWithRange:
                                                                 NSMakeRange(tmp.length- 28,4)];
                                        
                                        NSString *tmpNum =[tmp substringWithRange:
                                                           NSMakeRange(tmp.length- 20,8)];
                                        
                                        NSString *tmpRandomNum = [NSString stringWithFormat:@"0000%@",tmpNum];
                                        
                                        
                                        NSString *tmpMac1 =[tmp substringWithRange:
                                                            NSMakeRange(tmp.length- 12,8)];
                                        //                                        NSLog(@"0000=====tmp:%@===tmpOldBalance:%@===tmpOld:%@===tmpTradeCode:%@========tmpRandomNum:%@======tmpMac1:%@",tmp,tmpOldBalance,tmpOld,tmpTradeCode,tmpRandomNum,tmpMac1);
                                        
                                        
                                        
                                        
                                        //圈存请求
                                        dispatch_async(dispatch_get_global_queue(0, 0), ^{
                                            // something
                                            [self qz:@"" withNum1:DeviceID withNum2:[[InfoOBU shareInstance]phoneNum] withNum3:@"95174000" withNum4:seariy withNum5:cardID withNum6:tmpMoney withNum7:tmpOld withNum8:tmpRandomNum withNum9:[NSString stringWithFormat:@"000000%@",tmpTradeCode] withNum10:tmpMac1 withNum11:@"01" completion:^(NSMutableDictionary *dic, NSError *error) {
                                                
                                                if ([[dic objectForKey:@"code"] isEqualToString:@"000000"]) {
                                                    //进行圈存
                                                    syswastesn =[[dic objectForKey:@"data"] objectForKey:@"syswastesn"];
                                                    __block NSString *storetime = [[dic objectForKey:@"data"] objectForKey:@"storetime"];
                                                    flag = 0;//成功
                                                    //圈存成功
                                                    [self etcQC:storetime  withMac2:[[dic objectForKey:@"data"] objectForKey:@"mac2"] complete:^(NSMutableDictionary *dic) {
                                                        
                                                        if ([[dic objectForKey:@"status"] isEqualToString:@"0"]) {
                                                            //圈存失败
                                                            //读卡
                                                            [self getCarInformation:^(NSMutableDictionary *dic) {
                                                                
                                                                if ([[dic objectForKey:@"status"] isEqualToString:@"0"]) {
                                                                    
                                                                   __block int breakFlag = 0;
                                                                    //30次读卡-异常
                                                                    for (int i =0; i<30; i++) {
                                                                        
                                                                        [self getExceptionalCar:balance withFlag:flag withSeariy:seariy withSyswastesn:syswastesn withCardID:cardID withMoney:tmpMoney withStoretime:storetime withTmpTradeCode:tmpTradeCode complete:^(NSString *status, NSString *desc) {
                                                                            
                                                                            if ([status isEqualToString:@"0"]) {
                                                                               //圈存成功
                                                                               callBack(@"0",@"圈存成功");
                                                                                breakFlag =0;
                                                                            }else if([status isEqualToString:@"1"]){
                                                                               //圈存失败
                                                                                callBack(@"1",@"圈存失败");
                                                                                breakFlag =1;
                                                                            }else if([status isEqualToString:@"2"]){
                                                                               //状态未知
                                                                                
                                                                                breakFlag =2;
                                                                            }else if([status isEqualToString:@"5"]){
                                                                                
                                                                               //过程码
                                                                                breakFlag =2;
                                                                            }

                                                                        
                                                                        }];
                                                                        if (breakFlag==0||breakFlag==1) {
                                                                            break;
                                                                        }
                                                                        sleep(1);
                                                                        
                                                                    }
                                                                    //读卡失败
                                                                    if (breakFlag==2) {
                                                                        callBack(@"1",@"圈存结果未知,请以卡内余额为准");
                                                                    }
                                                                    
                                                                    
                                                                }else{
                                                                    //读卡成功
                                                                    NSString *newbalance =[[dic objectForKey:@"data"] objectForKey:@"balance"];
                                                                    
                                                                    if ([newbalance intValue]==[balance intValue]) {
                                                                        
                                                                        dispatch_async(dispatch_get_global_queue(0, 0), ^{
                                                                            
                                                                            flag = 1;
                                                                            int total = [balance intValue];
                                                                            
                                                                            char len1[11];
                                                                            memset(len1, 0, 11);
                                                                            sprintf(len1, "%010d", total);
                                                                            
                                                                            NSString * totalStr = [NSString stringWithCString:len1 encoding:NSUTF8StringEncoding];
                                                                            
                                                                            [self qzVerify:@"" withNum1:DeviceID withNum2:[[InfoOBU shareInstance]phoneNum] withNum3:@"95174000" withNum4:seariy withNum5:syswastesn withNum6:[NSString stringWithFormat:@"%d",flag]  withNum7:cardID withNum8:tmpMoney withNum9: totalStr withNum10:storetime withNum11:@"99999999" withNum12:[NSString stringWithFormat:@"000000%@",tmpTradeCode]  withNum13:@"01" completion:^(NSMutableDictionary *dic, NSError *error) {
                                                                                
                                                                                
                                                                                NSLog(@"余额未增加 圈存失败");
                                                                                callBack(@"1",@"圈存失败");
                                                                                
                                                                            }];
                                                                        });
                                                                        
                                                                    }else if([newbalance intValue]==[balance intValue]+[money intValue]){
                                                                        //卡内余额 = 圈存金额+老余额
                                                                        //成功
                                                                        dispatch_async(dispatch_get_global_queue(0, 0), ^{
                                                                            
                                                                            int total = [balance intValue] + [money intValue];
                                                                            
                                                                            char len1[11];
                                                                            memset(len1, 0, 11);
                                                                            sprintf(len1, "%010d", total);
                                                                            
                                                                            NSString * totalStr = [NSString stringWithCString:len1 encoding:NSUTF8StringEncoding];
                                                                            
                                                                            [self qzVerify:@"" withNum1:DeviceID withNum2:[[InfoOBU shareInstance]phoneNum] withNum3:@"95174000" withNum4:seariy withNum5:syswastesn withNum6:[NSString stringWithFormat:@"%d",flag]  withNum7:cardID withNum8:tmpMoney withNum9: totalStr withNum10:storetime withNum11:@"99999999" withNum12:[NSString stringWithFormat:@"000000%@",tmpTradeCode]  withNum13:@"01" completion:^(NSMutableDictionary *dic, NSError *error) {
                                                                                
                                                                                
                                                                                NSLog(@"圈存真正成功");
                                                                                callBack(@"0",@"圈存成功");
                                                                                
                                                                            }];
                                                                        });
                                                                        
                                                                        
                                                                    }else
                                                                        
                                                                    {
                                                                        //未知状态
                                                                        dispatch_async(dispatch_get_global_queue(0, 0), ^{
                                                                            
                                                                            int total = [balance intValue] + [money intValue];
                                                                            
                                                                            char len1[11];
                                                                            memset(len1, 0, 11);
                                                                            sprintf(len1, "%010d", total);
                                                                            
                                                                            NSString * totalStr = [NSString stringWithCString:len1 encoding:NSUTF8StringEncoding];
                                                                            
                                                                            NSLog(@"圈存状态未知");
                                                                            callBack(@"2",@"圈存状态未知");
                                                                            
                                                                        });
                                                                        
                                                                    }
                                                                    
                                                                }
                                                                
                                                            }];
                                                            
                                                            
                                                        }else{
                                                            //                                                                NSLog(@"ppppp===%@",[[dic objectForKey:@"data"] substringFromIndex:[[dic objectForKey:@"data"] length]-4]);
                                                            
                                                            
                                                            
                                                            if ([dic objectForKey:@"data"]!=nil) {
                                                                
                                                                NSString *tac =[[dic objectForKey:@"data"] substringToIndex:[[dic objectForKey:@"data"] length]-4];
                                                                
                                                                if (tac.length==8) {
                                                                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                                                                        
                                                                        int total = [balance intValue] + [money intValue];
                                                                        
                                                                        char len1[11];
                                                                        memset(len1, 0, 11);
                                                                        sprintf(len1, "%010d", total);
                                                                        
                                                                        NSString * totalStr = [NSString stringWithCString:len1 encoding:NSUTF8StringEncoding];
                                                                        
                                                                        [self qzVerify:@"" withNum1:DeviceID withNum2:[[InfoOBU shareInstance]phoneNum] withNum3:@"95174000" withNum4:seariy withNum5:syswastesn withNum6:[NSString stringWithFormat:@"%d",flag]  withNum7:cardID withNum8:tmpMoney withNum9: totalStr withNum10:storetime withNum11:tac withNum12:[NSString stringWithFormat:@"000000%@",tmpTradeCode]  withNum13:@"01" completion:^(NSMutableDictionary *dic, NSError *error) {
                                                                            
                                                                            
                                                                            NSLog(@"圈存成功");
                                                                            callBack(@"0",@"圈存成功");
                                                                            
                                                                        }];
                                                                    });
                                                                    
                                                                }
 
                                                                
                                                                
                                                            }else{
                                                                
                                                                callBack(@"0",@"圈存成功");
                                                                
                                                            }
                                                            
                                                            
                                                        }
                                                        
                                                        
                                                        
                                                    }];
                                                    
                                                }else{
                                                    flag =1;
                                                    NSLog(@"圈存请求失败");
                                                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                                                        
                                                        flag = 1;
                                                        syswastesn = @"";
                                                        int total = [balance intValue];
                                                        
                                                        char len1[11];
                                                        memset(len1, 0, 11);
                                                        sprintf(len1, "%010d", total);
                                                        
                                                        NSString * totalStr = [NSString stringWithCString:len1 encoding:NSUTF8StringEncoding];
                                                        
                                                        [self qzVerify:@"" withNum1:DeviceID withNum2:[[InfoOBU shareInstance]phoneNum] withNum3:@"95174000" withNum4:seariy withNum5:syswastesn withNum6:[NSString stringWithFormat:@"%d",flag]  withNum7:cardID withNum8:tmpMoney withNum9: totalStr withNum10:[self getTime] withNum11:@"99999999" withNum12:[NSString stringWithFormat:@"000000%@",tmpTradeCode]  withNum13:@"01" completion:^(NSMutableDictionary *dic, NSError *error) {
                                                            
                                                            
                                                            NSLog(@"圈存请求失败");
                                                            callBack(@"1",@"圈存请求失败");
                                                            
                                                        }];
                                                    });
                                                    
                                                }
                                            }];
                                        });
                                        
                                        
                                    } while (false);
                                    
                                    
                                }
                                
                            }];
                        }
                    }];
                    
                }
                
            }else{
                
                //卡号不同
                callBack(@"1",@"圈存卡号不一致");
                
            }
            
        }];
    });
    
    //    //等待组内任务全部完成
    //    dispatch_group_wait(queueGroup, DISPATCH_TIME_FOREVER);
    //
    //    //重新创建组
    //    queueGroup = dispatch_group_create();
    //    //任务4
    //    dispatch_group_async(queueGroup, aQueue, ^{
    //
    //
    //    });
    //    //等待组内任务全部完成
    //    dispatch_group_wait(queueGroup, DISPATCH_TIME_FOREVER);
    
}


-(void)getCarInformation:(ProcessResult)callBack{
    
    switch (deviceType) {
        case ENUM_DEVICE_JY:
        {
            [[ObuSDK sharedObuSDK] getCardInformation:^(Boolean status, NSObject *data, NSString *errorMsg) {
                
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:10];
                if (status) {
                    
                    [dic setObject:@"1" forKey:@"status"];
                    [dic setObject:data forKey:@"data"];
                    
                }else{
                    [dic setObject:@"0" forKey:@"status"];
                    [dic setObject:[NSMutableDictionary dictionaryWithCapacity:10] forKey:@"data"];
                }
                callBack(dic);
                
            }];
        }
            break;
        case ENUM_DEVICE_ZF:
        {
                //复位
                [self cardReset:^(NSString *status) {
                    
                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:10];
                    if ([status isEqualToString:@"0"]) {
                        
                        // 复位成功
                        // 选择应用
                        [self ZFTransceive:@"00A40000021001" complete:^(NSMutableDictionary *dic) {
                            
                            
                            if ([[dic objectForKey:@"status"] isEqualToString:@"0"]) {
                                
                                //选择应用失败
                                [dic setObject:@"0" forKey:@"status"];
                                [dic setObject:[NSMutableDictionary dictionaryWithCapacity:10] forKey:@"data"];
                                
                                
                            }else{
                                //选择应用成功
                                NSLog(@"选择应用成功");
                                [self ZFTransceive:@"00B095002B" complete:^(NSMutableDictionary *dic) {
                                    
                                    if ([[dic objectForKey:@"status"] isEqualToString:@"0"]) {
                                        
                                        
                                        //读卡失败
                                        [dic setObject:@"0" forKey:@"status"];
                                        [dic setObject:[NSMutableDictionary dictionaryWithCapacity:10] forKey:@"data"];
                                        
                                    }else{
                                        //读卡成功
                                        //判断是A卡还是B卡 截取16、17位的字符串
                                        NSString * strCardType = [[dic objectForKey:@"data"] substringWithRange:NSMakeRange(28, 2)];
                                    
                                       
                                        if ([strCardType intValue]==23) {
                                            //A卡
                                            [dic setObject:@"2" forKey:@"status"];
                                            [dic setObject:[NSMutableDictionary dictionaryWithCapacity:10] forKey:@"data"];
                                        }else{
                                            
                                            //封装一层 返回  卡号@"cardId"  余额@"balance" 车牌号@"vehicleNumber"
                                            NSMutableDictionary *dic2 = [NSMutableDictionary dictionaryWithCapacity:10];
                                            [dic2 setObject:[[dic objectForKey:@"data"] substringWithRange:NSMakeRange(20, 20)] forKey:@"cardId"];
                                            [dic2 setObject:[self replaceStr:[[dic objectForKey:@"data"] substringWithRange:NSMakeRange(56, 24)]] forKey:@"vehicleNumber"];

                                            //读卡余额操作
                                            [self ZFTransceive:@"805C000204" complete:^(NSMutableDictionary *dic) {
                                                
                                                if ([[dic objectForKey:@"status"] isEqualToString:@"0"]) {
                                                    //读余额失败
                                                    [dic setObject:@"0" forKey:@"status"];
                                                    [dic setObject:[NSMutableDictionary dictionaryWithCapacity:10] forKey:@"data"];
                                                    
                                                }else{
                                                    //读余额成功
                                                    
                                                    NSString * cardData =[dic objectForKey:@"data"];
                                                    NSString *balanceStr = [cardData substringToIndex:cardData.length-4];
                                                    NSData *balanceData = [PubFunctions HexStringToNSData:balanceStr];
                                                    Byte *testByte = (Byte *)[balanceData bytes];
                                                    int balanceInt = [self toBalance:testByte withIntS:0 withIntN:4];
                                                    
                                                    NSLog(@"读余额成功==%d",balanceInt);
                                                    
                                                    [dic2 setObject:[NSString stringWithFormat:@"%d",balanceInt] forKey:@"balance"];
                                                    
                                                    [dic setObject:@"1" forKey:@"status"];
                                                    [dic setObject:dic2 forKey:@"data"];
                                                    
                                                }
                                                callBack (dic);
                                                
                                            }];
                                            
                                        }
                                        
                                        
                                    }
                                    
                                }];
                                
                            }
                            
                        }];
                        
                        
                        
                    }else{
                        
                        // 复位失败
                        [dic setObject:@"0" forKey:@"status"];
                        [dic setObject:[NSMutableDictionary dictionaryWithCapacity:10] forKey:@"data"];
                    }
                }];

            
        }
            break;
        case ENUM_DEVICE_JL:
        {
            //复位
            [self cardReset:^(NSString *status) {
                
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:10];
                if ([status isEqualToString:@"0"]) {
                    
                    // 复位成功
                    // 选择应用
                    [self JLTransceive:@"00A40000021001" complete:^(NSMutableDictionary *dic) {
                        
                        
                        if ([[dic objectForKey:@"status"] isEqualToString:@"0"]) {
                            
                            NSLog(@"选择应用失败");
                            //选择应用失败
                            [dic setObject:@"0" forKey:@"status"];
                            [dic setObject:[NSMutableDictionary dictionaryWithCapacity:10] forKey:@"data"];
                            
                            
                        }else{
                            //选择应用成功
                            NSLog(@"选择应用成功");
                            [self JLTransceive:@"00B095002B" complete:^(NSMutableDictionary *dic) {
                                
                                if ([[dic objectForKey:@"status"] isEqualToString:@"0"]) {
                                    
                                    
                                    //读卡失败
                                    [dic setObject:@"0" forKey:@"status"];
                                    [dic setObject:[NSMutableDictionary dictionaryWithCapacity:10] forKey:@"data"];
                                    
                                }else{
                                    //读卡成功

                                    //判断是A卡还是B卡 截取16、17位的字符串
                                    int len =hex2dec([[[dic objectForKey:@"data"] substringWithRange:NSMakeRange(2, 2)] UTF8String]);
                                    
                                    NSString *subStr =[[dic objectForKey:@"data"] substringWithRange:NSMakeRange(4, len*2)];
                                    
                                    NSString * strCardType = [subStr substringWithRange:NSMakeRange(28, 2)];
                                    
                                    
                                    if ([strCardType intValue]==23) {
                                        //A卡
                                        [dic setObject:@"2" forKey:@"status"];
                                        [dic setObject:[NSMutableDictionary dictionaryWithCapacity:10] forKey:@"data"];
                                    }else{
                                        
                                        //封装一层 返回  卡号@"cardId"  余额@"balance" 车牌号@"vehicleNumber"
                                        NSMutableDictionary *dic2 = [NSMutableDictionary dictionaryWithCapacity:10];
                                        [dic2 setObject:[subStr substringWithRange:NSMakeRange(20, 20)] forKey:@"cardId"];
                                        [dic2 setObject:[self replaceStr:[subStr substringWithRange:NSMakeRange(56, 24)]] forKey:@"vehicleNumber"];
                                        
                                        //读卡余额操作
                                        [self JLTransceive:@"805C000204" complete:^(NSMutableDictionary *dic) {
                                            
                                            if ([[dic objectForKey:@"status"] isEqualToString:@"0"]) {
                                                //读余额失败
                                                [dic setObject:@"0" forKey:@"status"];
                                                [dic setObject:[NSMutableDictionary dictionaryWithCapacity:10] forKey:@"data"];
                                                
                                            }else{
                                                //读余额成功
                                                int len11 =hex2dec([[[dic objectForKey:@"data"] substringWithRange:NSMakeRange(2, 2)] UTF8String]);
                                                
                                                NSString *cardData =[[dic objectForKey:@"data"] substringWithRange:NSMakeRange(4, len11*2)];
                                                
                                                NSString *balanceStr = [cardData substringToIndex:cardData.length-4];
                                                NSData *balanceData = [PubFunctions HexStringToNSData:balanceStr];
                                                Byte *testByte = (Byte *)[balanceData bytes];
                                                int balanceInt = [self toBalance:testByte withIntS:0 withIntN:4];
                                                
                                                NSLog(@"读余额成功==%d",balanceInt);
                                                
                                                [dic2 setObject:[NSString stringWithFormat:@"%d",balanceInt] forKey:@"balance"];
                                                
                                                [dic setObject:@"1" forKey:@"status"];
                                                [dic setObject:dic2 forKey:@"data"];
                                                
                                            }
                                            callBack (dic);
                                            
                                        }];
                                        
                                    }
                                    
                                    
                                }
                                
                            }];
                            
                        }
                        
                    }];
                    
                    
                    
                }else{
                    
                    // 复位失败
                    [dic setObject:@"0" forKey:@"status"];
                    [dic setObject:[NSMutableDictionary dictionaryWithCapacity:10] forKey:@"data"];
                }
            }];
        }
            break;
        default:
            break;
    }

    
}

-(void)etcLoad:(NSString *)money withDeviceID:(NSString *)deviceID complete:(ProcessResult)callBack{
    
    
    NSMutableString *apdu = [NSMutableString stringWithString:@"805000020B"];
    [apdu appendString:@"01"];
    [apdu appendString:money];
    [apdu appendString:deviceID];
    [apdu appendString:@"10"];
    
    switch (deviceType) {
        case ENUM_DEVICE_JY:
        {
            [self transceive:apdu complete:^(NSMutableDictionary *dic) {
                callBack(dic);
            }];
        }
            break;
        case ENUM_DEVICE_ZF:
        {
            [self ZFTransceive:apdu complete:^(NSMutableDictionary *dic) {
                callBack(dic);
            }];
            
        }
            break;
        case ENUM_DEVICE_JL:
        {
            [self JLTransceive:apdu complete:^(NSMutableDictionary *dic) {
                callBack(dic);
            }];
        }
            break;
        default:
            break;
    }

    
    
}
- (void)etcQC:(NSString *)time withMac2:(NSString *)mac2 complete:(ProcessResult)callBack{
    NSMutableString *apdu = [NSMutableString stringWithString:@"805200000B"];
    [apdu appendString:time];
    [apdu appendString:mac2];
    
    switch (deviceType) {
        case ENUM_DEVICE_JY:
        {
            [self transceive:apdu complete:^(NSMutableDictionary *dic) {
                callBack(dic);
            }];
        }
            break;
        case ENUM_DEVICE_ZF:
        {
            
            [self ZFTransceive:apdu complete:^(NSMutableDictionary *dic) {
                callBack(dic);
            }];
        }
            break;
        case ENUM_DEVICE_JL:
        {
            [self JLTransceive:apdu complete:^(NSMutableDictionary *dic) {
                callBack(dic);
            }];
        }
            break;
        default:
            break;
    }
    
}
- (void)pinVerify:(ProcessResult)callBack{
    NSMutableString *apdu = [NSMutableString stringWithString:@"0020000003123456"];
    switch (deviceType) {
        case ENUM_DEVICE_JY:
        {
            [self transceive:apdu complete:^(NSMutableDictionary *dic) {
                callBack(dic);
            }];
        }
            break;
        case ENUM_DEVICE_ZF:
        {
            [self ZFTransceive:apdu complete:^(NSMutableDictionary *dic) {
                callBack(dic);
            }];
            
        }
            break;
        case ENUM_DEVICE_JL:
        {
            [self JLTransceive:apdu complete:^(NSMutableDictionary *dic) {
                callBack(dic);
            }];
        }
            break;
        default:
            break;
    }
    
    
}


//聚利透传
- (void)JLTransceive:(NSString *)apdu_cmd complete:(ProcessResult)callBack{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:10];
    
    char len1[3];
    memset(len1, 0, 3);
    sprintf(len1, "%02X", (int)apdu_cmd.length/2);
    NSString *cmd = [NSString stringWithFormat:@"%@%s%@",@"01",len1,apdu_cmd];
    NSData *inputData = [self replaceData:cmd];
    
    [[JLObuSDK sharedObuSDK] transCommand:@"03" encode:false reqData:inputData reqDataLen:inputData.length callBack:^(Boolean status, NSObject *data, NSString *errorMsg) {
        
        if (status) {
            //透传成功
            NSString *hex2 = [PubFunctions nsdataToHexString:(NSData *)data];
            [dic setObject:@"1" forKey:@"status"];
            [dic setObject:hex2 forKey:@"data"];
            
        }else{
            //透传失败
            
            [dic setObject:@"0" forKey:@"status"];
            [dic setObject:@"6F02" forKey:@"data"];
        }
        callBack(dic);
        
    }];
    
    
}

//中孚透传
- (void)ZFTransceive:(NSString *)apdu_cmd complete:(ProcessResult)callBack{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:10];

    NSData *inputData = [PubFunctions HexStringToNSData:apdu_cmd];
    Byte *testByte = (Byte *)[inputData bytes];

    [[ZFBLEManage ZFBLEManage_SharedZFBLEManage] ZF_ReadOrWriteCard:testByte inputDataLength:inputData.length callBack:^(Boolean status, NSData *data, NSString *errorMsg) {
       
        
        if (status) {
            //透传成功
            NSString *hex2 = [PubFunctions nsdataToHexString:data];
            [dic setObject:@"1" forKey:@"status"];
            [dic setObject:hex2 forKey:@"data"];
            
        }else{
            //透传失败
            [dic setObject:@"0" forKey:@"status"];
            [dic setObject:@"6F02" forKey:@"data"];
        }
        callBack(dic);
        
    }];
    
    
}
//金逸透传
- (void)transceive:(NSString *)apdu_cmd complete:(ProcessResult)callBack{
    
    NSString *hex_cmd = [self stringToHexString:apdu_cmd];
    if (hex_cmd==nil ||(hex_cmd.length%2!=0)) {
        callBack(nil);
    }
    Byte resData[390];
    NSMutableString *sb_cmd = [NSMutableString stringWithString:@"A300"];
    NSMutableString *sb_tlv = [NSMutableString stringWithString:@"80"];
    int apdu_len_i = [apdu_cmd length]/2+2;//cmd+01+cmdlen
    NSString *apdu_len;
    int n = 0;
    if(apdu_len_i <= 255){
        
        char len1[3];
        memset(len1, 0, 3);
        sprintf(len1, "%02X", apdu_len_i);
        
        apdu_len = [NSString stringWithCString:len1 encoding:NSUTF8StringEncoding];
        n = 1;
    }
    //    else{
    //        apdu_len = [NSString stringWithFormat:@"0%x",apdu_len_i&0xffff];
    //        char len1[5];
    //        memset(len1, 0, 5);
    //        sprintf(len1, "%04X", cmd_a);
    //        n = 2;
    //    }
    
    char len1[3];
    memset(len1, 0, 3);
    sprintf(len1, "%02X", (int)[apdu_cmd length]/2);
    
    
    NSString *str_apdu_hex_cmd_len = [NSString stringWithCString:len1 encoding:NSUTF8StringEncoding];
    if(apdu_len_i < 0x80){
        
        [sb_tlv appendString:apdu_len];
        [sb_tlv appendString:@"01"];
        [sb_tlv appendString:str_apdu_hex_cmd_len];
        [sb_tlv appendString:apdu_cmd];
        
    }else{
        int tlv_len = 0x80+n;
        
        [sb_tlv appendString:[NSString stringWithFormat:@"0%x",tlv_len&0xff]];
        [sb_tlv appendString:apdu_len];
        [sb_tlv appendString:@"01"];
        [sb_tlv appendString:str_apdu_hex_cmd_len];
        [sb_tlv appendString:apdu_cmd];
        
    }
    //注意是byte的长度，需要除2
    short cmd_total_len = (short)([sb_tlv length]/2);
    
    //    NSLog(@"cmd total len:%d",cmd_total_len);
    
    short cmd_a = sw16(cmd_total_len);
    
    char len2[5];
    memset(len2, 0, 5);
    sprintf(len2, "%04X", cmd_a);
    NSString *little_end_len = [NSString stringWithCString:len2 encoding:NSUTF8StringEncoding];
    
    [sb_cmd appendString:little_end_len];
    [sb_cmd appendString:sb_tlv];
    
    
    NSString *fullCMD = sb_cmd;
    
    unsigned char real_apdu[100];
    unsigned char byFullCMD[100];
    
    unsigned char info[fullCMD.length / 2];
    [self hexStringToBytes:fullCMD bytes:info];
    
    
    NSData* reqData2 = [NSData dataWithBytes:info length:(fullCMD.length / 2)];
    
    __block NSString *_data;
    
    [[ObuSDK sharedObuSDK] transCommand:0 reqData:reqData2 callBack:^(Boolean status, NSObject *data, NSString *errorMsg) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:10];
        
        NSMutableData *response = (NSMutableData *)data;
        int len = (int)response.length;
        unsigned char bytes[len];
        [response getBytes:bytes range:NSMakeRange(0, len)];
        NSString *hex = [self bytesToHexString:bytes len:len];
        _data = [[NSString alloc] initWithFormat:@"%@",hex];
        
        int apdu_len2;
        if (status) {
            unsigned char len8[2] = {0};
            len8[0] = bytes[4];
            len8[1] = bytes[3];
            NSString *hex2 = [self bytesToHexString:len8 len:2];
            apdu_len2 = bytes[8];
            
            [dic setObject:@"1" forKey:@"status"];
            [dic setObject:[_data substringFromIndex:(_data.length-apdu_len2*2)] forKey:@"data"];
            
            //            NSLog(@"555555======%@",[_data substringFromIndex:(_data.length-apdu_len2*2)]);
            
        }else{
            unsigned char len8[2] = {0};
            len8[0] = bytes[4];
            len8[1] = bytes[3];
            NSString *hex2 = [self bytesToHexString:len8 len:2];
            
            
            NSLog(@"44444====%@",_data);
            NSString *hex3 = [_data substringWithRange:NSMakeRange(_data.length-6, 2)];
            
            NSLog(@"ffff====%@",hex3);
            
            apdu_len2 = [hex3 intValue];
            
            [dic setObject:@"0" forKey:@"status"];
            
            if (len<4) {
                [dic setObject:@"6F02" forKey:@"data"];
            }else{
                
                NSLog(@"777777======%@==%d====%lu",_data,apdu_len2,(_data.length-apdu_len2*2));
                
                [dic setObject:[_data substringFromIndex:(_data.length-apdu_len2*2)] forKey:@"data"];
            }
            
        }
        
        callBack(dic);
        
    }];
}
//普通字符串转换为十六进制
- (NSString *)stringToHexString:(NSString *)string {
    if(string == nil || [string isEqualToString:@""]){
        return nil;
    }
    
    NSData *myData = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *myBytes = (Byte *)[myData bytes];
    
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myData length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",myBytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
        {
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        }
        else
        {
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
        }
    }
    
    return hexStr;
}
#pragma mark - some function
- (void)hexStringToBytes:(NSString *)hex bytes:(unsigned char *)bytes
{
    if(hex == nil || hex.length / 2 == 0)
    {
        return;
    }
    
    unsigned char temp;
    unsigned char val = 0;
    BOOL flag = YES;
    int j = 0;
    const char *chHex = [hex cStringUsingEncoding:NSUTF8StringEncoding];
    for(int i=0; i<hex.length; i++)
    {
        flag = !flag;
        char ch = chHex[i];
        
        if((ch>='0') && (ch<='9'))
            temp = (unsigned char) (ch-'0');
        else if((ch>='a') && (ch<='f'))
            temp = (unsigned char) ((ch-'a')+10);
        else if((ch>='A') && (ch<='F'))
            temp = (unsigned char) ((ch-'A')+10);
        else
            return;//error
        
        if(flag)
        {
            bytes[j++] = (unsigned char)((val<<4)|temp) ;
        }
        else
        {
            val = temp;
        }
    }
}
// 字节数组转16进制字符串
- (NSString *)bytesToHexString:(unsigned char *)bytes len:(int)len
{
    if(len <= 0 || bytes == nil)
        return nil;
    
    int b = 0;
    NSArray *arBin2Hex = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"A",@"B",@"C",@"D",@"E",@"F"];
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    for(int i=0; i<len; i++)
    {
        b = bytes[i];
        NSString *a1 = [arBin2Hex objectAtIndex:(b >> 4)];
        NSString *a2 = [arBin2Hex objectAtIndex:(b & 0xf)];
        [resultStr appendString:a1];
        [resultStr appendString:a2];
    }
    
    return resultStr;
}

- (NSString *)getTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYYMMddHHmmss"];
    NSDate *datenow = [NSDate date];
    NSString *nowtimeStr = [formatter stringFromDate:datenow];
    
    return nowtimeStr;
}

#pragma ====私有方法====读卡三十次圈存异常处理
-(void) getExceptionalCar:(NSString *)balance withFlag:(int)flagTag withSeariy:(NSString *)seariy withSyswastesn:(NSString *)syswastesn  withCardID:(NSString *)cardID  withMoney:(NSString *)money  withStoretime:(NSString *)storetime withTmpTradeCode:(NSString *)tmpTradeCode complete:(QZResult)callBack{
    
    __block int flag = flagTag;
    //读卡
    [self getCarInformation:^(NSMutableDictionary *dic) {
        
        if ([[dic objectForKey:@"status"] isEqualToString:@"0"]) {
            //读卡失败
            callBack(@"5",@"过程码");
            
        }else{
            //读卡成功
            NSString *newbalance =[[dic objectForKey:@"data"] objectForKey:@"balance"];
            
            if ([newbalance intValue]==[balance intValue]) {
                
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    
                    flag = 1;
                    int total = [balance intValue];
                    
                    char len1[11];
                    memset(len1, 0, 11);
                    sprintf(len1, "%010d", total);
                    
                    NSString * totalStr = [NSString stringWithCString:len1 encoding:NSUTF8StringEncoding];
                    
                    [self qzVerify:@"" withNum1:DeviceID withNum2:[[InfoOBU shareInstance]phoneNum] withNum3:@"95174000" withNum4:seariy withNum5:syswastesn withNum6:[NSString stringWithFormat:@"%d",flag]  withNum7:cardID withNum8:money withNum9: totalStr withNum10:storetime withNum11:@"99999999" withNum12:[NSString stringWithFormat:@"000000%@",tmpTradeCode]  withNum13:@"01" completion:^(NSMutableDictionary *dic, NSError *error) {
                        
                        
                        NSLog(@"余额未增加 圈存失败");
                        callBack(@"1",@"圈存失败");
                        
                    }];
                });
                
            }else if([newbalance intValue]==[balance intValue]+[money intValue]){
                //卡内余额 = 圈存金额+老余额
                //成功
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    
                    int total = [balance intValue] + [money intValue];
                    
                    char len1[11];
                    memset(len1, 0, 11);
                    sprintf(len1, "%010d", total);
                    
                    NSString * totalStr = [NSString stringWithCString:len1 encoding:NSUTF8StringEncoding];
                    
                    [self qzVerify:@"" withNum1:DeviceID withNum2:[[InfoOBU shareInstance]phoneNum] withNum3:@"95174000" withNum4:seariy withNum5:syswastesn withNum6:[NSString stringWithFormat:@"%d",flag]  withNum7:cardID withNum8:money withNum9: totalStr withNum10:storetime withNum11:@"99999999" withNum12:[NSString stringWithFormat:@"000000%@",tmpTradeCode]  withNum13:@"01" completion:^(NSMutableDictionary *dic, NSError *error) {
                        
                        
                        NSLog(@"圈存真正成功");
                        callBack(@"0",@"圈存成功");
                        
                    }];
                });
                
                
            }else
                
            {
                //未知状态
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    
                    int total = [balance intValue] + [money intValue];
                    
                    char len1[11];
                    memset(len1, 0, 11);
                    sprintf(len1, "%010d", total);
                    
                    NSString * totalStr = [NSString stringWithCString:len1 encoding:NSUTF8StringEncoding];
                    
                    NSLog(@"圈存状态未知");
                    callBack(@"2",@"圈存状态未知");
                    
                });
                
            }
            
        }
        
    }];
}
#pragma ====私有方法====圈存请求
-(void) qz:(NSString *)path withNum1:(NSString *)num1 withNum2:(NSString *)num2 withNum3:(NSString *)num3 withNum4:(NSString *)num4 withNum5:(NSString *)num5 withNum6:(NSString *)num6 withNum7:(NSString *)num7 withNum8:(NSString *)num8 withNum9:(NSString *)num9 withNum10:(NSString *)num10 withNum11:(NSString *)num11 completion:(void(^)(NSMutableDictionary *dic,NSError *error))completion{
    
    
    NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithCapacity:20];
    [mDic setObject:[NSString stringWithFormat:@"%@", num1] forKey:@"cardreaderno"];
    [mDic setObject:[NSString stringWithFormat:@"%@", num2] forKey:@"username"];
    [mDic setObject:[NSString stringWithFormat:@"%@", num3] forKey:@"posid"];
    [mDic setObject:[NSString stringWithFormat:@"%@", num4] forKey:@"wastesn"];
    [mDic setObject:[NSString stringWithFormat:@"%@", num5] forKey:@"cardno"];
    [mDic setObject:[NSString stringWithFormat:@"%@", num6] forKey:@"storemoney"];
    [mDic setObject:[NSString stringWithFormat:@"%@", num7] forKey:@"balance"];
    [mDic setObject:[NSString stringWithFormat:@"%@", num8] forKey:@"random"];
    [mDic setObject:[NSString stringWithFormat:@"%@", num9] forKey:@"onlinesn"];
    [mDic setObject:[NSString stringWithFormat:@"%@", num10] forKey:@"mac1"];
    [mDic setObject:[NSString stringWithFormat:@"%@", num11] forKey:@"cardtype"];
    
    
    NSString *str = [MYEncryptedFile goEncryptDES:mDic];
    NSDictionary *dic = @{@"data":str};
    
    
    [FYNetworkRequest postWithSubUrl:@"/ios/cardstoreapply" parameters:dic sucess:^(NSURLSessionDataTask *task, id responseObject) {
 
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        
        if (httpResponse.statusCode == 200) {
            
            completion(responseObject,nil);
        }else{
            
            completion(nil, nil);
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil, nil);
    }];
    
}
#pragma ====私有方法====圈存确认
-(void) qzVerify:(NSString *)path withNum1:(NSString *)num1 withNum2:(NSString *)num2 withNum3:(NSString *)num3 withNum4:(NSString *)num4 withNum5:(NSString *)num5 withNum6:(NSString *)num6 withNum7:(NSString *)num7 withNum8:(NSString *)num8 withNum9:(NSString *)num9 withNum10:(NSString *)num10 withNum11:(NSString *)num11 withNum12:(NSString *)num12 withNum13:(NSString *)num13 completion:(void(^)(NSMutableDictionary *dic,NSError *error))completion{
    
    
    NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithCapacity:20];
    [mDic setObject:[NSString stringWithFormat:@"%@", num1] forKey:@"cardreaderno"];
    [mDic setObject:[NSString stringWithFormat:@"%@", num2] forKey:@"username"];
    [mDic setObject:[NSString stringWithFormat:@"%@", num3] forKey:@"posid"];
    [mDic setObject:[NSString stringWithFormat:@"%@", num4] forKey:@"wastesn"];
    [mDic setObject:[NSString stringWithFormat:@"%@", num5] forKey:@"syswastesn"];
    [mDic setObject:[NSString stringWithFormat:@"%@", num6] forKey:@"flag"];
    [mDic setObject:[NSString stringWithFormat:@"%@", num7] forKey:@"cardno"];
    [mDic setObject:[NSString stringWithFormat:@"%@", num8] forKey:@"storemoney"];
    [mDic setObject:[NSString stringWithFormat:@"%@", num9] forKey:@"balance"];
    [mDic setObject:[NSString stringWithFormat:@"%@", num10] forKey:@"replenishtime"];
    [mDic setObject:[NSString stringWithFormat:@"%@", num11] forKey:@"tac"];
    [mDic setObject:[NSString stringWithFormat:@"%@", num12] forKey:@"onlinesn"];
    [mDic setObject:[NSString stringWithFormat:@"%@", num13] forKey:@"cardtype"];
    
    NSString *str = [MYEncryptedFile goEncryptDES:mDic];
    NSDictionary *dic = @{@"data":str};
    
    
    [FYNetworkRequest postWithSubUrl:@"/ios/cardstorevalidation" parameters:dic sucess:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        
        if (httpResponse.statusCode == 200) {
            
            completion(responseObject,nil);
        }else{
            
            completion(nil, nil);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil, nil);
    }];
    
}
#pragma ====私有方法====取KeyID
-(void) getkeyID:(NSString *)path withNum1:(NSString *)num1 completion:(void(^)(NSMutableDictionary *dic,NSError *error))completion{
    
    
    NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithCapacity:20];
    [mDic setObject:[NSString stringWithFormat:@"%@", num1] forKey:@"devid"];

    
    NSString *str = [MYEncryptedFile goEncryptDES:mDic];
    NSDictionary *dic = @{@"data":str};
    
    [FYNetworkRequest postWithSubUrl:@"/ios/getdevkey" parameters:dic sucess:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        
        if (httpResponse.statusCode == 200) {
            
            completion(responseObject,nil);
        }else{
            [self disconnectDevice:^(NSString *status) {
                
            }];
            completion(nil, nil);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self disconnectDevice:^(NSString *status) {
            
        }];
        completion(nil, nil);
    }];
    
}
#pragma ====私有方法====转换余额
-(int)toBalance:(Byte *)b withIntS:(int)s withIntN:(int)n{
    
    int ret = 0;
    
    const int e = s + n;
    for (int i = s; i < e; ++i) {
        ret <<= 8;
        ret |= b[i] & 0xFF;
    }
    return ret;
}

#pragma ====私有方法====转换车牌号
- (NSString *)replaceStr:(NSString *)cmd{
    unsigned char info[cmd.length / 2];
    [self hexStringToBytes:cmd bytes:info];
    
    NSData* reqData = [NSData dataWithBytes:info length:(cmd.length / 2)];
    NSStringEncoding enc =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    NSString *str = [[NSString alloc] initWithData:reqData encoding:enc];
    
    return str;
}
#pragma ====私有方法====转换设备key
-(NSData *)replaceData:(NSString *)cmd{
    unsigned char info[cmd.length / 2];
    [self hexStringToBytes:cmd bytes:info];
    
    NSData* reqData = [NSData dataWithBytes:info length:(cmd.length / 2)];
    return reqData;
}
int asc_to_bcd_2(char *dst,char *src,int len)
{
    int tmp_in;
    unsigned char temp,d1,d2;
    
    for( tmp_in = 0; tmp_in < len ; )
    {
        temp = src[tmp_in];
        d1 = temp - 0x30;
        
        tmp_in++;
        
        if (tmp_in>=len)
        {
            d2=0x00;
        }
        else
        {
            temp = src[tmp_in];
            d2 = temp - 0x30;
        }
        
        tmp_in++;
        dst[(tmp_in-2)/2] = (d1<<4) | d2;
    }
    
    return (tmp_in+1)/2;
}
//生成4位随机数
void GenerateRandomStr(char *out,int len)
{
    const int LEN = 16; // 10+6
    char g_arrCharElem[LEN] = {'1','2','3','4','5','6','7','8','9','0','A','B','C','D','E','F'};
    
    srand((unsigned)time(0));
    int iRand = 0;
    for (int i = 0; i < len; ++i)
    {
        iRand = rand() % LEN;            // iRand = 0 - 61
        out[i] = g_arrCharElem[iRand];
    }
    out[   len   ]   =   '\0';
}

/*
 * 将字符转换为数值
 * */
int c2i(char ch)
{
    // 如果是数字，则用数字的ASCII码减去48, 如果ch = '2' ,则 '2' - 48 = 2
    if(isdigit(ch))
        return ch - 48;
    
    // 如果是字母，但不是A~F,a~f则返回
    if( ch < 'A' || (ch > 'F' && ch < 'a') || ch > 'z' )
        return -1;
    
    // 如果是大写字母，则用数字的ASCII码减去55, 如果ch = 'A' ,则 'A' - 55 = 10
    // 如果是小写字母，则用数字的ASCII码减去87, 如果ch = 'a' ,则 'a' - 87 = 10
    if(isalpha(ch))
        return isupper(ch) ? ch - 55 : ch - 87;
    
    return -1;
}
/*
 * 功能：将十六进制字符串转换为整型(int)数值
 * */
int hex2dec(char *hex)
{
    int len;
    int num = 0;
    int temp;
    int bits;
    int i;
    
    // 此例中 hex = "1de" 长度为3, hex是main函数传递的
    len = strlen(hex);
    
    for (i=0, temp=0; i<len; i++, temp=0)
    {
        // 第一次：i=0, *(hex + i) = *(hex + 0) = '1', 即temp = 1
        // 第二次：i=1, *(hex + i) = *(hex + 1) = 'd', 即temp = 13
        // 第三次：i=2, *(hex + i) = *(hex + 2) = 'd', 即temp = 14
        temp = c2i( *(hex + i) );
        // 总共3位，一个16进制位用 4 bit保存
        // 第一次：'1'为最高位，所以temp左移 (len - i -1) * 4 = 2 * 4 = 8 位
        // 第二次：'d'为次高位，所以temp左移 (len - i -1) * 4 = 1 * 4 = 4 位
        // 第三次：'e'为最低位，所以temp左移 (len - i -1) * 4 = 0 * 4 = 0 位
        bits = (len - i - 1) * 4;
        temp = temp << bits;
        
        // 此处也可以用 num += temp;进行累加
        num = num | temp;
    }
    
    // 返回结果
    return num;
}

-(NSString *)JsonModel:(NSDictionary *)dictModel
{
    if ([NSJSONSerialization isValidJSONObject:dictModel])
    {
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dictModel options:NSJSONWritingPrettyPrinted error:nil];
        NSString * jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonStr;
    }
    return nil;
}
@end
