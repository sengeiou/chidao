//
//  fieldCell.h
//  ChiDao
//
//  Created by 赵洋 on 16/7/21.
//  Copyright © 2016年 赵洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface fieldCell : UITableViewCell
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UITextField *tf;
-(id)initWithStyle:(UITableViewCellStyle)style withIndexPath:(NSIndexPath *)indexpath reuseIdentifier:(NSString *)reuseIdentifier;
@end
