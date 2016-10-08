//
//  ETCBottomView.m
//  ChiDao
//
//  Created by 赵洋 on 16/8/22.
//  Copyright © 2016年 赵洋. All rights reserved.
//

#import "ETCBottomView.h"
static const CGFloat bottomViewHeight = 44;
@interface ETCBottomView(){
    
}
@property (nonatomic, strong) UIButton *rechargeButton;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, assign) CGFloat money;
@end
@implementation ETCBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, bottomViewHeight);
        self.money = 0;
        [self setUpSubviews];
    }
    return self;
}

- (void)setUpSubviews {
    self.rechargeButton = [UIButton new];
    [self.rechargeButton setBackgroundImage:[self imageWithColor:btnColor] forState:UIControlStateNormal];
    [self.rechargeButton setTitle:@"立即充值" forState:UIControlStateNormal];
    self.rechargeButton.titleLabel.font = [UIFont systemFontOfSize:19];
    [self.rechargeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.rechargeButton addTarget:self action:@selector(rechargeButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.rechargeButton];
    [self.rechargeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (self.mas_top);
        make.right.mas_equalTo (self.mas_right).offset (0);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(bottomViewHeight);
    }];
    
    NSMutableAttributedString *attributeStringM = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"应付：￥%.2f",self.money]];
    [attributeStringM addAttributes:@{ NSForegroundColorAttributeName : kColor_0x666666} range:NSMakeRange(0, 3)];
    [attributeStringM addAttributes:@{ NSForegroundColorAttributeName : btnColor} range:NSMakeRange(3, attributeStringM.length - 3)];
    
    self.moneyLabel = [UILabel new];
    self.moneyLabel.attributedText = attributeStringM;
    self.moneyLabel.font = [UIFont systemFontOfSize:18];
    [self addSubview:self.moneyLabel];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (self.mas_top);
        make.right.mas_equalTo (self.rechargeButton.mas_left).offset (0);
        make.left.mas_equalTo (self.mas_left).offset (20);
        make.height.mas_equalTo(bottomViewHeight);
    }];
    
    //注册修改应付金额的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetMoney:) name:@"CD_resetmoney" object:nil];
}
- (void)rechargeButtonDidClicked{
    
}
- (void)resetMoney:(NSNotification *)notify{
    
    NSString *resetMoney = [notify object];
    NSMutableAttributedString *attributeStringM = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"应付：￥%.2f",[resetMoney floatValue]]];
    [attributeStringM addAttributes:@{ NSForegroundColorAttributeName : kColor_0x666666} range:NSMakeRange(0, 3)];
    [attributeStringM addAttributes:@{ NSForegroundColorAttributeName : btnColor} range:NSMakeRange(3, attributeStringM.length - 3)];
    self.moneyLabel.attributedText = attributeStringM;
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - 颜色转换为背景图片
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
