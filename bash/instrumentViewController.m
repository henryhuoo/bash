//
//  instrumentViewController.m
//  bash
//
//  Created by 胡旭 on 16/3/30.
//  Copyright © 2016年 胡旭. All rights reserved.
//

#import "instrumentViewController.h"

@interface instrumentViewController ()
{
    UIImage *_image;
    NSString *_title;
    NSString *_des;
    UIView *_bgView;
    UIButton *_confirmButton;
    NSString *_hint;
    
}
@end


@implementation instrumentViewController

- (id)initWithImage:(UIImage *)image withTitle:(NSString *)title withDes:(NSString *)des
{
    if (self = [super init]) {
        _image = image;
        _title = title;
        _des = des;
    }
    
    return self;

}

- (id)initWithImage:(UIImage *)image withTitle:(NSString *)title withDes:(NSString *)des withHint:(NSString *)hint
{
    if (self = [super init]) {
        _image = image;
        _title = title;
        _des = des;
        _hint = hint;
    }
    
    return self;
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColorRGB(0x535353) colorWithAlphaComponent:0.9]];
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 252) / 2, (SCREEN_HEIGHT - 363) / 2, 252, 363)];
    
    [_bgView setBackgroundColor:UIColorRGB(0xF2F2F2)];
    
    //设置圆角
    _bgView.layer.cornerRadius = 4;
    _bgView.layer.masksToBounds = YES;
    [self.view addSubview:_bgView];
    
    
    CGRect bounds = _bgView.frame;
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:_image];
    [imgView setFrame:CGRectMake((bounds.size.width - 107)/2, 128, 107, 154)];
    [_bgView addSubview:imgView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((bounds.size.width - 88)/2, 5, 88, 27)];
    [label setText:_title];
    [label setFont:[UIFont systemFontOfSize:_size_S(18)]];
    [label setTextColor:UIColorRGB(0x919192)];
    [label setTextAlignment:NSTextAlignmentCenter];
    [_bgView addSubview:label];
    
    UILabel *des = [[UILabel alloc] initWithFrame:CGRectMake((bounds.size.width - 210)/2, 56, 210, 48)];
    [des setText:_des];
    [des setFont:[UIFont systemFontOfSize:_size_S(12)]];
    [des setTextColor:UIColorRGB(0x919192)];
    [des setNumberOfLines:5];
    [_bgView addSubview:des];
    
    
    _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_confirmButton setBackgroundColor:UIColorRGB(0x74C2E9)];
    [_confirmButton setFrame:CGRectMake(0, bounds.size.height - 48, bounds.size.width, 48)];
    [_confirmButton setTitle:@"好的，我知道了" forState:UIControlStateNormal];
    [_confirmButton addTarget:self action:@selector(clickConfirm:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_confirmButton];
    
}

- (void)clickConfirm:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    if ([_delegate respondsToSelector:@selector(clickConfirmButton:)]) {
        [_delegate clickConfirmButton:_hint];
    }
}

@end
