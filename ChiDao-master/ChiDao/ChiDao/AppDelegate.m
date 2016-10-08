//
//  AppDelegate.m
//  ChiDao
//
//  Created by 赵洋 on 16/5/12.
//  Copyright © 2016年 赵洋. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "UIImage+Extension.h"
#import "BaseNavigationController.h"
#import "ServiceViewController.h"
#import "ProfileViewController.h"

#import "iProtect.h"
@interface AppDelegate ()
{
    
}
@property (nonatomic,strong) UITabBarController *tabBarController;

@end

@implementation AppDelegate
@synthesize baseDic;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // 通过 appId、 appKey 、appSecret 启动SDK，注：该方法需要在主线程中调用
    [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:self];
    
    // 注册APNS
    [self registerUserNotification];
    
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.baseDic = [[NSMutableDictionary alloc] init];
    self.tabBarController = [[UITabBarController alloc] init];
    [self.tabBarController.tabBar setBarTintColor:NavBarColor];
    
    iProtectInitialize();
    
    HomeViewController *v1 = [[HomeViewController alloc] init];
    [self addOneChildVc:v1 title:@"驰道" imageName:@"main_home" selectedImageName:@"main_home_s"];
    
    ServiceViewController *v2 = [[ServiceViewController alloc] init];
    [self addOneChildVc:v2 title:@"服务" imageName:@"main_service" selectedImageName:@"main_service_s"];
    
    ProfileViewController *v3 = [[ProfileViewController alloc] init];
    [self addOneChildVc:v3 title:@"我的" imageName:@"main_profile" selectedImageName:@"main_profile_s"];
    
    [self.window setRootViewController:self.tabBarController];
    [self.window makeKeyAndVisible];
    return YES;
    
}

/**
 *  添加一个子控制器
 *
 *  @param childVC           子控制对象
 *  @param title             标题
 *  @param imageName         图标
 *  @param selectedImageName 选中时的图标
 */
-(void)addOneChildVc:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    //随机设置子控制器的背景颜色
    childVc.view.backgroundColor=[UIColor clearColor];
    //设置标题
    childVc.title = title;
    //设置图标
    childVc.tabBarItem.image=[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];;
    
    //设置选中时的图标
    UIImage *selectedImage=[UIImage imageWithName:selectedImageName];
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.selectedImage = selectedImage;
    
    //设置tab的text颜色
    [childVc.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kkColor(157, 158, 159),NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kkColor(244, 98, 44),NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:childVc];
    if ([title isEqualToString:@"我的"]) {
        [nav setNavigationBarHidden:YES animated:YES];
    }
    //添加子控制器到tabbar
    [self.tabBarController addChildViewController:nav];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
} 

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark - 用户通知(推送) _自定义方法

/** 注册用户通知 */
- (void)registerUserNotification {
    
    /*
     注册通知(推送)
     申请App需要接受来自服务商提供推送消息
     */
    
    // 判读系统版本是否是“iOS 8.0”以上
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ||
        [UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        
        // 定义用户通知类型(Remote.远程 - Badge.标记 Alert.提示 Sound.声音)
        UIUserNotificationType types = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        
        // 定义用户通知设置
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        
        // 注册用户通知 - 根据用户通知设置
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else { // iOS8.0 以前远程推送设置方式
        // 定义远程通知类型(Remote.远程 - Badge.标记 Alert.提示 Sound.声音)
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        
        // 注册远程通知 -根据远程通知类型
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
}

#pragma mark - 用户通知(推送)回调 _IOS 8.0以上使用

/** 已登记用户通知 */
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    // 注册远程通知（推送）
    [application registerForRemoteNotifications];
}

#pragma mark - 远程通知(推送)回调

/** 远程通知注册成功委托 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"\n>>>[DeviceToken Success]:%@\n\n", token);
    
    // [3]:向个推服务器注册deviceToken
    [GeTuiSdk registerDeviceToken:token];
}

/** 远程通知注册失败委托 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"\n>>>[DeviceToken Error]:%@\n\n", error.description);
}

#pragma mark - APP运行中接收到通知(推送)处理

/** APP已经接收到“远程”通知(推送) - (App运行在后台/App运行在前台) */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    application.applicationIconBadgeNumber = 0; // 标签
    
    NSLog(@"\n>>>[Receive RemoteNotification]:%@\n\n", userInfo);
}

/** APP已经接收到“远程”通知(推送) - 透传推送消息  */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    
    // 处理APN
    NSLog(@"\n>>>[Receive RemoteNotification - Background Fetch]:%@\n\n", userInfo);
    
    completionHandler(UIBackgroundFetchResultNewData);
}
- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    /// Background Fetch 恢复SDK 运行
    [GeTuiSdk resume];
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark - GeTuiSdkDelegate

/** SDK启动成功返回cid */
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    // [4-EXT-1]: 个推SDK已注册，返回clientId
    NSLog(@"\n>>>[GeTuiSdk RegisterClient]:%@\n\n", clientId);
}

/** SDK遇到错误回调 */
- (void)GeTuiSdkDidOccurError:(NSError *)error {
    // [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    NSLog(@"\n>>>[GexinSdk error]:%@\n\n", [error localizedDescription]);
}

/** SDK收到透传消息回调 */
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    //收到个推消息
    NSString *payloadMsg = nil;
    if (payloadData) {
        payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes
                                              length:payloadData.length
                                            encoding:NSUTF8StringEncoding];
    }
    
    NSString *msg = [NSString stringWithFormat:@"taskId=%@,messageId:%@,payloadMsg:%@%@",taskId,msgId, payloadMsg,offLine ? @"<离线消息>" : @""];
    NSLog(@"\n>>>[GexinSdk ReceivePayload]:%@\n\n", msg);
    
    /**
     *汇报个推自定义事件
     *actionId：用户自定义的actionid，int类型，取值90001-90999。
     *taskId：下发任务的任务ID。
     *msgId： 下发任务的消息ID。
     *返回值：BOOL，YES表示该命令已经提交，NO表示该命令未提交成功。注：该结果不代表服务器收到该条命令
     **/
//    [GeTuiSdk sendFeedbackMessage:90001 taskId:taskId msgId:msgId];
    
}

@end
