//
//  UpdateNickNameViewController.h
//  ChiDao
//
//  Created by 赵洋 on 16/7/19.
//  Copyright © 2016年 赵洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol updateNickNameDelegate<NSObject>

@optional
- (void)getSceneName:(NSString *)str;

@end
@interface UpdateNickNameViewController : UIViewController<UITextFieldDelegate>
@property (nonatomic,strong)UITextField *sceneName;
@property (nonatomic,weak) id<updateNickNameDelegate> delegate;

@property (nonatomic,strong)NSString *sstr;
@end
