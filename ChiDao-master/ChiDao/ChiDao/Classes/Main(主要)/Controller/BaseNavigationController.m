//
//  BaseNavigationController.m
//  ChiDao
//
//  Created by 赵洋 on 16/5/13.
//  Copyright © 2016年 赵洋. All rights reserved.
//  基类导航控制器,定义了整个工程的UINavigationBar的主题

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    //清空interactivePopGestureRecognizer的delegate可以恢复因替换导航条的back按钮失去系统默认手势
    self.interactivePopGestureRecognizer.delegate = nil;
    //禁止手势冲突
    self.interactivePopGestureRecognizer.enabled = NO;
    
    self.view.backgroundColor = BackgroundColor;

}
+ (void)initialize
{
    
    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedIn:self, nil];
    [bar setBarTintColor:NavBarColor];
    //去掉导航条的半透明
    bar.translucent = NO;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    dict[NSForegroundColorAttributeName] = HexColor(@"#262626");
    
    [bar setTitleTextAttributes:dict];
    
    UIImage *backButtonImage = [[UIImage imageNamed:@"back"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    //将返回按钮的文字position设置不在屏幕上显示
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];

    
}

#pragma mark 重写方法

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count>0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }

    [super pushViewController:viewController animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
