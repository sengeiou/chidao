//
//  QuickPayItemCell.h
//  Demo_1
//
//  Created by allen on 14-9-23.
//  Copyright (c) 2014年 itazk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HisuntechQuickPayItemCell : UITableViewCell{
    
    UILabel *_cardNo;//银行卡号
    UIImageView *_bankLogo;//银行图标
}

@property(nonatomic,retain) UILabel *cardNo;//银行卡号
@property(nonatomic,retain) UIImageView *bankLogo;//银行图标

//- (void)changeArrowWithUp:(BOOL)up;


@end
