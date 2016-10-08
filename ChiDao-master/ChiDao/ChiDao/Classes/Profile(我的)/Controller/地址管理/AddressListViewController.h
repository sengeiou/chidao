//
//  AddressListViewController.h
//  ChiDao
//
//  Created by 赵洋 on 16/7/20.
//  Copyright © 2016年 赵洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressListViewController : UIViewController
@property (nonatomic,strong) NSString *flag; //0 代表隐藏nav  1代表不隐藏nav
@property (nonatomic,copy) void (^chooseAddress)(NSString *address);
@end
