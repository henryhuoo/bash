//
//  bleModel.h
//  bash
//
//  Created by 胡旭 on 16/3/19.
//  Copyright © 2016年 胡旭. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface bleModel : NSObject <NSCoding>
@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSNumber *RSSI;
@property (nonatomic, assign)BOOL connected;
@property (nonatomic, strong)CBPeripheral *peripheral;
@property NSData *manufacturerData;
@end
