//
//  FileUploadCell.m
//  ChiDao
//
//  Created by 赵洋 on 16/6/27.
//  Copyright © 2016年 赵洋. All rights reserved.
//

#import "FileUploadCell.h"

@implementation FileUploadCell

@synthesize videoImg,titleLabel,dateLabel,sizeLabel,detailView;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        videoImg = [UIImageView new];
        [self addSubview:videoImg];
        [videoImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(10, 5, 10, myScreenWidth-90));
        }];
        
        titleLabel = [UILabel new];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(5, 100, 100-35, 90));
        }];

        dateLabel = [UILabel new];
        dateLabel.backgroundColor = [UIColor clearColor];
        dateLabel.font = [UIFont boldSystemFontOfSize:10];
        dateLabel.textColor = [UIColor lightGrayColor];
        dateLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:dateLabel];
        [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(35, 100, 35, 90));
        }];
        
        sizeLabel = [UILabel new];
        sizeLabel.backgroundColor = [UIColor clearColor];
        sizeLabel.font = [UIFont boldSystemFontOfSize:16];
        sizeLabel.textColor = [UIColor grayColor];
        sizeLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:sizeLabel];
        [sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(65, 100, 5, 90));
        }];
        
        detailView = [UIView new];
        detailView.userInteractionEnabled = YES;
        [self addSubview:detailView];
        [detailView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(5, myScreenWidth-90, 5, 0));
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
