//
//  ETCReceiptCell.m
//  ChiDao
//
//  Created by 赵洋 on 16/8/22.
//  Copyright © 2016年 赵洋. All rights reserved.
//

#import "ETCReceiptCell.h"
#import "CZAUIView+Gesture.h"
static UITableView *tb;
@interface ETCReceiptCell()<UITextFieldDelegate>
{
    UIImageView *iv;
    UIImageView *iv2;
    Boolean isopen;
}
@end
@implementation ETCReceiptCell
@synthesize zSwitch = _zSwitch,receiptHeader = _receiptHeader,receiptAddress=_receiptAddress;

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"ETCReceiptCell";
    ETCReceiptCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    tb = tableView;
    if (cell == nil) {
        cell = [[ETCReceiptCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
    
    UILabel *lb1 = [UILabel new];
    lb1.text = @"是否开具发票";
    [self addSubview:lb1];
    [lb1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (self.mas_top).offset (10);
        make.left.mas_equalTo (self.mas_left).offset (20);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo (35);
    }];
    
    self.zSwitch = [ZJSwitch new];
    _zSwitch.backgroundColor = [UIColor clearColor];
    _zSwitch.tintColor = NavBarColor;
    _zSwitch.onTintColor = btnColor;
    _zSwitch.onText = @"是";
    _zSwitch.offText = @"否";

    [_zSwitch addTarget:self action:@selector(handleSwitchEvent:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_zSwitch];
    [_zSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (self.mas_top).offset (10);
        make.right.mas_equalTo (self.mas_right).offset (-20);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo (35);
    }];
    
}
- (void)handleSwitchEvent:(id)sender
{
    if (_zSwitch.on) {
        
        //进行cell扩展
        if (self.openReceipt) {
            self.openReceipt(YES);
        }
        [self createOpenUI];
        
    }else{
        
        //进行cell收缩
        if (self.openReceipt) {
            self.openReceipt(NO);
        }
        [self removeOpenUI];
    }
    [tb reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:2];
    [tb scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
-(void)createOpenUI{
    
    self.receiptHeader = [UILabel new];
    [_receiptHeader setBackgroundColor:[UIColor clearColor]];
    _receiptHeader.textColor = kkColor(186, 185, 193);
    _receiptHeader.tag= 100;
    [_receiptHeader setTextAlignment:NSTextAlignmentLeft];
    _receiptHeader.userInteractionEnabled = YES;
    [_receiptHeader addTapGesture:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CD_goHeader" object:nil];
    }];
    [self addSubview:_receiptHeader];
    [_receiptHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (_zSwitch.mas_bottom).offset (10);
        make.left.mas_equalTo (self.mas_left).offset (20);
        make.right.mas_equalTo (self.mas_right).offset (-20);
        make.height.mas_equalTo (44);
    }];
    
    iv = [UIImageView new];
    [iv setImage:[UIImage imageNamed:@"line.png"]];
    [self addSubview:iv];
    [iv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (_receiptHeader.mas_bottom);
        make.left.mas_equalTo (self.mas_left).offset (20);
        make.right.mas_equalTo (self.mas_right).offset (-20);
        make.height.mas_equalTo (0.5);
    }];
    
    
    self.receiptAddress = [UILabel new];
    [_receiptAddress setBackgroundColor:[UIColor clearColor]];
    _receiptAddress.textColor = kkColor(186, 185, 193);
    _receiptAddress.tag= 101;
    [_receiptAddress setTextAlignment:NSTextAlignmentLeft];
    _receiptAddress.userInteractionEnabled = YES;
    [_receiptAddress addTapGesture:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CD_goAddress" object:nil];
    }];
    [self addSubview:_receiptAddress];
    [_receiptAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (iv.mas_bottom);
        make.left.mas_equalTo (self.mas_left).offset (20);
        make.right.mas_equalTo (self.mas_right).offset (-20);
        make.height.mas_equalTo (44);
    }];
    
    iv2 = [UIImageView new];
    [iv2 setImage:[UIImage imageNamed:@"line.png"]];
    [self addSubview:iv2];
    [iv2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (_receiptAddress.mas_bottom);
        make.left.mas_equalTo (self.mas_left).offset (20);
        make.right.mas_equalTo (self.mas_right).offset (-20);
        make.height.mas_equalTo (0.5);
    }];
}
-(void)removeOpenUI{
    
    [_receiptHeader removeFromSuperview];
    [iv removeFromSuperview];
    [_receiptAddress removeFromSuperview];
    [iv2 removeFromSuperview];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
