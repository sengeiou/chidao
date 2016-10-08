//
//  addCardNoViewController.h
//  ChiDao
//
//  Created by 赵洋 on 16/8/18.
//  Copyright © 2016年 赵洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface addCardNoViewController : UIViewController
@property (nonatomic,copy) void(^addNewCard)(NSDictionary *dataDic);
@end
