//
//  ETCCardInfoCell.m
//  ChiDao
//
//  Created by 赵洋 on 16/8/19.
//  Copyright © 2016年 赵洋. All rights reserved.
//

#import "ETCCardInfoCell.h"

@interface ETCCardInfoCell(){
    
}
@end
@implementation ETCCardInfoCell
@synthesize plateNumLabel = _plateNumLabel,nameLabel = _nameLabel,cardNumLabel = _cardNumLabel,cardView = _cardView;

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"ETCCardInfoCell";
    ETCCardInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[ETCCardInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createUI];
        
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    return self;
}
- (void)createUI{
    self.backgroundColor = NavBarColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.cardView = [UIImageView new];
    _cardView.image = [UIImage imageNamed:@"ic_card_bg2"];
    [self addSubview:_cardView];
    [_cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (self.mas_top).offset (10);
        make.left.mas_equalTo (self.mas_left).offset (20);
        make.right.mas_equalTo (self.mas_right).offset (-20);
        make.bottom.mas_equalTo (self.mas_bottom).offset (-10);
    }];
    
    UIImageView *cardIcon = [UIImageView new];
    cardIcon.image = [UIImage imageNamed:@"ic_xinlian"];
    [_cardView addSubview:cardIcon];
    [cardIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (_cardView.mas_top).offset (10);
        make.left.mas_equalTo (_cardView.mas_left).offset (10);
        make.width.mas_equalTo(49);
        make.height.mas_equalTo(25);
    }];
    
    UIImageView *iv = [UIImageView new];
    [iv setImage:[UIImage imageNamed:@"whiteline.png"]];
    [_cardView addSubview:iv];
    [iv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (_cardView.mas_top).offset (100);
        make.left.mas_equalTo (_cardView.mas_left);
        make.right.mas_equalTo (_cardView.mas_right);
        make.height.mas_equalTo(1);
    }];
    
    //车牌号
    self.plateNumLabel = [UILabel new];
    _plateNumLabel.font = [UIFont boldSystemFontOfSize:16];
    _plateNumLabel.textColor =[UIColor whiteColor];
    _plateNumLabel.textAlignment = NSTextAlignmentCenter;
//    _plateNumLabel.text = @"鲁F90K71";
    [_cardView addSubview:_plateNumLabel];
    [_plateNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (_cardView.mas_top).offset (50);
        make.left.mas_equalTo (_cardView.mas_left);
        make.width.mas_equalTo (_cardView);
        make.height.mas_equalTo(40);
    }];
    
    //姓名
    self.nameLabel = [UILabel new];
    _nameLabel.font = [UIFont systemFontOfSize:14];
    _nameLabel.textColor =[UIColor whiteColor];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
//    _nameLabel.text = @"测试测试";
    [_cardView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (iv.mas_bottom).offset (10);
        make.left.mas_equalTo (_cardView.mas_left).offset (10);
        make.width.mas_equalTo (60);
        make.height.mas_equalTo(20);
    }];
    
    //卡号
    self.cardNumLabel = [UILabel new];
    _cardNumLabel.font = [UIFont systemFontOfSize:14];
    _cardNumLabel.textColor =[UIColor whiteColor];
    _cardNumLabel.textAlignment = NSTextAlignmentRight;
//    _cardNumLabel.text = @"2222 2222 2222 2222 2222";
    [_cardView addSubview:_cardNumLabel];
    [_cardNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (iv.mas_bottom).offset (10);
        make.left.mas_equalTo (_cardView.mas_left).offset (90);
        make.right.mas_equalTo (_cardView.mas_right).offset (-10);
        make.height.mas_equalTo(20);
    }];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
