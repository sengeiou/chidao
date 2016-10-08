//
//  AppConfig.h
//  shufa
//
//  Created by zy on 15/3/18.
//  Copyright (c) 2015年 zy. All rights reserved.
//
/********************************************************************/
/*  应用程序配置文件类
    使用方法(Demo)：
    APPConfig *APPConfig = [APPConfig getInstance];//必须获取实例对象
    设置：APPConfig.isAppFirst = YES;
    获取：BOOL test = APPConfig.isAppFirst;
    判断：if(APPConfig.isAppFirst) {...}
    销毁：请在AppDelegate中的方法
          - (void)applicationWillTerminate:(UIApplication *)application
          中实现如下方法
          [APPConfig attemptDealloc];
*/
/********************************************************************/


#import <Foundation/Foundation.h>

@interface APPConfig : NSObject

+ (APPConfig *)getInstance;
+ (void)attemptDealloc;
- (void)checkAPPConfig;
- (void)setDefaultAPPConfig;

@property(nonatomic,strong) NSUserDefaults *userDefaults;
//===============登录===========================
@property(nonatomic,strong) NSString *userName;//用户名
@property(nonatomic,strong) NSString *tokenWord;//token值
@property(nonatomic,strong) NSString *reqUrl;//是否记住密码  记住密码为1  不记住为0
@property(nonatomic,strong) NSString *currentCity; //当前城市

@property(nonatomic,strong) NSString *currentKey;//当前连接的obu的key值

// 当前连接obu进入的不同界面
// 0 代表车内
// 1 代表车外
// 2 代表上传
// 3 代表激活
@property(nonatomic,strong) NSString *currentStatus;

@property(nonatomic,strong) NSString *currentFlag;//是否是意外退出 比如弹柱弹起等  1为意外情况 0为正常情况
@property(nonatomic,strong) NSString *inFlag;//车内视频等待拍摄  1为多次等待情况 0为正常情况


@end
