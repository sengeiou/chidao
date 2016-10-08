//
//  AddressListCell.m
//  ChiDao
//
//  Created by 赵洋 on 16/7/22.
//  Copyright © 2016年 赵洋. All rights reserved.
//

#import "AddressListCell.h"

@implementation AddressListCell
@synthesize nameLabel = _nameLabel;
@synthesize phoneLabel = _phoneLabel;
@synthesize addressLabel = _addressLabel;
@synthesize postcodeLabel = _postcodeLabel;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self creatCell];
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    return self;
}

-(void)creatCell
{
    [self.contentView setBackgroundColor:[UIColor lightGrayColor]];
    for (int i=0;i<4;i++) {
        UILabel *lable=[[UILabel alloc] init];
        lable.frame=CGRectMake(5, 5+i*25, 40, 20);
        
        lable.textColor=[UIColor whiteColor];
        lable.textAlignment = NSTextAlignmentRight;
        lable.font=[UIFont systemFontOfSize:12];
        switch (i) {
            case 0:
                lable.text=@"姓名：";
                break;
            case 1:
                lable.text=@"手机：";
                break;
            case 2:
                lable.text=@"地址：";
                break;
            case 3:
                lable.frame=CGRectMake(5, 85, 40, 20);
                lable.text=@"邮编：";
                break;
            default:
                break;
        }
        [self.contentView addSubview:lable];
    }
    
    for (int j=0;j<4;j++) {
        
        switch (j) {
            case 0:
            {
                self.nameLabel=[[UILabel alloc] init];
                _nameLabel.textAlignment=NSTextAlignmentLeft;
                _nameLabel.textColor=[UIColor whiteColor];
                _nameLabel.font=[UIFont systemFontOfSize:12];
                _nameLabel.frame=CGRectMake(45, 5, myScreenWidth-35, 20);
                [self.contentView addSubview:_nameLabel];
            }
                break;
            case 1:
            {
                self.phoneLabel=[[UILabel alloc] init];
                _phoneLabel.textAlignment=NSTextAlignmentLeft;
                _phoneLabel.textColor=[UIColor whiteColor];
                _phoneLabel.font=[UIFont systemFontOfSize:12];
                _phoneLabel.frame=CGRectMake(45, 30, myScreenWidth-35, 20);
                [self.contentView addSubview:_phoneLabel];
            }
                break;
            case 2:
            {
                self.addressLabel=[[UILabel alloc] init];
                _addressLabel.textAlignment=NSTextAlignmentLeft;
                _addressLabel.textColor=[UIColor whiteColor];
                _addressLabel.font=[UIFont systemFontOfSize:12];
                _addressLabel.frame=CGRectMake(45, 55, myScreenWidth-35, 20);
                [self.contentView addSubview:_addressLabel];
            }
                break;
            case 3:
            {
                self.postcodeLabel=[[UILabel alloc] init];
                _postcodeLabel.textAlignment=NSTextAlignmentLeft;
                _postcodeLabel.textColor=[UIColor whiteColor];
                _postcodeLabel.font=[UIFont systemFontOfSize:12];
                _postcodeLabel.frame=CGRectMake(45, 85, myScreenWidth-35, 20);
                [self.contentView addSubview:_postcodeLabel];
            }
                break;

            default:
                break;
        }
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
