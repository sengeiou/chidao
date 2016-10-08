//
//  QuickCreditPayCell.h
//  Demo_1
//
//  Created by allen on 14-9-23.
//  Copyright (c) 2014年 itazk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HisuntechQuickCreditPayCell : UITableViewCell{
    
    UIButton *_btnSelect;//点击按钮
    UILabel *_creditPay;//信用卡支付
    UIImageView *_arrowImageView;//打开
}
@property(nonatomic,retain) UIButton *btnSelect;//点击按钮
@property(nonatomic,retain) UILabel *creditPay;//信用卡支付
@property(nonatomic,retain) UIImageView *arrowImageView;//打开

- (void)changeArrowWithUp:(BOOL)up;



@end
