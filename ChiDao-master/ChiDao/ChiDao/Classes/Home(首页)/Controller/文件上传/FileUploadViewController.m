//
//  FileUploadViewController.m
//  ChiDao
//
//  Created by 赵洋 on 16/6/27.
//  Copyright © 2016年 赵洋. All rights reserved.
//

#import "FileUploadViewController.h"
#import "FileUploadCell.h"
#import "SDProgressView.h"
#import "HisuntechAFNetworking.h"
#import "ActiveViewController.h"
@interface FileUploadViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
    HisuntechAFHTTPRequestOperationManager *manager;
    
    Boolean flagIn;
    Boolean flagOut;
}
@property (nonatomic,strong) UITableView *tb;
@property (nonatomic,strong) UIButton *uploadBtn;
@property (nonatomic,strong) SDPieLoopProgressView * loop;
@property (nonatomic,strong) SDPieLoopProgressView * loop_out;
@end

@implementation FileUploadViewController
@synthesize uploadBtn = _uploadBtn;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"视频上传";
    self.view.backgroundColor = BackgroundColor;
    self.navigationItem.hidesBackButton = YES;
    
    flagIn = NO;
    flagOut = NO;
    
    self.tb = [[UITableView alloc] initWithFrame:CGRectMake(0,0, myScreenWidth-10,200)];
    self.tb.delegate = self;
    self.tb.dataSource = self;
    self.tb.scrollEnabled = NO;
    self.tb.backgroundColor = [UIColor clearColor];
    self.tb.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.tb];
    
    self.uploadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _uploadBtn.backgroundColor = btnColor;
    _uploadBtn.layer.cornerRadius = myCornerRadius;
    _uploadBtn.clipsToBounds = YES;
    [_uploadBtn setTitle:@"上传视频" forState:UIControlStateNormal];
    [_uploadBtn addTarget:self action:@selector(uploadVideoFile) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_uploadBtn];
    
    [_uploadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (self.tb.mas_bottom).offset (20);
        make.left.mas_equalTo (self.view.mas_left).offset (5);
        make.right.mas_equalTo (self.view.mas_right).offset (-5);
        make.height.mas_equalTo (44);
    }];
    
    
}
//上传视频
- (void)uploadVideoFile{
    
    
    if([Tool isExistFile:@"ios_in"]&&[Tool isExistFile:@"ios_out"]){
        
        //按钮不可用
        _uploadBtn.userInteractionEnabled=NO;
        _uploadBtn.alpha=0.4;
        
        FileUploadCell *cell1 = [self.tb cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        self.loop = [SDPieLoopProgressView progressView];
        self.loop.frame = CGRectMake(15, 15, 60, 60);
        [cell1.detailView addSubview:self.loop];
        
        FileUploadCell *cell2 = [self.tb cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        self.loop_out = [SDPieLoopProgressView progressView];
        self.loop_out.frame = CGRectMake(15, 15, 60, 60);
        [cell2.detailView addSubview:self.loop_out];
        
        
        manager = [HisuntechAFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain",@"application/json",nil];
        
        dispatch_group_t group = dispatch_group_create();
        dispatch_group_async(group, dispatch_get_global_queue(0,0), ^{
            // 并行执行的线程一
            MyLog(@"线程1");
            
            NSMutableDictionary *mDic = [Tool getBaseDicWithAppID:@"9000235480" withAPIVersion:@"1.0"];
            [mDic setObject:[NSString stringWithFormat:@"%@", @"3090fcceb96b4f85a6e029329520563c"] forKey:@"token"];
            [mDic setObject:[NSString stringWithFormat:@"%@", @"3701081320651001"] forKey:@"obu_id"];
            
            HisuntechAFHTTPRequestOperation *operation = [manager POST:[NSString stringWithFormat:@"%@%@",BASEURL,OBUUpLoadFileURL]
                                                 
                                    parameters:mDic
                                    constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                        
                                        NSString *appDocumentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                                        NSString *folderPath = [appDocumentPath stringByAppendingPathComponent:[APPConfig getInstance].currentKey];
                                        
                                        NSFileManager *manager1 = [NSFileManager defaultManager];
                                        if ([manager1 fileExistsAtPath:folderPath]){
                                            NSURL *uploadURL = [NSURL fileURLWithPath:[[folderPath stringByAppendingPathComponent:@"ios_in"] stringByAppendingString:@".mp4"]];
                                            
                                            NSData *videoData = [NSData dataWithContentsOfURL:uploadURL];
                                            [formData appendPartWithFileData:videoData name:@"file" fileName:@"ios_in.mp4" mimeType:@"application/octet-stream"];
                                        }
                                        
                                        
                                        
                                        
                                    } success:^(HisuntechAFHTTPRequestOperation *operation, id responseObject) {
                                        //成功后回调
                                        
                                        if ([[responseObject objectForKey:@"code"] isEqualToString:@"000000"]) {
                                            flagIn = YES;
                                            [self.loop dismiss];
                                            
                                            if (flagIn&&flagOut) {
                                                
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    
                                                    
                                                    [Tool showMessage:@"视频上传成功!"];
                                                    ActiveViewController *activeVC = [[ActiveViewController alloc] init];
                                                    [[APPConfig getInstance] setCurrentStatus:@"3"];
                                                    [self.navigationController pushViewController:activeVC animated:YES];
                                                });
                                                
                                                
                                            }
                                            
                                        }
                                        
                                        
                                    } failure:^(HisuntechAFHTTPRequestOperation *operation, NSError *error) {
                                        //失败后回调
                                        [self.loop dismiss];
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            
                                            [Tool showMessage:@"视频上传失败,请重新上传"];
                                            _uploadBtn.userInteractionEnabled=YES;
                                            _uploadBtn.alpha=1;
                                        });
                                        
                                    }];
            
            [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
                //进度
                self.loop.progress = totalBytesWritten*1.0/totalBytesExpectedToWrite; // 加载进度，当加载完成后会自动隐藏
                
                
            }];
            
        });
        dispatch_group_async(group, dispatch_get_global_queue(0,0), ^{
            // 并行执行的线程二
            MyLog(@"线程2");
            NSMutableDictionary *mDic2 = [Tool getBaseDicWithAppID:@"9000235480" withAPIVersion:@"1.0"];
            [mDic2 setObject:[NSString stringWithFormat:@"%@", @"3090fcceb96b4f85a6e029329520563c"] forKey:@"token"];
            [mDic2 setObject:[NSString stringWithFormat:@"%@", @"3701081320651001"] forKey:@"obu_id"];
            HisuntechAFHTTPRequestOperation *operation = [manager POST:[NSString stringWithFormat:@"%@%@",BASEURL,OBUUpLoadFileURL]
                                                 
                                                   parameters:mDic2
                                    constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                        
                                        NSString *appDocumentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                                        NSString *folderPath = [appDocumentPath stringByAppendingPathComponent:[APPConfig getInstance].currentKey];
                                        
                                        NSFileManager *manager1 = [NSFileManager defaultManager];
                                        if ([manager1 fileExistsAtPath:folderPath]){
                                            
                                            NSURL *uploadURL = [NSURL fileURLWithPath:[[folderPath stringByAppendingPathComponent:@"ios_out"] stringByAppendingString:@".mp4"]];
                                            
                                            NSData *videoData = [NSData dataWithContentsOfURL:uploadURL];
                                            [formData appendPartWithFileData:videoData name:@"file" fileName:@"ios_out.mp4" mimeType:@"application/octet-stream"];
                                            
                                            
                                        }
                                        
                                        
                                    } success:^(HisuntechAFHTTPRequestOperation *operation, id responseObject) {
                                        //成功后回调
                                        if ([[responseObject objectForKey:@"code"] isEqualToString:@"000000"]) {
                                            
                                            flagOut = YES;
                                            [self.loop_out dismiss];
                                            
                                            if (flagIn&&flagOut) {
                                                
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    
                                                    
                                                    [Tool showMessage:@"视频上传成功!"];
                                                    
                                                    ActiveViewController *activeVC = [[ActiveViewController alloc] init];
                                                    [[APPConfig getInstance] setCurrentStatus:@"3"];
                                                    [self.navigationController pushViewController:activeVC animated:YES];
                                                });
                                                
                                                
                                            }
                                        }
                                        
                                    } failure:^(HisuntechAFHTTPRequestOperation *operation, NSError *error) {
                                        //失败后回调
                                        [self.loop_out dismiss];
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            
                                            [Tool showMessage:@"视频上传失败,请重新上传"];
                                            _uploadBtn.userInteractionEnabled=YES;
                                            _uploadBtn.alpha=1;
                                        });
                                        
                                    }];
            
            [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
                //进度
                self.loop_out.progress = totalBytesWritten*1.0/totalBytesExpectedToWrite; // 加载进度，当加载完成后会自动隐藏
                
                
            }];
            
        });
        dispatch_group_notify(group, dispatch_get_global_queue(0,0), ^{
            
          
            
        });
        
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"cell";
    
    FileUploadCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[FileUploadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSString *appDocumentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *folderPath = [appDocumentPath stringByAppendingPathComponent:[APPConfig getInstance].currentKey];
    NSFileManager *manager1 = [NSFileManager defaultManager];
    if ([manager1 fileExistsAtPath:folderPath]){
        
        switch (indexPath.row) {
            case 0:{
                cell.titleLabel.text = @"车内视频";
                if ([Tool isExistFile:@"ios_in"]) {
                    cell.dateLabel.text = [Tool getCurrentTime];
                    cell.sizeLabel.text = [NSString stringWithFormat:@"%.1fM",[Tool fileSizeAtInCar]];
                    cell.videoImg.image = [Tool thumbnailImageForVideo:[NSURL fileURLWithPath:[[folderPath stringByAppendingPathComponent:@"ios_in"] stringByAppendingString:@".mp4"]]];
                    
                }
                
            }
                
                break;
            case 1:
            {
                cell.titleLabel.text = @"车外视频";
                if ([Tool isExistFile:@"ios_out"]) {
                    cell.dateLabel.text = [Tool getCurrentTime];
                    cell.sizeLabel.text = [NSString stringWithFormat:@"%.1fM",[Tool fileSizeAtOutCar]];
                    cell.videoImg.image = [Tool thumbnailImageForVideo:[NSURL fileURLWithPath:[[folderPath stringByAppendingPathComponent:@"ios_out"] stringByAppendingString:@".mp4"]]];
                    
                    
                }
                
            }
                
                break;
            default:
                break;
        }
    }
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
    
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
