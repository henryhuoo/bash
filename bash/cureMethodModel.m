//
//  cureMethodModel.m
//  bash
//
//  Created by 胡旭 on 16/3/12.
//  Copyright © 2016年 胡旭. All rights reserved.
//

#import "cureMethodModel.h"

@implementation cureMethodModel

- (NSString *)CureStrength
{
    return [NSString stringWithFormat:@"强度：%d", self.strong];
}

- (NSString *)CureTime
{
    
    return [NSString stringWithFormat:@"%g分钟", self.treatTime / 60];
}


- (void)setStrong:(int)strong
{
    if (strong == 100) {
        NSLog(@"bingo");
    }
    NSLog(@"setStrong %d", strong);
//    _globalStrong = strong;
    
    
    if (strong > 100 || strong < 0) {
        return;
    }
    
    [globalFlagInterface saveGlobalStrong:strong];
}

- (int)strong
{
//    return _globalStrong;
    return [globalFlagInterface getGlobalStrong];
}


@end
