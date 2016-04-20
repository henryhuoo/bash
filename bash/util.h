//
//  util.h
//  bash
//
//  Created by 胡旭 on 16/3/22.
//  Copyright © 2016年 胡旭. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface util : NSObject

+ (NSString *)getDocPath;

+ (char *)convertString:(char *)string length:(int)length;

+ (int)convertMinutes:(int)time;

+ (int)convertSeconds:(int)time;

+ (void)openBlueTooth;

@end
