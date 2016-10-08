//
//  fieldCell.m
//  ChiDao
//
//  Created by 赵洋 on 16/7/21.
//  Copyright © 2016年 赵洋. All rights reserved.
//

#import "fieldCell.h"
#import "UITextField+LimitLength.h"
@interface fieldCell ()<UITextFieldDelegate>
{
    
}
@end
@implementation fieldCell
@synthesize titleLabel = _titleLabel;
@synthesize tf = _tf;

-(id)initWithStyle:(UITableViewCellStyle)style withIndexPath:(NSIndexPath *)indexpath reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.titleLabel = [UILabel new];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(5, 20, 5, myScreenWidth-120));
        }];
        
        self.tf = [UITextField new];
        [self.tf setBackgroundColor:[UIColor clearColor]];
        self.tf.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.tf.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [self.tf setReturnKeyType:UIReturnKeyDone];
        [self.tf setFont:[UIFont systemFontOfSize:16]];
        switch (indexpath.row) {
            case 0:
                self.tf.placeholder = @"请输入收货人姓名";
                [self.tf limitTextLength:16];
                [self.tf setKeyboardType:UIKeyboardTypeDefault];
                [self.tf setDelegate:self];
                [self addSubview:self.tf];
                break;
            case 1:
                self.tf.placeholder = @"请输入手机号";
                [self.tf limitTextLength:11];
                [self.tf setKeyboardType:UIKeyboardTypeNumberPad];
                [self.tf setDelegate:self];
                [self addSubview:self.tf];
                break;
            case 2:{
                
                self.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
                self.tf.hidden = YES;
                [self addSubview:self.tf];
                
            }
                break;
            case 3:
                self.tf.placeholder = @"请输入详细地址";
                [self.tf limitTextLength:34];
                [self.tf setKeyboardType:UIKeyboardTypeDefault];
                [self.tf setDelegate:self];
                [self addSubview:self.tf];
                break;
            case 4:
                self.tf.placeholder = @"请输入邮政编码";
                [self.tf limitTextLength:6];
                [self.tf setKeyboardType:UIKeyboardTypeNumberPad];
                [self.tf setDelegate:self];
                [self addSubview:self.tf];
                
                break;
                
            default:
                break;
        }
        [_tf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(5, 120, 5, 20));
        }];
        
        
        
        
        
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField*)textField {
    [self.tf resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}
@end
