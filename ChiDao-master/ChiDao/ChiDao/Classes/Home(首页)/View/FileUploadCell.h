//
//  FileUploadCell.h
//  ChiDao
//
//  Created by 赵洋 on 16/6/27.
//  Copyright © 2016年 赵洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FileUploadCell : UITableViewCell

@property (nonatomic ,strong)UIImageView *videoImg; //视频截图
@property (nonatomic ,strong)UILabel *titleLabel;   //标题
@property (nonatomic ,strong)UILabel *dateLabel;    //上传日期
@property (nonatomic ,strong)UILabel *sizeLabel;    //视频大小
@property (nonatomic ,strong)UIView *detailView;    //视频上传状态view

@end
