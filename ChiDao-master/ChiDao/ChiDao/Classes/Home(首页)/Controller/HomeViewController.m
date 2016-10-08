//
//  HomeViewController.m
//  ChiDao
//
//  Created by 赵洋 on 16/5/12.
//  Copyright © 2016年 赵洋. All rights reserved.
//

#import "HomeViewController.h"
#import "TestSdkViewController.h"
#import <SDCycleScrollView.h>
#import "SCButtonsView.h"
#import "SCButton.h"
#import "Masonry.h"
#import <BXAutoRollLabel/BXAutoRollLabel.h>
#import "YMCitySelect.h"
#import "ConnectionOBUViewController.h"
#import "UIButton+UIButtonImageWithLable.h"
#import <CoreLocation/CoreLocation.h>
#import "QCConnectViewController.h"
#import "ReChargeViewController.h"

@interface HomeViewController ()<SDCycleScrollViewDelegate,SCButtonsViewDelegate,BXAutoRollLabelDataSource,BXAutoRollLabelDelegate,YMCitySelectDelegate,CLLocationManagerDelegate>{
    
    UIScrollView *mainScrollView;
    UIButton *LocationBtn;
    
}
@property (nonatomic) BXAutoRollLabel *autoRollLabel;
@property (nonatomic, strong) CLLocationManager* locationManager;
@end

@implementation HomeViewController


- (void)addNavButton{
    UIButton *qrBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    qrBtn.frame = CGRectMake(0, 0, 30, 30);
    [qrBtn setImage:[UIImage imageNamed:@"qr.png"] forState:UIControlStateNormal];
    [qrBtn addTarget:self action:@selector(qrCode) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *qrItem = [[UIBarButtonItem alloc] initWithCustomView:qrBtn];
    self.navigationItem.rightBarButtonItem = qrItem;
    
    LocationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    LocationBtn.frame = CGRectMake(0, 0, 85, 30);
    [LocationBtn setImage:[UIImage imageNamed:@"location.png"] withTitle:@"" forState:UIControlStateNormal];
    [LocationBtn addTarget:self action:@selector(locationCity) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *LocationItem = [[UIBarButtonItem alloc] initWithCustomView:LocationBtn];
    self.navigationItem.leftBarButtonItem = LocationItem;
    
}
- (void)AutoLocationCity{
    //检测定位功能是否开启
    if([CLLocationManager locationServicesEnabled]){
        if(!_locationManager){
            self.locationManager = [[CLLocationManager alloc] init];
            if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
                
                [self.locationManager requestWhenInUseAuthorization];
                [self.locationManager requestAlwaysAuthorization];
            }
            //设置代理
            [self.locationManager setDelegate:self];
            //设置定位精度
            [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
            //设置距离筛选
            [self.locationManager setDistanceFilter:100];
            //开始定位
            [self.locationManager startUpdatingLocation];
            //设置开始识别方向
            [self.locationManager startUpdatingHeading];
        }
    }else{
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil
                                                             message:@"您没有开启定位功能"
                                                            delegate:nil
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil, nil];
        [alertView show];
    }
}
#pragma mark - CLLocationManangerDelegate
//定位成功以后调用
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    [self.locationManager stopUpdatingLocation];
    CLLocation* location = locations.lastObject;
    [self reverseGeocoder:location];
}

#pragma mark Geocoder
//反地理编码
- (void)reverseGeocoder:(CLLocation *)currentLocation {
    
    CLGeocoder* geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if(error || placemarks.count == 0){
            NSLog(@"error = %@",error);
        }else{
            
            CLPlacemark* placemark = placemarks.firstObject;
            [LocationBtn setImage:[UIImage imageNamed:@"location.png"] withTitle:[[placemark addressDictionary] objectForKey:@"City"] forState:UIControlStateNormal];
            
            [[APPConfig getInstance] setCurrentCity:[[placemark addressDictionary] objectForKey:@"City"]];
            
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self AutoLocationCity];
    //解决SDCycleScrollView遇到带有UINavigationController的页面上图片总是向下位移一段
    [self.view addSubview:[[UIView alloc] init]];
    
    //UIScrollView 设置
    WS(ws);
    mainScrollView = [UIScrollView new];
    mainScrollView.showsVerticalScrollIndicator = NO;
    
    if (iPhone4) {
        mainScrollView.contentSize = CGSizeMake(myScreenWidth, 1.1*myScreenHeight);
        
    }
    
    mainScrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:mainScrollView];
    [mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(ws.view);
        make.size.mas_equalTo(ws.view);
    }];
    
    
    
    NSArray *imagesURLStrings = @[
                                  @"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
                                  @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                                  @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"
                                  ];
    
    SDCycleScrollView *cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, myScreenWidth, 180) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    cycleScrollView2.currentPageDotImage = [UIImage imageNamed:@"pageControlCurrentDot"];
    cycleScrollView2.pageDotImage = [UIImage imageNamed:@"pageControlDot"];
    [mainScrollView addSubview:cycleScrollView2];
    
    //         --- 模拟加载延迟
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        cycleScrollView2.imageURLStringsGroup = imagesURLStrings;
    });
    
    // block监听点击方式
     cycleScrollView2.clickItemOperationBlock = ^(NSInteger index) {
        NSLog(@">>>>>  %ld", (long)index);
     };
    

    
    
//  小驰头条
    UIImageView *bannerView = [UIImageView new];
    [bannerView setImage:[UIImage imageNamed:@"banner"]];
    [mainScrollView addSubview:bannerView];
    [bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@197);
        make.left.equalTo(@20);
        make.width.equalTo(@96);
        make.height.equalTo(@16);
    }];
    
//  广告布局
    self.autoRollLabel = [[BXAutoRollLabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.autoRollLabel.visibleAmount = 2;
    self.autoRollLabel.dataSource = self;
    self.autoRollLabel.delegate = self;
    self.autoRollLabel.backgroundColor = HexColor(@"#cccccc");
    self.autoRollLabel.direction = BXAutoRollDirectionUp;
    [mainScrollView addSubview:self.autoRollLabel];
    [self.autoRollLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cycleScrollView2.mas_bottom);
        make.right.equalTo(cycleScrollView2.mas_right);
        make.width.equalTo(@(myScreenWidth-136));
        make.height.equalTo(@50);
    }];
    [self.autoRollLabel startAutoRoll];
//  九宫格布局
    
    SCButtonsView *buttonsView = [[SCButtonsView alloc] initWithFrame:CGRectMake(0, 240,myScreenWidth,200)];
    buttonsView.delegate = self;
    [mainScrollView addSubview:buttonsView];
    
    //添加左右item
    [self addNavButton];
}
//定位城市
- (void)locationCity{
    
    [self presentViewController:[[YMCitySelect alloc] initWithDelegate:self] animated:YES completion:nil];
}
#pragma mark YMCitySelectDelegate
-(void)ym_ymCitySelectCityName:(NSString *)cityName{
    [self dismissViewControllerAnimated:YES completion:^{
        [LocationBtn setImage:[UIImage imageNamed:@"location.png"] withTitle:cityName forState:UIControlStateNormal];
        [[APPConfig getInstance] setCurrentCity:cityName];
        
    }];
}
//二维码扫描
- (void)qrCode{
    
}
- (void)jihuo{
    TestSdkViewController *bleVC = [[TestSdkViewController alloc] init];
    [self.navigationController pushViewController:bleVC animated:YES];
    
}
#pragma mark SCButtonsViewDelegate
- (NSInteger)numberOfButtonsInButtonsView:(SCButtonsView *)buttonsView {
    return 6;
}

- (UIButton *)buttonsView:(SCButtonsView *)buttonsView buttonAtIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            SCButton *button = [SCButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@"圈存" forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"btn_qc"] forState:UIControlStateNormal];
            button.tag = 20+index;
            [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            return button;
        }
            break;
        case 1:
        {
            SCButton *button = [SCButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@"充值" forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"btn_cz"] forState:UIControlStateNormal];
            button.tag = 20+index;
            [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            return button;
        }
            break;
        case 2:
        {
            SCButton *button = [SCButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@"余额" forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"btn_ye"] forState:UIControlStateNormal];
            button.tag = 20+index;
            [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            return button;
        }
            break;
        case 3:
        {
            SCButton *button = [SCButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@"查询" forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"btn_cx"] forState:UIControlStateNormal];
            button.tag = 20+index;
            [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            return button;
        }
            break;
        case 4:
        {
            SCButton *button = [SCButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@"激活" forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"btn_jh"] forState:UIControlStateNormal];
            button.tag = 20+index;
            [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            return button;
        }
            break;
        case 5:
        {
            SCButton *button = [SCButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@"" forState:UIControlStateNormal];
            button.tag = 20+index;
            [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            return button;
        }
            break;
        default:
        {
            return nil;
        }
            break;
    }
    
}
- (void)clickBtn:(id)sender{
    switch ([sender tag]-20) {
        case 0:
        {
            
            QCConnectViewController *qcVC = [[QCConnectViewController alloc] init];
            [self.navigationController pushViewController:qcVC animated:NO];
            
        }
            break;
        case 1:
        {
            //充值
            ReChargeViewController *reVC = [[ReChargeViewController alloc] init];
            [self.navigationController pushViewController:reVC animated:NO];
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            
        }
            break;
        case 4:
        {
           //[self jihuo];
            
            //激活
            ConnectionOBUViewController *connectVC = [[ConnectionOBUViewController alloc] init];
            [self.navigationController pushViewController:connectVC animated:NO];
            
        }
            break;
        case 5:
        {
            
        }
            break;
        default:
            break;
    }
}
#pragma mark BXAutoRollLabelDataSource
- (NSInteger)numberOfLabelsInAutoRollLabel:(BXAutoRollLabel *)autoRollLabel
{
    return 4;
}

- (NSString *)titleForLabelsInAutoRollLabel:(BXAutoRollLabel *)autoRollLabel atIndex:(NSInteger)index
{
    return [NSString stringWithFormat:@"消息 %ld", (long)index];
}

#pragma mark BXAutoRollLabelDelegate

- (void)labelTapped:(BXAutoRollLabel *)autoRollLabel index:(NSInteger)index
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"消息" message:[NSString stringWithFormat:@"%ld", (long)index] preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
    }]];
    [self presentViewController:alertController animated:true completion:nil];
}

- (UILabel *)labelStyle:(BXAutoRollLabel *)autoRollLabel index:(NSInteger)index
{
    UILabel *patternLabel = [[UILabel alloc] init];
    patternLabel.textColor = [UIColor blackColor];
    patternLabel.textAlignment = NSTextAlignmentLeft;
    return patternLabel;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
