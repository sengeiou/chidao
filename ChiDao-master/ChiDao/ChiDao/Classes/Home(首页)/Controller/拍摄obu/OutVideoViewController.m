//
//  OutVideoViewController.m
//  ChiDao
//
//  Created by 赵洋 on 16/6/23.
//  Copyright © 2016年 赵洋. All rights reserved.
//

#import "OutVideoViewController.h"
#import "WJObuSDK.h"
#import "FileUploadViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

typedef void(^PropertyChangeBlock)(AVCaptureDevice *captureDevice);

@interface OutVideoViewController ()<AVCaptureFileOutputRecordingDelegate,UIAlertViewDelegate>//视频文件输出代理

@property (strong,nonatomic) AVCaptureSession *captureSession;//负责输入和输出设置之间的数据传递
@property (strong,nonatomic) AVCaptureDeviceInput *captureDeviceInput;//负责从AVCaptureDevice获得输入数据
@property (strong,nonatomic) AVCaptureMovieFileOutput *captureMovieFileOutput;//视频输出流
@property (strong,nonatomic) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;//相机拍摄预览图层

@property (strong,nonatomic)  UIView *viewContainer;//视频容器
@property (strong,nonatomic)  UIImageView *focusCursor; //聚焦光标

@end

@implementation OutVideoViewController{
    
    NSMutableArray* urlArray;//保存视频片段的数组
    
    
    
    dispatch_source_t _timer; //计时器5秒
    
    UIView* progressPreView; //进度条
    float progressStep; //进度条每次变短的最小单位
    
    float preLayerWidth;//镜头宽
    float preLayerHeight;//镜头高
    float preLayerHWRate; //高，宽比
    
    UIButton* shootBt;//录制按钮
    
    UIButton* flashBt;//闪光灯
    
    UILabel *alertLabel; //提醒文字
    
}
@synthesize totalTime,currentTime,lightOut2,lightIn2;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromRGB(0x1d1e20);
    self.title = @"车外视频录制";
    self.navigationItem.hidesBackButton = YES;
    
    [[APPConfig getInstance] setCurrentFlag:@"0"];
    
    //默认5秒
    totalTime =5;
    
    urlArray = [[NSMutableArray alloc]init];
    
    preLayerWidth = SCREEN_WIDTH;
    preLayerHeight = SCREEN_WIDTH;
    preLayerHWRate =preLayerHeight/preLayerWidth;
    
    progressStep = SCREEN_WIDTH/totalTime;
    
    [self createVideoFolderIfNotExist];
    [self initCapture];
    
    
}

-(void)initCapture{
    
    //视频高度加进度条（10）高度
    self.viewContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, preLayerWidth, preLayerHeight+10)];
    [self.view addSubview:self.viewContainer];
    
    self.focusCursor = [[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 50, 50)];
    [self.focusCursor setImage:[UIImage imageNamed:@"focusImg"]];
    self.focusCursor.alpha = 0;
    [self.viewContainer addSubview:self.focusCursor];
    
    
    UIView* btView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 86, 86)];
    btView.center = CGPointMake(SCREEN_WIDTH/2, 64+preLayerHeight+20+43);
    [btView makeCornerRadius:43 borderColor:nil borderWidth:0];
    btView.backgroundColor = UIColorFromRGB(0xeeeeee);
    [self.view addSubview:btView];
    
    shootBt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 76, 76)];
    shootBt.center = CGPointMake(43, 43);
    shootBt.backgroundColor = UIColorFromRGB(0xfa5f66);
    [shootBt addTarget:self action:@selector(shootButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [shootBt makeCornerRadius:38 borderColor:UIColorFromRGB(0x28292b) borderWidth:3];
    [btView addSubview:shootBt];
    
    
    //初始化会话
    _captureSession=[[AVCaptureSession alloc]init];
    if ([_captureSession canSetSessionPreset:AVCaptureSessionPreset640x480]) {//设置分辨率
        _captureSession.sessionPreset=AVCaptureSessionPreset640x480;
    }
    
    //获得输入设备
    AVCaptureDevice *captureDevice=[self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];//取得后置摄像头
    //添加一个音频输入设备
    AVCaptureDevice *audioCaptureDevice=[[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
    
    NSError *error=nil;
    //根据输入设备初始化设备输入对象，用于获得输入数据
    _captureDeviceInput=[[AVCaptureDeviceInput alloc]initWithDevice:captureDevice error:&error];
    
    AVCaptureDeviceInput *audioCaptureDeviceInput=[[AVCaptureDeviceInput alloc]initWithDevice:audioCaptureDevice error:&error];
    
    //初始化设备输出对象，用于获得输出数据
    _captureMovieFileOutput=[[AVCaptureMovieFileOutput alloc]init];
    
    //将设备输入添加到会话中
    if ([_captureSession canAddInput:_captureDeviceInput]) {
        [_captureSession addInput:_captureDeviceInput];
        [_captureSession addInput:audioCaptureDeviceInput];
        AVCaptureConnection *captureConnection=[_captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
        if ([captureConnection isVideoStabilizationSupported ]) {
            captureConnection.preferredVideoStabilizationMode=AVCaptureVideoStabilizationModeAuto;
        }
    }
    
    //将设备输出添加到会话中
    if ([_captureSession canAddOutput:_captureMovieFileOutput]) {
        [_captureSession addOutput:_captureMovieFileOutput];
    }
    
    //创建视频预览层，用于实时展示摄像头状态
    _captureVideoPreviewLayer=[[AVCaptureVideoPreviewLayer alloc]initWithSession:self.captureSession];
    
    CALayer *layer= self.viewContainer.layer;
    layer.masksToBounds=YES;
    
    _captureVideoPreviewLayer.frame=  CGRectMake(0, 0, preLayerWidth, preLayerHeight);
    _captureVideoPreviewLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;//填充模式
    [layer insertSublayer:_captureVideoPreviewLayer below:self.focusCursor.layer];
    
    [self addGenstureRecognizer];
    
    
    //提示信息
    alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, preLayerHeight-30,myScreenWidth, 30)];
    alertLabel.backgroundColor = [UIColor clearColor];
    alertLabel.font = [UIFont boldSystemFontOfSize:16];
    alertLabel.textColor = [UIColor redColor];
    alertLabel.textAlignment = NSTextAlignmentCenter;
    [self.viewContainer addSubview:alertLabel];
    
    //进度条
    progressPreView = [[UIView alloc]initWithFrame:CGRectMake(0, preLayerHeight, myScreenWidth, 4)];
    progressPreView.backgroundColor = UIColorFromRGB(0xffc738);
    [progressPreView makeCornerRadius:2 borderColor:nil borderWidth:0];
    [self.viewContainer addSubview:progressPreView];
    
    flashBt = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-60, 5, 54, 54)];
    [flashBt setBackgroundImage:[UIImage imageNamed:@"flashOn"] forState:UIControlStateNormal];
    [flashBt makeCornerRadius:17 borderColor:nil borderWidth:0];
    [flashBt addTarget:self action:@selector(flashBtTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.viewContainer addSubview:flashBt];
    
}
-(void)flashBtTap:(UIButton*)bt{
    if (bt.selected == YES) {
        bt.selected = NO;
        //关闭闪光灯
        [flashBt setBackgroundImage:[UIImage imageNamed:@"flashOn"] forState:UIControlStateNormal];
        [self setTorchMode:AVCaptureTorchModeOff];
    }else{
        bt.selected = YES;
        //开启闪光灯
        [flashBt setBackgroundImage:[UIImage imageNamed:@"flashOff"] forState:UIControlStateNormal];
        [self setTorchMode:AVCaptureTorchModeOn];
    }
}
-(void)back{
    
    dispatch_source_cancel(_timer);
    
    [[APPConfig getInstance] setCurrentFlag:@"1"];
    
    [Tool removeMovFile:@"ios_in"];
    [Tool removeMovFile:@"ios_out"];
    [Tool removeFile:@"ios_in"];
    [Tool removeFile:@"ios_out"];
    
    if (_captureMovieFileOutput.isRecording) {
        [_captureMovieFileOutput stopRecording];
    }
    [self.captureSession stopRunning];
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *viewCtl = self.navigationController.viewControllers[1];
        [self.navigationController popToViewController:viewCtl animated:YES];
    });

    
}

-(void)startTimer{
    
    //obu防拆位是否弹起
    
    //返回：若执行成功，回调的第二个参数返回弹性柱状态，“00”表示压下，“01”表示弹起，“02”表示通信错误。
    
    [[WJObuSDK sharedObuSDK] qryReaderStates:^(BOOL status, id data, NSString *errorMsg) {
        
        switch ([data intValue]) {
            case 00:{
                
                
            }
                
                break;
            case 01:{
                
                [self back];
                
            }
                
                break;
            case 02:{
                [self back];
            }
                
                break;
                
            default:
                break;
        }
        
    }];
    
    
    
}


-(void)finishBtTap{
    
    //正在拍摄
    if (_captureMovieFileOutput.isRecording) {
        [_captureMovieFileOutput stopRecording];
    }
    [self.captureSession stopRunning];
    
    //还原数据-----------
    [self deleteAllVideos];
    
    [progressPreView setFrame:CGRectMake(0, preLayerHeight, 0, 4)];
    shootBt.backgroundColor = UIColorFromRGB(0xfa5f66);
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    uint64_t interval = 1 * NSEC_PER_SEC;
    //创建一个专门执行timer回调的GCD队列
    dispatch_queue_t queue = dispatch_queue_create("my queue", 0);
    //创建Timer
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //使用dispatch_source_set_timer函数设置timer参数
    dispatch_source_set_timer(_timer, dispatch_time(DISPATCH_TIME_NOW, 0), interval, 0);
    //设置回调
    dispatch_source_set_event_handler(_timer, ^()
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            currentTime = totalTime--;
            if (currentTime==0) {
                dispatch_suspend(_timer);
                
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    
                    [[WJObuSDK sharedObuSDK] listenForReaderState:^(BOOL status, id data, NSString *errorMsg) {
                        
                        [self back];
                        
                    }];
                    
                    [[WJObuSDK sharedObuSDK] sendLightNums:lightOut2 index:6 callback:^(BOOL status, id data, NSString *errorMsg) {
                        if (status) {
                            [self finishBtTap];
                        }
                    }];
                });
                
            }
            float progressWidth = progressPreView.frame.size.width-progressStep;
            [progressPreView setFrame:CGRectMake(0, preLayerHeight, progressWidth, 4)];
            alertLabel.text = [NSString stringWithFormat:@"先拍摄车头,(%i)秒后闪灯",(int)currentTime];
            
        });

        
    });
    
    
    [self.captureSession startRunning];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    dispatch_source_cancel(_timer);
    
}

#pragma mark 视频录制
- (void)shootButtonClick{
    
    //根据设备输出获得连接
    
    AVCaptureConnection *captureConnection=[self.captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
    //根据连接取得设备输出的数据
    if (![self.captureMovieFileOutput isRecording]) {
        
        shootBt.backgroundColor = UIColorFromRGB(0xfa5f66);
        //预览图层和视频方向保持一致
        captureConnection.videoOrientation=[self.captureVideoPreviewLayer connection].videoOrientation;
        [self.captureMovieFileOutput startRecordingToOutputFileURL:[NSURL fileURLWithPath:[self getVideoSaveFilePathString]] recordingDelegate:self];
        
        //定时器开始
        shootBt.backgroundColor = UIColorFromRGB(0xf8ad6a);
        //dispatch_source默认是Suspended状态，通过dispatch_resume函数开始它
        dispatch_resume(_timer);
    }
}

#pragma mark - 视频输出代理
-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections{
    
    [self startTimer];
}
-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error{
    
    if ([APPConfig getInstance].currentFlag&&[[APPConfig getInstance].currentFlag isEqualToString:@"1"]) {
        
        
    }else{
        [urlArray addObject:outputFileURL];
        [self mergeAndExportVideosAtFileURLs:urlArray];
    }
}
- (void)mergeAndExportVideosAtFileURLs:(NSMutableArray *)fileURLArray
{
    NSError *error = nil;
    
    CGSize renderSize = CGSizeMake(0, 0);
    
    NSMutableArray *layerInstructionArray = [[NSMutableArray alloc] init];
    
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    
    CMTime totalDuration = kCMTimeZero;
    
    NSMutableArray *assetTrackArray = [[NSMutableArray alloc] init];
    NSMutableArray *assetArray = [[NSMutableArray alloc] init];
    for (NSURL *fileURL in fileURLArray) {
        
        AVAsset *asset = [AVAsset assetWithURL:fileURL];
        [assetArray addObject:asset];
        
        NSArray* tmpAry =[asset tracksWithMediaType:AVMediaTypeVideo];
        if (tmpAry.count>0) {
            AVAssetTrack *assetTrack = [tmpAry objectAtIndex:0];
            [assetTrackArray addObject:assetTrack];
            renderSize.width = MAX(renderSize.width, assetTrack.naturalSize.height);
            renderSize.height = MAX(renderSize.height, assetTrack.naturalSize.width);
        }
    }
    
    CGFloat renderW = MIN(renderSize.width, renderSize.height);
    
    for (int i = 0; i < [assetArray count] && i < [assetTrackArray count]; i++) {
        
        AVAsset *asset = [assetArray objectAtIndex:i];
        AVAssetTrack *assetTrack = [assetTrackArray objectAtIndex:i];
        
        AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        
        NSArray*dataSourceArray= [asset tracksWithMediaType:AVMediaTypeAudio];
        [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                            ofTrack:([dataSourceArray count]>0)?[dataSourceArray objectAtIndex:0]:nil
                             atTime:totalDuration
                              error:nil];
        
        AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        
        [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                            ofTrack:assetTrack
                             atTime:totalDuration
                              error:&error];
        
        AVMutableVideoCompositionLayerInstruction *layerInstruciton = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
        
        totalDuration = CMTimeAdd(totalDuration, asset.duration);
        
        CGFloat rate;
        rate = renderW / MIN(assetTrack.naturalSize.width, assetTrack.naturalSize.height);
        
        CGAffineTransform layerTransform = CGAffineTransformMake(assetTrack.preferredTransform.a, assetTrack.preferredTransform.b, assetTrack.preferredTransform.c, assetTrack.preferredTransform.d, assetTrack.preferredTransform.tx * rate, assetTrack.preferredTransform.ty * rate);
        layerTransform = CGAffineTransformConcat(layerTransform, CGAffineTransformMake(1, 0, 0, 1, 0, -(assetTrack.naturalSize.width - assetTrack.naturalSize.height) / 2.0+preLayerHWRate*(preLayerHeight-preLayerWidth)/2));
        layerTransform = CGAffineTransformScale(layerTransform, rate, rate);
        
        [layerInstruciton setTransform:layerTransform atTime:kCMTimeZero];
        [layerInstruciton setOpacity:0.0 atTime:totalDuration];
        
        [layerInstructionArray addObject:layerInstruciton];
    }
    
    NSString *path = [self getVideoMergeFilePathString];
    NSURL *mergeFileURL = [NSURL fileURLWithPath:path];
    
    AVMutableVideoCompositionInstruction *mainInstruciton = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    mainInstruciton.timeRange = CMTimeRangeMake(kCMTimeZero, totalDuration);
    mainInstruciton.layerInstructions = layerInstructionArray;
    AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoComposition];
    mainCompositionInst.instructions = @[mainInstruciton];
    mainCompositionInst.frameDuration = CMTimeMake(1, 100);
    mainCompositionInst.renderSize = CGSizeMake(renderW, renderW*preLayerHWRate);
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetMediumQuality];
    exporter.videoComposition = mainCompositionInst;
    exporter.outputURL = mergeFileURL;
    exporter.outputFileType = AVFileTypeMPEG4;
    exporter.shouldOptimizeForNetworkUse = YES;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(exporter.status == AVAssetExportSessionStatusCompleted){
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"车外视频录制完毕"delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
                
            }
            
            
        });
    }];
    
    
}
- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    FileUploadViewController *fileVC = [[FileUploadViewController alloc] init];
    [[APPConfig getInstance] setCurrentStatus:@"2"];
    [self.navigationController pushViewController:fileVC animated:YES];
}
//最后合成为 mp4
- (NSString *)getVideoMergeFilePathString
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    
    path = [path stringByAppendingPathComponent:[APPConfig getInstance].currentKey];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *fileName;
    if ([manager fileExistsAtPath:path]){
        fileName = [[path stringByAppendingPathComponent:@"ios_out"] stringByAppendingString:@".mp4"];
    }
    
    return fileName;
}

//录制保存的时候要保存为 mov
- (NSString *)getVideoSaveFilePathString
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    
    path = [path stringByAppendingPathComponent:[APPConfig getInstance].currentKey];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *fileName;
    if ([manager fileExistsAtPath:path]){
        fileName = [[path stringByAppendingPathComponent:@"ios_out"] stringByAppendingString:@".mov"];
    }
    
    return fileName;
}

- (void)createVideoFolderIfNotExist
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    
    NSString *folderPath = [path stringByAppendingPathComponent:[APPConfig getInstance].currentKey];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL isDirExist = [fileManager fileExistsAtPath:folderPath isDirectory:&isDir];
    
    if(!(isDirExist && isDir))
    {
        BOOL bCreateDir = [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
        if(!bCreateDir){
            NSLog(@"创建保存视频文件夹失败");
        }
    }
}
- (void)deleteAllVideos
{
    for (NSURL *videoFileURL in urlArray) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *filePath = [[videoFileURL absoluteString] stringByReplacingOccurrencesOfString:@"file://" withString:@""];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if ([fileManager fileExistsAtPath:filePath]) {
                NSError *error = nil;
                [fileManager removeItemAtPath:filePath error:&error];
                
                if (error) {
                    NSLog(@"delete All Video 删除视频文件出错:%@", error);
                }
            }
        });
    }
    [urlArray removeAllObjects];
}

#pragma mark
-(AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition )position{
    NSArray *cameras= [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameras) {
        if ([camera position]==position) {
            return camera;
        }
    }
    return nil;
}

-(void)changeDeviceProperty:(PropertyChangeBlock)propertyChange{
    AVCaptureDevice *captureDevice= [self.captureDeviceInput device];
    NSError *error;
    //注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁
    if ([captureDevice lockForConfiguration:&error]) {
        propertyChange(captureDevice);
        [captureDevice unlockForConfiguration];
    }else{
        NSLog(@"设置设备属性过程发生错误，错误信息：%@",error.localizedDescription);
    }
}

-(void)setTorchMode:(AVCaptureTorchMode )torchMode{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isTorchModeSupported:torchMode]) {
            [captureDevice setTorchMode:torchMode];
        }
    }];
}

-(void)setFocusMode:(AVCaptureFocusMode )focusMode{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFocusModeSupported:focusMode]) {
            [captureDevice setFocusMode:focusMode];
        }
    }];
}

-(void)setExposureMode:(AVCaptureExposureMode)exposureMode{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isExposureModeSupported:exposureMode]) {
            [captureDevice setExposureMode:exposureMode];
        }
    }];
}

-(void)focusWithMode:(AVCaptureFocusMode)focusMode exposureMode:(AVCaptureExposureMode)exposureMode atPoint:(CGPoint)point{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFocusModeSupported:focusMode]) {
            [captureDevice setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        if ([captureDevice isFocusPointOfInterestSupported]) {
            [captureDevice setFocusPointOfInterest:point];
        }
        if ([captureDevice isExposureModeSupported:exposureMode]) {
            [captureDevice setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        if ([captureDevice isExposurePointOfInterestSupported]) {
            [captureDevice setExposurePointOfInterest:point];
        }
    }];
}

-(void)addGenstureRecognizer{
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapScreen:)];
    [self.viewContainer addGestureRecognizer:tapGesture];
}
-(void)tapScreen:(UITapGestureRecognizer *)tapGesture{
    CGPoint point= [tapGesture locationInView:self.viewContainer];
    //将UI坐标转化为摄像头坐标
    CGPoint cameraPoint= [self.captureVideoPreviewLayer captureDevicePointOfInterestForPoint:point];
    [self setFocusCursorWithPoint:point];
    [self focusWithMode:AVCaptureFocusModeAutoFocus exposureMode:AVCaptureExposureModeAutoExpose atPoint:cameraPoint];
}

-(void)setFocusCursorWithPoint:(CGPoint)point{
    self.focusCursor.center=point;
    self.focusCursor.transform=CGAffineTransformMakeScale(1.5, 1.5);
    self.focusCursor.alpha=1.0;
    [UIView animateWithDuration:1.0 animations:^{
        self.focusCursor.transform=CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.focusCursor.alpha=0;
        
    }];
}

@end

