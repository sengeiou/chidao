//
//  BluetoothManagerViewController.m
//  ChiDao
//
//  Created by 赵洋 on 16/5/17.
//  Copyright © 2016年 赵洋. All rights reserved.
//

#import "BluetoothManagerViewController.h"
#import <CoreBluetooth/CoreBluetooth.h> 

@interface BluetoothManagerViewController ()<CBCentralManagerDelegate,CBPeripheralDelegate>
{
    
}
@property (nonatomic,strong) CBCentralManager *centralManager;
@property(strong,nonatomic)CBPeripheral *peripheral;
@property (nonatomic,strong) CBCharacteristic *characteristic;
@end

@implementation BluetoothManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    dispatch_queue_t centralQueue = dispatch_queue_create("com.xinlian", DISPATCH_QUEUE_SERIAL);
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:centralQueue];
    
    [self.centralManager scanForPeripheralsWithServices:@[] options:nil];
    
    
}
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    
    switch (central.state) {
            //判断状态开始扫瞄周围设备 第一个参数为空则会扫瞄所有的可连接设备  你可以
            //指定一个CBUUID对象 从而只扫瞄注册用指定服务的设备
            //scanForPeripheralsWithServices方法调用完后会调用代理CBCentralManagerDelegate的
            //- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI方法
        case CBCentralManagerStatePoweredOn:
            [self.centralManager scanForPeripheralsWithServices:@[] options:nil];
            
            break;
            
        default:
            break;
    }
}
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"name:%@",peripheral);
    if (!peripheral || !peripheral.name || ([peripheral.name isEqualToString:@""])) {
        return;
    }
    
    if (!self.peripheral || (self.peripheral.state == CBPeripheralStateDisconnected)) {
        self.peripheral = peripheral;
        self.peripheral.delegate = self;
        NSLog(@"connect peripheral");
        [self.centralManager connectPeripheral:peripheral options:nil];
    }
    
}
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    if (!peripheral) {
        return;
    }
    
    [self.centralManager stopScan];
    
    NSLog(@"peripheral did connect");
    [self.peripheral discoverServices:nil];
    
    
}
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    NSArray *services = nil;
    
    if (peripheral != self.peripheral) {
        NSLog(@"Wrong Peripheral.\n");
        return ;
    }
    
    if (error != nil) {
        NSLog(@"Error %@\n", error);
        return ;
    }
    
    services = [peripheral services];
    if (!services || ![services count]) {
        NSLog(@"No Services");
        return ;
    }
    
    for (CBService *service in services) {
        if ([service.UUID isEqual:[CBUUID UUIDWithString:@"FFE0"]])
        {
            [peripheral discoverCharacteristics:nil forService:service];
        }
        
    }
    
}
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    if (error==nil) {
        //在这个方法中我们要找到我们所需的服务的特性 然后调用setNotifyValue方法告知我们要监测这个服务特性的状态变化
        //当setNotifyValue方法调用后调用代理CBPeripheralDelegate的- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
        for (CBCharacteristic *characteristic in service.characteristics) {
            NSLog(@"characteristic===%@",characteristic.UUID);
            [self.peripheral readValueForCharacteristic:characteristic];
            [self.peripheral setNotifyValue:YES forCharacteristic:characteristic];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if (error==nil) {
        //调用下面的方法后 会调用到代理的- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
        [peripheral readValueForCharacteristic:characteristic];
    }
}


- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    NSData *data = characteristic.value;
    NSLog(@"data===%@",characteristic.value);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
