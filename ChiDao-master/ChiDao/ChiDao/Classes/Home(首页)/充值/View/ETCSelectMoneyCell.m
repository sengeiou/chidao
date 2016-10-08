//
//  ETCSelectMoneyCell.m
//  ChiDao
//
//  Created by 赵洋 on 16/8/19.
//  Copyright © 2016年 赵洋. All rights reserved.
//

#import "ETCSelectMoneyCell.h"
static UITableView *tb;
@interface ETCSelectMoneyCell()<UITextFieldDelegate>
{
    NSString *money;
    NSArray *moneyArr;
}
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIButton *lastButton;
@property (nonatomic, strong) UITextField *tf;

@end
@implementation ETCSelectMoneyCell
@synthesize tf = _tf;
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"ETCSelectMoneyCell";
    tb = tableView;
    ETCSelectMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[ETCSelectMoneyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.detailLabel = [UILabel new];
        self.detailLabel.text = @"请选择充值金额";
        self.detailLabel.font = [UIFont systemFontOfSize:14];
        self.detailLabel.textColor =kColor_0x666666;
        [self addSubview:self.detailLabel];
        [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo (self.mas_top).offset (5);
            make.left.mas_equalTo (self.mas_left).offset (20);
            make.right.mas_equalTo (self.mas_right).offset (-10);
            make.height.mas_equalTo(30);
        }];
        
        [self createUI];
        
        
        
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    return self;
}
- (void)createUI{
    
    // 循环创建按钮
    CGFloat buttonBgViewLeftRightPadding = 20;
    UIView *buttonsBgView = [UIView new];
    buttonsBgView.frame = CGRectMake(buttonBgViewLeftRightPadding, CGRectGetMaxY(self.detailLabel.frame) + 40, myScreenWidth - 2 * buttonBgViewLeftRightPadding, 38*2+18);
    [self.contentView addSubview:buttonsBgView];
    
    CGFloat top_bottom_padding = 13;
    CGFloat left_rignt_padding = 21;
    NSInteger buttonCountInARow = 3;
    CGFloat buttonWidth = (buttonsBgView.frame.size.width - (buttonCountInARow - 1) * left_rignt_padding) / buttonCountInARow * 1.0f;
    CGFloat buttonHeight = 38;
    
    UIButton *lastButton;
    moneyArr = @[@"¥100",@"¥500",@"¥1000",@"¥2000",@"¥3000",@"¥5000"];
    
    for (int i = 0; i < 6; i ++) {
        
        NSInteger row = i / buttonCountInARow;
        NSInteger column = i % buttonCountInARow;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.cornerRadius = 5.0f;
        button.layer.masksToBounds = YES;
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        button.layer.borderWidth = 1.0f;
        button.tag = 50+i;
        button.frame = CGRectMake(column * (buttonWidth + left_rignt_padding), row * (buttonHeight + top_bottom_padding), buttonWidth, buttonHeight);
        [button setTitle:[moneyArr objectAtIndex:i] forState:UIControlStateNormal];

        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
         [button setBackgroundImage:[self imageWithColor:btnColor] forState:UIControlStateSelected];
        
        [button addTarget:self action:@selector(moneyButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        [buttonsBgView addSubview:button];
        
        lastButton = button;
    }

    
    
    UILabel *otherLabel = [UILabel new];
    otherLabel.font = [UIFont systemFontOfSize:14];
    otherLabel.textColor =kColor_0x666666;
    otherLabel.text = @"其他充值金额";
    [self addSubview:otherLabel];
    [otherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (buttonsBgView.mas_bottom).offset (5);
        make.left.mas_equalTo (self.mas_left).offset (20);
        make.width.mas_equalTo (90);
        make.height.mas_equalTo(40);
    }];
    
    self.tf = [UITextField new];
    [self.tf setBackgroundColor:[UIColor clearColor]];
    self.tf.tag = 103;
    [self.tf setPlaceholder:@"请输入100的整数倍"];
    self.tf.borderStyle = UITextBorderStyleRoundedRect;
    self.tf.layer.borderWidth = 1.0f;
    self.tf.layer.cornerRadius = 5.0f;
    self.tf.layer.masksToBounds = YES;
    self.tf.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.tf.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.tf.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.tf setReturnKeyType:UIReturnKeyDone];
    [self.tf setFont:[UIFont systemFontOfSize:14]];
    [self.tf setKeyboardType:UIKeyboardTypeNumberPad];
    [self.tf setDelegate:self];
    [self addSubview:self.tf];
    [self.tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (buttonsBgView.mas_bottom).offset (5);
        make.left.mas_equalTo (otherLabel.mas_right).offset (10);
        make.right.mas_equalTo (self.mas_right).offset (-20);
        make.height.mas_equalTo(40);
    }];
}
- (void)moneyButtonDidClicked:(UIButton *)button {
   
    if (button.selected) {
        return;
    }
    button.selected = YES;
    button.layer.borderWidth = 0.0f;
    self.lastButton.selected = NO;
    self.lastButton.layer.borderWidth = 1.0f;
    self.lastButton = button;
    
    if (self.lastButton.selected) {
        money = [[moneyArr objectAtIndex:self.lastButton.tag-50] substringFromIndex:1];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CD_resetmoney"
                                                        object:money];
    
    
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

#pragma mark - 屏幕上弹
-(void)textFieldDidBeginEditing:(UITextField *)textField
{

    if (textField.tag ==103) {
        //键盘高度216
        //滑动效果（动画）
        NSTimeInterval animationDuration = 0.30f;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        
        //将视图的Y坐标向上移动，以使下面腾出地方用于软键盘的显示
        tb.frame = CGRectMake(0.0f, -216.0f,tb.frame.size.width, tb.frame.size.height);//64-216
        
        [UIView commitAnimations];
    }

}

#pragma mark -屏幕恢复
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag ==103) {
        //滑动效果
        NSTimeInterval animationDuration = 0.30f;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        
        //恢复屏幕
        tb.frame = CGRectMake(0.0f, 0.0f, tb.frame.size.width, tb.frame.size.height);//64-216
        
        [UIView commitAnimations];
        
        //
        money = self.tf.text;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CD_resetmoney"
                                                            object:money];
    }

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
