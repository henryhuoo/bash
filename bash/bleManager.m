//
//  bleManager.m
//  bash
//
//  Created by 胡旭 on 16/3/12.
//  Copyright © 2016年 胡旭. All rights reserved.
//

#import "bleManager.h"
#import "bleManager+control.h"
#import "BLEDeviceViewController.h"

#define BLEMEDUUID @"FFF0"

static bleManager *_bleManager = nil;

@interface bleManager ()
{
    CBCentralManager *_centralManager;
    CBUUID *_defaultDeviceUUID;
    NSMutableArray *_findBLEDevice;
    NSMutableArray *_serviceArray;
    
    NSData *_connectedDevice;
    
    
    NSMutableArray *_sendBLEDataQueue;
    
    NSTimer *_sendDataTricker;
}

@end


@implementation bleManager

@synthesize bleDataService = _bleDataService;
@synthesize connectedBLEModel = _connectedBLEModel;
@synthesize delegate = _delegate;
@synthesize bleDataNotifyCharacteristic = _bleDataNotifyCharacteristic;
@synthesize bleDataWriteCharacteristic = _bleDataWriteCharacteristic;
@synthesize OTADataNotifyCha = _OTADataNotifyCha;
@synthesize OTADataWriteCha = _OTADataWriteCha;

//Discovered service <CBService: 0x13470f810, isPrimary = YES, UUID = 00000001-B5A3-F393-E0A9-E50E24DCCA00>
//iscovered service <CBService: 0x134727920, isPrimary = YES, UUID = 6E400001-B5A3-F393-E0A9-E50E24DCCA9E>
//Discovered service <CBService: 0x13467e930, isPrimary = YES, UUID = Device Information>
//Discovered characteristic <CBCharacteristic: 0x1345ec6c0, UUID = 00000003-B5A3-F393-E0A9-E50E24DCCA00, properties = 0x10, value = (null), notifying = NO>
//Discovered characteristic <CBCharacteristic: 0x1345f56b0, UUID = 00000002-B5A3-F393-E0A9-E50E24DCCA00, properties = 0xC, value = <0501>, notifying = NO>
//Discovered characteristic <CBCharacteristic: 0x1347205d0, UUID = 6E400003-B5A3-F393-E0A9-E50E24DCCA9E, properties = 0x10, value = (null), notifying = NO>
//Discovered characteristic <CBCharacteristic: 0x134720630, UUID = 6E400002-B5A3-F393-E0A9-E50E24DCCA9E, properties = 0xC, value = <0101>, notifying = NO>
//Discovered characteristic <CBCharacteristic: 0x1346e6700, UUID = Manufacturer Name String, properties = 0x2, value = <4e55545f 32303136 2d30332d 30372031 313a3131>, notifying = NO>

//数据传输
+ (CBUUID *)OTAService
{
    return [CBUUID UUIDWithString:@"6E400001-B5A3-F393-E0A9-E50E24DCCA9E"];
}

+ (CBUUID *)OTAService1
{
    return [CBUUID UUIDWithString:@"6E400002-B5A3-F393-E0A9-E50E24DCCA9E"];
}

+ (CBUUID *)OTAService2
{
    return [CBUUID UUIDWithString:@"6E400003-B5A3-F393-E0A9-E50E24DCCA9E"];
}

+ (CBUUID *)dataService
{
    return [CBUUID UUIDWithString:@"00000001-B5A3-F393-E0A9-E50E24DCCA00"];
}

+ (CBUUID *)writeCharacter
{
    return [CBUUID UUIDWithString:@"00000002-B5A3-F393-E0A9-E50E24DCCA00"];
}

+ (CBUUID *)notifyCharacter
{
    return [CBUUID UUIDWithString:@"00000003-B5A3-F393-E0A9-E50E24DCCA00"];
}

+ (CBUUID *)DeviceInfo
{
    return [CBUUID UUIDWithString:@"Device Information"];
}

+ (CBUUID *)DeviceInfoCharacteristic
{
    return [CBUUID UUIDWithString:@"Manufacturer Name String"];
}



+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_bleManager == nil) {
            _bleManager = [[bleManager alloc] init];
        }
    });
    
    return _bleManager;
}


- (id)init
{
    if (self = [super init]) {
        _centralManager = nil;
        _findBLEDevice = [[NSMutableArray alloc] init];
        _sendBLEDataQueue = [[NSMutableArray alloc] init];
        _sendDataTricker = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(sendDataTricker:) userInfo:nil repeats:YES];
        [self loadSaveConnectedDevice];
        [NSTimer scheduledTimerWithTimeInterval:6.0 target:self selector:@selector(stopLaunchScaning) userInfo:nil repeats:NO];
    }
    
    return self;
}

- (void)initCenteralManger
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
    });
}

- (NSMutableArray *)getDeviceList
{
    return _findBLEDevice;
}

- (BOOL)isExistBLEDevice:(CBPeripheral *)peripheral
{
    for (bleModel *model in _findBLEDevice) {
        if ([model.peripheral.identifier isEqual:peripheral.identifier]) {
            return YES;
        }
    }
    
    return NO;
}

- (bleModel *)getExistBLEDevice:(CBPeripheral *)peripheral
{
    for (bleModel *model in _findBLEDevice) {
        if ([model.peripheral.identifier isEqual:peripheral.identifier]) {
            return model;
        }
    }
    
    return nil;
}

- (BOOL)isConnected
{
    for (bleModel *model in _findBLEDevice) {
        if (model.peripheral.state == CBPeripheralStateConnected) {
            return YES;
        }
    }
    
    return NO;
}

- (void)writeBLEData:(NSData *)data
{
    NSLog(@"writeBleData %@", data);
    
    [self appendDataToSendQueue:data];
}

- (void)clearBLEDevice
{
    [_findBLEDevice removeAllObjects];
}

- (void)connectPeripheral:(CBPeripheral *)peripheral withModel:(id)model
{
    //如果是已经连接的，不需要重复连接
    if (peripheral.state == CBPeripheralStateConnected) {
        return;
    }
    
    //建立一个新的连接时，关闭上一个连接
    if (_connectedBLEModel.peripheral.state == CBPeripheralStateConnected) {
        [self disconnect:_connectedBLEModel.peripheral];
    }
    
    
    [_centralManager connectPeripheral:peripheral options:nil];
    _connectedBLEModel = model;
}

- (void)startScan
{
    NSLog(@"startScan");
    if (_centralManager.isScanning == YES) {
        return;
    }
    
//    [_centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:BLEMEDUUID]] options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
    [_centralManager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
    NSLog(@"startScan end");
}


- (void)stopScan
{
    NSLog(@"stopScan");
    [_centralManager stopScan];
}

- (void)disconnect:(CBPeripheral *)peripheral
{
    [_centralManager cancelPeripheralConnection:peripheral];
}

//主动读取
- (void)readValue:(CBPeripheral *)peripheral ForCharacteristic:(CBCharacteristic *)characteristic
{
    NSLog(@"Reading value for characteristic %@", characteristic);
    [peripheral readValueForCharacteristic:characteristic];
}

//订阅服务，有变化会从peripheral主动下发消息
- (void)setNotify:(CBPeripheral *)peripheral ForCharacteristic:(CBCharacteristic *)characteristic
{
    [peripheral setNotifyValue:YES forCharacteristic:characteristic];
}


- (void)writeValue:(CBPeripheral *)peripheral ForCharacteristic:(CBCharacteristic *)characteristic
{
    NSData *data = [NSData dataWithBytes:[@"test" UTF8String] length:@"test".length];

//    当尝试写入特性值时，我们需要指定想要执行的写入类型。上例指定了写入类型是CBCharacteristicWriteWithResponse，表示peripheral让我们的应用知道是否写入成功。
//    
//    指定写入类型为CBCharacteristicWriteWithResponse的peripheral对象，在响应请求时会调用代理对象的peripheral:didWriteValueForCharacteristic:error:方法。如果写入失败，我们可以在这个方法中处理错误信息。
    
    [peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
}


- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSLog(@"Central Update State");
    switch (central.state)
    {
        case CBCentralManagerStatePoweredOn:
        {
            NSLog(@"CBCentralManagerStatePoweredOn");
            [self startScan];
//            [_centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:BLEMEDUUID]] options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
            
        }
            break;
        case CBCentralManagerStatePoweredOff:
        {
            NSLog(@"CBCentralManagerStatePoweredOff");
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"蓝牙提示" message:@"请在设置里面打开蓝牙开关" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 'a';
            
            [alert show];
            
            [self clearBLEDevice];
            
            if ([_delegate respondsToSelector:@selector(updateBLEDevice:)]) {
                [_delegate updateBLEDevice:_findBLEDevice];
            }
            
            
            [[treatManager shareInstance] clearTreat:[[treatManager shareInstance] getTreatingModel]];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:cleanTreatingStatus object:nil];
        }
            break;
        case CBCentralManagerStateUnsupported:
        {
            NSLog(@"CBCentralManagerStateUnsupported");
        }
            break;
        default:
            break;
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"Discover name : %@", peripheral.name);
    
    NSLog(@"advertisementData : %@", advertisementData);
    
    
    if (![peripheral.name isEqualToString:deviceName]) {
        return;
    }
    
    bleModel *model = [_bleManager getExistBLEDevice:peripheral];
    
    if (model == nil) {
        model = [[bleModel alloc] init];
        [_findBLEDevice addObject:model];
    }
    
    
    if (!peripheral.name) {
        model.name = @"未知设备";
    } else {
        model.name = peripheral.name;
    }
    model.RSSI = RSSI;
    model.peripheral = peripheral;
    model.manufacturerData = [advertisementData objectForKey:@"kCBAdvDataManufacturerData"];
    
    
    
    if ([_delegate respondsToSelector:@selector(updateBLEDevice:)]) {
        [_delegate updateBLEDevice:_findBLEDevice];
    }
    
    //for test
    if (peripheral.state == CBPeripheralStateDisconnected && [model.manufacturerData isEqualToData:[self getSaveConnectedDevice]]) {
        [self connectPeripheral:peripheral withModel:model];
    }

}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"Peripheral Connected");
    
    if ([_delegate respondsToSelector:@selector(updateBLEDevice:)]) {
        [_delegate updateBLEDevice:_findBLEDevice];
    }
    
    peripheral.delegate = self;

    [peripheral discoverServices:@[self.class.dataService, self.class.OTAService]];
    
    _bleDataNotifyCharacteristic = nil;
    _bleDataWriteCharacteristic = nil;
    _OTADataWriteCha = nil;
    _OTADataNotifyCha = nil;
    
    [self stopScan];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ConnectPeripheralDevice object:nil userInfo:nil];
}

//连接外设失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error
{
    NSLog(@"%@",error);
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error
{
    [self clearBLEDevice];
    
    if ([_delegate respondsToSelector:@selector(updateBLEDevice:)]) {
        [_delegate updateBLEDevice:_findBLEDevice];
    }
    
    
    [[treatManager shareInstance] clearTreat:[[treatManager shareInstance] getTreatingModel]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:cleanTreatingStatus object:nil];
    
    //如果连接断掉，需要重新扫描设备。
    [self startScan];
//    [_centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:BLEMEDUUID]] options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
    
    NSLog(@"disconnectperipheral");
}

- (void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(NSError *)error
{
    NSLog(@"name %@, rssi %@", peripheral.name, RSSI);
}


#pragma 
#pragma CBPeripheralDelegate

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    for (CBService *service in peripheral.services)
    {
        NSLog(@"Discovered service %@", service);
                
        if ([[service UUID] isEqual:self.class.dataService]) {
            [peripheral discoverCharacteristics:@[self.class.writeCharacter, self.class.notifyCharacter] forService:service];
        } else if ([[service UUID] isEqual:self.class.OTAService]) {
            [peripheral discoverCharacteristics:@[self.class.OTAService1, self.class.OTAService2] forService:service];
        }
    }
    
    
}


- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    for (CBCharacteristic *characteristic in service.characteristics)
    {
        NSLog(@"Discovered characteristic %@", characteristic);
        if ([[characteristic UUID] isEqual:self.class.writeCharacter]) {
            _bleDataWriteCharacteristic = characteristic;
        } else if ([[characteristic UUID] isEqual:self.class.notifyCharacter]) {
            _bleDataNotifyCharacteristic = characteristic;
            [peripheral setNotifyValue:YES forCharacteristic:_bleDataNotifyCharacteristic];
            [peripheral readValueForCharacteristic:characteristic];
        } else if ([[characteristic UUID] isEqual:self.class.OTAService1]) {
            _OTADataWriteCha = characteristic;
        } else if ([[characteristic UUID] isEqual:self.class.OTAService2]) {
            _OTADataNotifyCha = characteristic;
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        }
    }
    
    //第一次连接设备，所有数据准备好在进行数据下载
    if (_bleDataWriteCharacteristic != nil && _bleDataNotifyCharacteristic != nil && _OTADataNotifyCha != nil && _OTADataWriteCha != nil) {
        //for test
        if (![self.connectedBLEModel.manufacturerData isEqual:[self getSaveConnectedDevice]]) {
            [self downloadTreatData];
            [self saveConnectedDevice];
        }
        
        
        //连接成功后需要同步硬件状态
        //for test
        [self getPlayStatus:0];
        
    }
    
}

//主动读取Peripheral服务信息回调
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSData *data = characteristic.value;
    NSLog(@"didUpdateValueForCharacteristic Data = %@", data);
    NSLog(@"%@", characteristic);
    
    
    [self parseBleMessage:data];
    
}

//订阅服务的回调
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error;
{
    if (error)
    {
        NSLog(@"Error changing notification state: %@", [error localizedDescription]);
    }
    
    NSLog(@"didUpdateNotificationStateForCharacteristic");
    if (characteristic.isNotifying) {
        [peripheral readValueForCharacteristic:characteristic];
        
    } else { // Notification has stopped
        // so disconnect from the peripheral
        NSLog(@"Notification stopped on %@.  Disconnecting", characteristic);
        //第一次自动连接完停止扫描
        [_centralManager cancelPeripheralConnection:self.connectedBLEModel.peripheral];
    }
}

//主动写的回调,主要用来判断是否写成功
 - (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error
{
//    ack
    
    NSData *data = characteristic.value;
    NSLog(@"didWriteValueForCharacteristic Data = %@", data);
    NSLog(@"%@", characteristic);
}





#pragma 
#pragma 
- (void)saveConnectedDevice
{
    [[NSUserDefaults standardUserDefaults] setObject:self.connectedBLEModel.manufacturerData forKey:@"connectedDevice"];
}


- (void)loadSaveConnectedDevice
{
    _connectedDevice = [[NSUserDefaults standardUserDefaults] objectForKey:@"connectedDevice"];
}

- (NSData *)getSaveConnectedDevice
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"connectedDevice"];
}

- (void)downloadTreatData
{
    //痛经
    [self setIndexInfo:0x0 hash:0x1101 subnum:0x000a];
    for (int i = 0; i < 10; i++) {
        TreatData data = femaleTreat[i];
        NSData *writeData = [NSData dataWithBytes:&data length:sizeof(data)];
        [self downloadTreatData:writeData];
    }
    
    //腰痛
    [self setIndexInfo:0x1 hash:0x1001 subnum:0x000a];
    for (int i = 0; i < 10; i++) {
        TreatData data = waistTreat[i];
        NSData *writeData = [NSData dataWithBytes:&data length:sizeof(data)];
        [self downloadTreatData:writeData];
    }
}

- (void)sendDataTricker:(id)sender
{
    if ([_sendBLEDataQueue count] == 0) {
        return;
    }
    NSData *data = [_sendBLEDataQueue objectAtIndex:0];
    
    [_connectedBLEModel.peripheral writeValue:data forCharacteristic:_bleDataWriteCharacteristic type:CBCharacteristicWriteWithoutResponse];
    
    [_sendBLEDataQueue removeObjectAtIndex:0];
}

- (void)appendDataToSendQueue:(NSData *)data
{
    NSLog(@"appendDataToSendQueue");
    
    [_sendBLEDataQueue addObject:data];
}

- (int)convertRssiToStrength:(NSNumber *)rssi
{
    int value = [rssi intValue];
    if (value >= -40) {
        return 5;
    } else if (value >= -50) {
        return 4;
    } else if ( value >= -60) {
        return 3;
    } else if ( value >= -80) {
        return 2;
    } else if ( value >= -100){
        return 1;
    } else {
        return 0;
    }
}

- (void)parseBleMessage:(NSData *)data
{
    Byte *rawData = (Byte *)[data bytes];
    
    Byte cmd = rawData[0];
    Byte result = rawData[1];
    
    [self parseBleMessage:cmd withRt:result withRawData:&rawData[2]];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1 && alertView.tag == 'a') {
        [util openBlueTooth];
    } else if (buttonIndex == 0 && alertView.tag == 'b') {
        BLEDeviceViewController *vc = [[BLEDeviceViewController alloc] init];
        vc.title = @"设备连接";
        UIViewController *appRootVC = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        [appRootVC presentViewController:vc animated:YES completion:nil];
    }
}


- (void)stopLaunchScaning
{
//    if (![self isConnected]) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"未找到设备" message:@"进入设备管理手动连接。" delegate:self cancelButtonTitle:@"手动连接" otherButtonTitles:@"逛逛其他", nil];
//        alert.tag = 'b';
//        [alert show];
//    }
}

@end
