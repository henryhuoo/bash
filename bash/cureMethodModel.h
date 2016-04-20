//
//  cureMethodModel.h
//  bash
//
//  Created by 胡旭 on 16/3/12.
//  Copyright © 2016年 胡旭. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


static int _globalStrong;
@interface cureMethodModel : NSObject

@property (nonatomic, strong) NSString *iconStr;
@property (nonatomic, strong) NSString *CureName;
@property (nonatomic, strong) NSString *CureNum;
@property (nonatomic, strong) NSString *CureTime;
@property (nonatomic, strong) NSString *CureStrength;
@property (nonatomic, assign) TreatType Curing;
@property (nonatomic, assign) float treatTime;//minutes
@property float remainCount;//second
@property int index;
@property TreatData *treatData;
@property int strong;
@property float secondPerDegree;//ms
@end
