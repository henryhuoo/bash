//
//  pageInstructionViewController.m
//  bash
//
//  Created by 胡旭 on 16/3/29.
//  Copyright © 2016年 胡旭. All rights reserved.
//

#import "pageInstructionViewController.h"

@interface pageInstructionViewController ()
{
    UIScrollView *_scrollView;
    UIPageControl *_pageCtrl;
    NSArray *_imageArray;
    NSArray *_titleArray;
    NSArray *_desArray;
    UIButton *_confirmButton;
    UIView *_bgView;
}
@end


@implementation pageInstructionViewController

- (id)initWithImages:(NSArray *)imageArray withTitles:(NSArray *)titleArray withDes:(NSArray *)desArray
{
    if (self = [super init]) {
        _imageArray = imageArray;
        _titleArray = titleArray;
        _desArray = desArray;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColorRGB(0x535353) colorWithAlphaComponent:0.9]];
    
    
//    UIView *alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    [alphaView setBackgroundColor:UIColorRGB(0x535353)];
//    [self.view addSubview:alphaView];
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 252) / 2, (SCREEN_HEIGHT - 363) / 2, 252, 363)];
    
    [_bgView setBackgroundColor:UIColorRGB(0xF2F2F2)];
    
    //设置圆角
    _bgView.layer.cornerRadius = 4;
    _bgView.layer.masksToBounds = YES;
    [self.view addSubview:_bgView];
    
    
    CGRect bounds = _bgView.frame;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, bounds.size.width, bounds.size.height)];
    
    CGFloat width = bounds.size.width * [_imageArray count];
    
    [_scrollView setContentSize:CGSizeMake(width, bounds.size.height)];
    [_scrollView setPagingEnabled:YES];
    [_scrollView setBounces:YES];
    [_scrollView setDelegate:self];
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    [_scrollView setShowsVerticalScrollIndicator:NO];
    [_bgView addSubview:_scrollView];
    
    
    _pageCtrl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 52, 8)];
    [_pageCtrl setCenter:CGPointMake(bounds.size.width / 2, bounds.size.height - 25)];
    _pageCtrl.numberOfPages = [_imageArray count];
    _pageCtrl.currentPage = 0;
    [_pageCtrl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
    [_bgView addSubview:_pageCtrl];
    
    
    for (int i = 0; i < [_imageArray count]; i ++) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i * bounds.size.width, 0, bounds.size.width, bounds.size.height)];
        [_scrollView addSubview:view];
        
        UIImage *image = _imageArray[i];
        UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
        [imgView setFrame:CGRectMake((bounds.size.width - 128)/2, 70, 128, 128)];
        [view addSubview:imgView];
        
        NSString *title = _titleArray[i];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((bounds.size.width - 87)/2, 5, 87, 27)];
        [label setText:title];
        [label setFont:[UIFont systemFontOfSize:_size_S(18)]];
        [label setTextColor:UIColorRGB(0x919192)];
        [label setTextAlignment:NSTextAlignmentCenter];
        [view addSubview:label];
        
        NSString *desStr = _desArray[i];
        UILabel *des = [[UILabel alloc] initWithFrame:CGRectMake((bounds.size.width - 214)/2, 237, 214, 48)];
        [des setText:desStr];
        [des setFont:[UIFont systemFontOfSize:_size_S(12)]];
        [des setTextColor:UIColorRGB(0x919192)];
        [des setNumberOfLines:3];
        [view addSubview:des];
    }
    
    _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_confirmButton setBackgroundColor:UIColorRGB(0x74C2E9)];
    [_confirmButton setFrame:CGRectMake(0, bounds.size.height - 48, bounds.size.width, 48)];
    [_confirmButton setTitle:@"好的，我知道了" forState:UIControlStateNormal];
    [_confirmButton addTarget:self action:@selector(clickConfirm:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)pageTurn:(UIPageControl *)sender
{
    //令UIScrollView做出相应的滑动显示
    CGSize viewSize = _scrollView.frame.size;
    CGRect rect = CGRectMake(sender.currentPage * viewSize.width, 0, viewSize.width, viewSize.height);
    [_scrollView scrollRectToVisible:rect animated:YES];
    
    if (sender.currentPage == [_imageArray count] - 1) {
        _pageCtrl.hidden = YES;
        [_bgView addSubview:_confirmButton];
    } else {
        _pageCtrl.hidden = NO;
        [_confirmButton removeFromSuperview];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //更新UIPageControl的当前页
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.frame;
    NSInteger pageIndex = offset.x / bounds.size.width;
    [_pageCtrl setCurrentPage:pageIndex];
    NSLog(@"%f",offset.x / bounds.size.width);
    
    if (pageIndex == [_imageArray count] - 1) {
        _pageCtrl.hidden = YES;
        [_bgView addSubview:_confirmButton];
    } else {
        _pageCtrl.hidden = NO;
        [_confirmButton removeFromSuperview];
    }
}

- (void)clickConfirm:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [globalFlagInterface setFirstOpenFlagWithVersion:[globalFlagInterface getBundleVersion]];
}

@end
