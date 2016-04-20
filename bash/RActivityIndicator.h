//
//  RActivityIndicator.h
//  bash
//
//  Created by 胡旭 on 16/4/1.
//  Copyright © 2016年 胡旭. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RActivityIndicator : NSObject

+ (id)shareInstance;

- (void)startWaitingOverView:(UIView *)view;

- (void)stopWaiting;


@end
