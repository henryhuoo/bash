//
//  bleModel.m
//  bash
//
//  Created by 胡旭 on 16/3/19.
//  Copyright © 2016年 胡旭. All rights reserved.
//

#import "bleModel.h"

@implementation bleModel

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.manufacturerData forKey:@"manufacturerData"];
}


- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        _name = [aDecoder decodeObjectForKey:@"name"];
        _manufacturerData = [aDecoder decodeObjectForKey:@"manufacturerData"];
    }
    
    return self;
}


- (BOOL)connected
{
    return self.peripheral.state == CBPeripheralStateConnected ? YES : NO;
}


@end
