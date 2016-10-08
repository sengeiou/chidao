//
//  AppDelegate.h
//  ChiDao
//
//  Created by 赵洋 on 16/5/12.
//  Copyright © 2016年 赵洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GeTuiSdk.h"

#define kGtAppId           @"I1kKsBYqBu5TjOPC5MqMm7"
#define kGtAppKey          @"SXs26Q2WX47aFnbUaOTA32"
#define kGtAppSecret       @"TCaJTdXE1Q6YDugZju02o8"

@interface AppDelegate : UIResponder <UIApplicationDelegate, GeTuiSdkDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) NSMutableDictionary *baseDic;

@end

