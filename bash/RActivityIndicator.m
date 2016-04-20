//
//  RActivityIndicator.m
//  bash
//
//  Created by 胡旭 on 16/4/1.
//  Copyright © 2016年 胡旭. All rights reserved.
//

#import "RActivityIndicator.h"


#define RActivityRect 50

static RActivityIndicator *_RActivityIndicator;

@interface RActivityIndicator ()
{
    UIActivityIndicatorView *_activityView;
}
@end


@implementation RActivityIndicator

+ (id)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _RActivityIndicator = [[RActivityIndicator alloc] init];
    });
    
    return _RActivityIndicator;
}


- (id)init
{
    if (self = [super init]) {
        _activityView = [[UIActivityIndicatorView alloc] init];
        [_activityView setFrame:CGRectMake(0, 0, RActivityRect, RActivityRect)];
        [_activityView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [_activityView setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)startWaitingOverView:(UIView *)view
{
    
    [_activityView setCenter:CGPointMake(view.frame.origin.x + view.frame.size.width/2, view.frame.origin.y + view.frame.size.height/2)];
    [view addSubview:_activityView];
    [_activityView startAnimating];
}

- (void)stopWaiting
{
    [_activityView stopAnimating];
    [_activityView removeFromSuperview];
}

@end
