//
//  ETCCardInfoCell.h
//  ChiDao
//
//  Created by 赵洋 on 16/8/19.
//  Copyright © 2016年 赵洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ETCCardInfoCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic,strong) UILabel *plateNumLabel;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *cardNumLabel;
@property (nonatomic,strong) UIImageView *cardView;

@end
