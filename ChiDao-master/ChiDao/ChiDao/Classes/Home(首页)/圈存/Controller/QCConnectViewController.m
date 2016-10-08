//
//  QCConnectViewController.m
//  ChiDao
//
//  Created by 赵洋 on 16/8/3.
//  Copyright © 2016年 赵洋. All rights reserved.
//

#import "QCConnectViewController.h"
#import "BabyBluetooth.h"
#import "TransferenceSDK.h"
#import "SVProgressHUD.h"
#import "QCViewController.h"

@interface QCConnectViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *peripherals;
    BabyBluetooth *baby;
}
@property (nonatomic,strong) UITableView *tb;
@end

@implementation QCConnectViewController

- (void)addNavButton{
    
    
    UIButton *stopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    stopBtn.frame = CGRectMake(0, 20, 100, 46);
    [stopBtn setTitle:@"停止搜索" forState:UIControlStateNormal];
    [stopBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [stopBtn addTarget:self action:@selector(stopScan) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *stopItem = [[UIBarButtonItem alloc] initWithCustomView:stopBtn];
    self.navigationItem.rightBarButtonItem = stopItem;
}
- (void)stopScan{
    //停止扫描
    [baby cancelScan];
    //停止之前的连接
    [baby cancelAllPeripheralsConnection];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"圈存";
    self.view.backgroundColor = [UIColor whiteColor];
    [self addNavButton];
    
    self.tb = [[UITableView alloc] initWithFrame:CGRectMake(5,10, myScreenWidth-10,myScreenHeight-10)];
    self.tb.delegate = self;
    self.tb.dataSource = self;
    self.tb.scrollEnabled = NO;
    self.tb.backgroundColor = [UIColor clearColor];
    
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, myScreenWidth-10, 20)];
    lb.text = @"请选择需要连接的设备";
    lb.font = [UIFont systemFontOfSize:16];
    lb.textAlignment = NSTextAlignmentLeft;
    self.tb.tableHeaderView = lb;
    
    self.tb.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.tb];
    
    peripherals = [[NSMutableArray alloc]init];
    //初始化BabyBluetooth 蓝牙库
    baby = [BabyBluetooth shareBabyBluetooth];
    baby.scanForPeripherals().begin();
    //设置蓝牙委托
    [self babyDelegate];
}
#pragma mark -蓝牙配置和操作

//蓝牙网关初始化和委托方法设置
-(void)babyDelegate{
    
    __weak typeof(self) weakSelf = self;
    [baby setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
        if (central.state == CBCentralManagerStatePoweredOn) {
            [SVProgressHUD showInfoWithStatus:@"设备打开成功，开始扫描设备"];
        }else{
            [SVProgressHUD showInfoWithStatus:@"请打开设备蓝牙"];
        }
    }];
    
    //设置扫描到设备的委托
    [baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSLog(@"搜索到了设备:%@",peripheral.name);
        [weakSelf insertTableView:peripheral advertisementData:advertisementData];
    }];
    
    
    //设置查找设备的过滤器
    [baby setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
        
        //最常用的场景是查找某一个前缀开头的设备
        //        if ([peripheralName hasPrefix:@"Pxxxx"] ) {
        //            return YES;
        //        }
        //        return NO;
        
        //设置查找规则是名称大于0 ， the search rule is peripheral.name length > 0
        if (peripheralName.length >0) {
            return YES;
        }
        return NO;
    }];
    
    
    [baby setBlockOnCancelAllPeripheralsConnectionBlock:^(CBCentralManager *centralManager) {
        NSLog(@"setBlockOnCancelAllPeripheralsConnectionBlock");
    }];
    
    [baby setBlockOnCancelScanBlock:^(CBCentralManager *centralManager) {
        NSLog(@"setBlockOnCancelScanBlock");
    }];
    
    
    /*设置babyOptions
     
     参数分别使用在下面这几个地方，若不使用参数则传nil
     - [centralManager scanForPeripheralsWithServices:scanForPeripheralsWithServices options:scanForPeripheralsWithOptions];
     - [centralManager connectPeripheral:peripheral options:connectPeripheralWithOptions];
     - [peripheral discoverServices:discoverWithServices];
     - [peripheral discoverCharacteristics:discoverWithCharacteristics forService:service];
     
     该方法支持channel版本:
     [baby setBabyOptionsAtChannel:<#(NSString *)#> scanForPeripheralsWithOptions:<#(NSDictionary *)#> connectPeripheralWithOptions:<#(NSDictionary *)#> scanForPeripheralsWithServices:<#(NSArray *)#> discoverWithServices:<#(NSArray *)#> discoverWithCharacteristics:<#(NSArray *)#>]
     */
    
    //示例:
    //扫描选项->CBCentralManagerScanOptionAllowDuplicatesKey:忽略同一个Peripheral端的多个发现事件被聚合成一个发现事件
    NSDictionary *scanForPeripheralsWithOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@YES};
    //连接设备->
    [baby setBabyOptionsWithScanForPeripheralsWithOptions:scanForPeripheralsWithOptions connectPeripheralWithOptions:nil scanForPeripheralsWithServices:nil discoverWithServices:nil discoverWithCharacteristics:nil];
    
    
}

#pragma mark -UIViewController 方法
//插入table数据
-(void)insertTableView:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData{
    if(![peripherals containsObject:peripheral]) {
        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:peripherals.count inSection:0];
        [indexPaths addObject:indexPath];
        [peripherals addObject:peripheral];
        [self.tb insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return peripherals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"cell";
    CBPeripheral *peripheral = [peripherals objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = peripheral.name;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
    
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //停止扫描
    [baby cancelScan];
    
    [self.tb deselectRowAtIndexPath:indexPath animated:YES];
    CBPeripheral *peripheral = [peripherals objectAtIndex:indexPath.row];
    //连接设备进入寻卡界面
    
    [[TransferenceSDK sharedClient] connectDeviceWithName:peripheral.name
                                              withAddress:peripheral.identifier.UUIDString complete:^(NSString *status) {
                                                  
                                                  if ([status isEqualToString:@"0"]) {
                                                      [SVProgressHUD showSuccessWithStatus:@"连接设备成功"];
                                                      QCViewController *qcVC = [[QCViewController alloc] init];
                                                      [self.navigationController pushViewController:qcVC animated:YES];
                                                      
                                                  }else{
                                                      [SVProgressHUD showErrorWithStatus:@"连接设备失败"];
                                                  }
                                              }];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
