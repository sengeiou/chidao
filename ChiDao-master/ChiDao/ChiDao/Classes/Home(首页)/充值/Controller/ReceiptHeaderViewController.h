//
//  ReceiptHeaderViewController.h
//  ChiDao
//
//  Created by 赵洋 on 16/8/24.
//  Copyright © 2016年 赵洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol updateReceiptHeaderDelegate<NSObject>

@optional
- (void)getReceiptHeader:(NSString *)str;

@end
@interface ReceiptHeaderViewController : UIViewController<UITextFieldDelegate>
@property (nonatomic,strong)UITextField *sceneName;
@property (nonatomic,weak) id<updateReceiptHeaderDelegate> delegate;
@property (nonatomic,strong)NSString *sstr;
@end
