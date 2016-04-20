//
//  globalFlagInterface.h
//  bash
//
//  Created by 胡旭 on 16/3/29.
//  Copyright © 2016年 胡旭. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface globalFlagInterface : NSObject

+ (NSString *)getBundleVersion;
+ (BOOL)isFirstOpenFlagWithVersion:(NSString *)ver;
+ (void)setFirstOpenFlagWithVersion:(NSString *)ver;

+ (BOOL)isFirstOpenTreatShoulderWithVersion:(NSString *)ver;
+ (void)setFirstOpenTreatShoulderWithVersion:(NSString *)ver;

+ (BOOL)isFirstOpenTreatLumbarWithVersion:(NSString *)ver;
+ (void)setFirstOpenTreatLumbarWithVersion:(NSString *)ver;

+ (BOOL)isFirstOpenTreatAlgomenorrheaWithVersion:(NSString *)ver;
+ (void)setFirstOpenTreatAlgomenorrheaWithVersion:(NSString *)ver;

+ (BOOL)isFirstOpenTreatWithVersion:(NSString *)ver withPart:(NSString *)part;
+ (void)setFirstOpenTreatWithVersion:(NSString *)ver withPart:(NSString *)part;


//第一次连接设备
+ (BOOL)isFirstOpenDeviceWithVersion:(NSString *)ver;
+ (void)setFirstOpenDeviceWithVersion:(NSString *)ver;

+ (BOOL)getRemoteNotificationOpenStatus;


+ (int)getGlobalStrong;
+ (BOOL)saveGlobalStrong:(int)strong;

@end
