//
//  ETCReceiptCell.h
//  ChiDao
//
//  Created by 赵洋 on 16/8/22.
//  Copyright © 2016年 赵洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJSwitch.h"

@interface ETCReceiptCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic,strong) ZJSwitch *zSwitch;
@property (nonatomic,copy) void(^openReceipt)(Boolean isOpen);

@property (nonatomic,strong) UILabel *receiptHeader;
@property (nonatomic,strong) UILabel *receiptAddress;
@end
