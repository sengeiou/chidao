//
//  AppConfig.m
//  shufa
//
//  Created by zy on 15/3/18.
//  Copyright (c) 2015年 zy. All rights reserved.
//
/********************************************************************/
/* 应用程序配置文件类
 注意：如需添加自己的属性方法，请也需按照规则添加方便日后使用。
 1.增加属性变量
 2.构造一个方法如： - (void)bulidYourFunction:(NSString *)value
 3.重写属性变量get和set方法
 4.是否需要在默认方法中添加默认值
 */
/********************************************************************/

#import "APPConfig.h"

static APPConfig *sharedInstance = nil;

@implementation APPConfig
@synthesize userDefaults;
/**
 获取APPConfig的实例对象，无需创建新实例
 使用方法(Demo)：
 设置：APPConfig.isAppFirst = YES;
 获取：BOOL test = APPConfig.isAppFirst;
 判断：if(APPConfig.isAppFirst) {...}
*/
+ (APPConfig *)getInstance
{
    @synchronized(self)
    {
        if (sharedInstance == nil)
        {
            sharedInstance = [[self alloc] init];
            sharedInstance.userDefaults = [NSUserDefaults standardUserDefaults];
//            [sharedInstance checkAPPConfig];
        }
    }

    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (sharedInstance == nil)
        {
            sharedInstance = [super allocWithZone:zone];
            sharedInstance.userDefaults = [NSUserDefaults standardUserDefaults];

            return sharedInstance;
        }
    }
    
    return nil;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

/**尝试销毁单例
 一般-(void)applicationWillTerminate:(UIApplication *)application方法中调用
 */
+ (void)attemptDealloc
{
    sharedInstance = nil;
}

//------------------------------------------------------------------//
//                         分割线                              //
//------------------------------------------------------------------//

- (void)checkUserDefaults
{
    if (userDefaults ==nil) {
        userDefaults = [NSUserDefaults standardUserDefaults];
    }
}

- (void)userDefaultsSetInteger:(NSInteger) value forKey:(NSString *)key
{
    [self checkUserDefaults];
    [userDefaults setInteger:value forKey:key];
    [userDefaults synchronize];
    
}

- (void)userDefaultsSetFloat:(float) value forKey:(NSString *)key
{
    [self checkUserDefaults];
    [userDefaults setFloat:value forKey: key];
    [userDefaults synchronize];
}

- (void)userDefaultsSetDouble:(double) value forKey:(NSString *)key
{
    [self checkUserDefaults];
    [userDefaults setDouble:value forKey:key];
    [userDefaults synchronize];
}

- (void)userDefaultsSetBool:(BOOL) value forKey:(NSString *)key
{
    [self checkUserDefaults];
    [userDefaults setBool:value forKey:key];
    [userDefaults synchronize];
}

- (void)userDefaultsSetObject:(id) object forKey:(NSString *)key
{
    [self checkUserDefaults];
    [userDefaults setObject:object forKey:key];
    [userDefaults synchronize];
}

//------------------------------------------------------------------//
//                         分割线                              //
//------------------------------------------------------------------//

- (void)bulidIsAppFirst:(BOOL)value
{
    [self userDefaultsSetBool:value forKey:@"isAppFirst"];
}

- (void)buildReqUrl:(NSString *)value
{
    [self userDefaultsSetObject:value forKey:@"reqUrl"];
}
- (void)buildUserName:(NSString *)value
{
    [self userDefaultsSetObject:value forKey:@"userName"];
}

- (void)buildCurrentCity:(NSString *)value
{
    [self userDefaultsSetObject:value forKey:@"currentCity"];
}

- (void)buildTokenWord:(NSString *)value
{
    [self userDefaultsSetObject:value forKey:@"tokenword"];
}

- (void)buildCurrentKey:(NSString *)value
{
    [self userDefaultsSetObject:value forKey:@"currentKey"];
}

- (void)buildCurrentStatus:(NSString *)value
{
    [self userDefaultsSetObject:value forKey:[self currentKey]];
}
- (void)buildCurrentFlag:(NSString *)value
{
    [self userDefaultsSetObject:value forKey:@"currentFlag"];
}
- (void)buildInFlag:(NSString *)value
{
    [self userDefaultsSetObject:value forKey:@"inFlag"];
}

//------------------------------------------------------------------//
//                         邪恶的分割线                              //
//------------------------------------------------------------------//

#pragma mark 设置应用程序是否是首次运行
- (void)setIsAppFirst:(BOOL)mIsAppFirst
{
    [self bulidIsAppFirst:mIsAppFirst];
}

#pragma mark 获取应用程序是否是首次运行
- (BOOL)isAppFirst
{
    [self checkUserDefaults];
    return [userDefaults boolForKey:@"isAppFirst"];
}

#pragma mark 设置服务器地址
- (void)setReqUrl:(NSString *)mreqUrl
{
    [self buildReqUrl:mreqUrl];
}
#pragma mark 获取服务器地址
- (NSString *)reqUrl
{
    [self checkUserDefaults];
    return [userDefaults stringForKey:@"reqUrl"];
}
#pragma mark 设置用户名
- (void)setUserName:(NSString *)username
{
    [self buildUserName:username];
}
#pragma mark 获取用户名
- (NSString *)userName
{
    [self checkUserDefaults];
    return [userDefaults stringForKey:@"userName"];
}
#pragma mark 设置当前城市
- (void)setCurrentCity:(NSString *)currentcity
{
    [self buildCurrentCity:currentcity];
}
#pragma mark 获取当前城市
- (NSString *)currentCity
{
    [self checkUserDefaults];
    return [userDefaults stringForKey:@"currentCity"];
}
#pragma mark 设置token
- (void)setTokenWord:(NSString *)tokenword
{
    [self buildTokenWord:tokenword];
}
#pragma mark 获取token
- (NSString *)tokenWord
{
    [self checkUserDefaults];
    return [userDefaults stringForKey:@"tokenword"];
}

#pragma mark 设置key值
- (void)setCurrentKey:(NSString *)currentkey
{
    [self buildCurrentKey:currentkey];
}
#pragma mark 获取key值
- (NSString *)currentKey
{
    [self checkUserDefaults];
    return [userDefaults stringForKey:@"currentKey"];
}
#pragma mark 设置不同key值状态
- (void)setCurrentStatus:(NSString *)currentstatus
{
    [self buildCurrentStatus:currentstatus];
}
#pragma mark 获取不同key值状态
- (NSString *)currentStatus
{
    [self checkUserDefaults];
    return [userDefaults stringForKey:[self currentKey]];
}
#pragma mark 设置意外flag
- (void)setCurrentFlag:(NSString *)currentflag
{
    [self buildCurrentFlag:currentflag];
}
#pragma mark 获取意外flag
- (NSString *)currentFlag
{
    [self checkUserDefaults];
    return [userDefaults stringForKey:@"currentFlag"];
}
#pragma mark 设置车内连续flag
- (void)setInFlag:(NSString *)inflag
{
    [self buildInFlag:inflag];
}
#pragma mark 设置车内连续flag
- (NSString *)inFlag
{
    [self checkUserDefaults];
    return [userDefaults stringForKey:@"inFlag"];
}

//#pragma mark 设置验证码
//- (void)setNonceStr:(NSString *)noncestr
//{
//    [self buildNoncestr:noncestr];
//}
//#pragma mark 获取验证码
//- (NSString *)nonceStr
//{
//    [self checkUserDefaults];
//    return [userDefaults stringForKey:@"noncestr"];
//}

//------------------------------------------------------------------//
//                         邪恶的分割线                              //
//------------------------------------------------------------------//

#pragma mark 检查配置
- (void)checkAPPConfig
{
    [self checkUserDefaults];
    
    if(![userDefaults objectForKey:@"isAppFirst"]){
        [self setIsAppFirst:YES];
        [self setDefaultAPPConfig];
    }
}
#pragma mark 设置默认数据
- (void)setDefaultAPPConfig
{
    [self checkUserDefaults];
}


@end
