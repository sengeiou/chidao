//
//  addCardCell.h
//  ChiDao
//
//  Created by 赵洋 on 16/8/17.
//  Copyright © 2016年 赵洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DashView.h"
@interface addCardCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property(nonatomic,strong) DashView *dashView;
@end
