//
//  addCardCell.m
//  ChiDao
//
//  Created by 赵洋 on 16/8/17.
//  Copyright © 2016年 赵洋. All rights reserved.
//

#import "addCardCell.h"

@interface addCardCell ()
{
    
}
@end
@implementation addCardCell
@synthesize dashView = _dashView;

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"addCardCell";
    addCardCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[addCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.dashView = [DashView new];
        [_dashView.imageV_IDCard.layer addSublayer:_dashView.shapeLayer];
        [_dashView addSubview:_dashView.imageV_IDCard];
        [_dashView addSubview:_dashView.addCard];
        [self addSubview:_dashView];
        [_dashView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo (self.mas_top).offset (20);
            make.left.mas_equalTo (self.mas_left).offset (20);
            make.right.mas_equalTo (self.mas_right).offset (-20);
            make.bottom.mas_equalTo (self.mas_bottom).offset (-20);
        }];
        
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}

@end
