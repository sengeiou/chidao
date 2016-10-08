//
//  BankCellView.h
//  Demo_1
//
//  Created by mac on 14-10-24.
//  Copyright (c) 2014年 itazk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HisuntechBankCellView : UIView
@property(nonatomic,retain) UILabel *bankName;//银行名称
@property(nonatomic,retain) UILabel *cardNo;//银行卡号
@property(nonatomic,retain) UIImageView *bankLogo;//银行图标
@property(nonatomic,retain) UIButton *clickBtn;

-(void)buildBankInfoWithName:(NSString*)name andNum:(NSString*)num andURL:(NSString*)url;
@end
