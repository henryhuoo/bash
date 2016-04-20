//
//  globalFlagInterface.m
//  bash
//
//  Created by 胡旭 on 16/3/29.
//  Copyright © 2016年 胡旭. All rights reserved.
//

#import "globalFlagInterface.h"

@implementation globalFlagInterface


+ (NSString *)getBundleVersion
{
    NSDictionary *dic =[[NSBundle mainBundle ]infoDictionary];
    NSString *appVersion = [dic valueForKey:@"CFBundleVersion"];//获取Bundle Version
    return appVersion;
}


+ (BOOL)isFirstOpenDeviceWithVersion:(NSString *)ver
{
    NSString *key = [NSString stringWithFormat:@"%@_device", ver];
    return [[NSUserDefaults standardUserDefaults] objectForKey:key] == nil ? YES : NO;
}

+ (void)setFirstOpenDeviceWithVersion:(NSString *)ver
{
    NSString *key = [NSString stringWithFormat:@"%@_device", ver];
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:key];
}


+ (BOOL)isFirstOpenFlagWithVersion:(NSString *)ver
{
    NSString *key = [NSString stringWithFormat:@"%@_open", ver];
    return [[NSUserDefaults standardUserDefaults] objectForKey:key] == nil ? YES : NO;
}

+ (void)setFirstOpenFlagWithVersion:(NSString *)ver
{
    NSString *key = [NSString stringWithFormat:@"%@_open", ver];
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:key];
}

+ (BOOL)isFirstOpenTreatShoulderWithVersion:(NSString *)ver
{
    NSString *key = [NSString stringWithFormat:@"%@_treatShoulder", ver];
    return [[NSUserDefaults standardUserDefaults] objectForKey:key] == nil ? YES : NO;
}

+ (void)setFirstOpenTreatShoulderWithVersion:(NSString *)ver
{
    NSString *key = [NSString stringWithFormat:@"%@_treatShoulder", ver];
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:key];
}

+ (BOOL)isFirstOpenTreatLumbarWithVersion:(NSString *)ver
{
    NSString *key = [NSString stringWithFormat:@"%@_treatLumbar", ver];
    return [[NSUserDefaults standardUserDefaults] objectForKey:key] == nil ? YES : NO;
}

+ (void)setFirstOpenTreatLumbarWithVersion:(NSString *)ver
{
    NSString *key = [NSString stringWithFormat:@"%@_treatLumbar", ver];
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:key];
}


+ (BOOL)isFirstOpenTreatAlgomenorrheaWithVersion:(NSString *)ver
{
    NSString *key = [NSString stringWithFormat:@"%@_treatAlgomenorrhea", ver];
    return [[NSUserDefaults standardUserDefaults] objectForKey:key] == nil ? YES : NO;
}

+ (void)setFirstOpenTreatAlgomenorrheaWithVersion:(NSString *)ver
{
    NSString *key = [NSString stringWithFormat:@"%@_treatAlgomenorrhea", ver];
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:key];
}

+ (BOOL)getRemoteNotificationOpenStatus
{
    UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
    if (setting.types == UIUserNotificationTypeNone) {
        return NO;
    }
    
    return YES;
}


+ (BOOL)isFirstOpenTreatWithVersion:(NSString *)ver withPart:(NSString *)part
{
    NSString *key = [NSString stringWithFormat:@"%@_treat%@", ver, part];
    return [[NSUserDefaults standardUserDefaults] objectForKey:key] == nil ? YES : NO;
}
+ (void)setFirstOpenTreatWithVersion:(NSString *)ver withPart:(NSString *)part
{
    NSString *key = [NSString stringWithFormat:@"%@_treat%@", ver, part];
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:key];
}


+ (BOOL)saveGlobalStrong:(int)strong
{
    NSNumber *value = [NSNumber numberWithInt:strong];
    
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:@"globalStrong"];
    return YES;
}

+ (int)getGlobalStrong
{
    NSNumber *value = [[NSUserDefaults standardUserDefaults] objectForKey:@"globalStrong"];
    return [value intValue];
}



@end
