//
//  SoftwareFunctionViewController.m
//  bash
//
//  Created by 胡旭 on 16/3/14.
//  Copyright © 2016年 胡旭. All rights reserved.
//

#import "SoftwareFunctionViewController.h"

#define CELLHEIGHT 50


@interface SoftwareFunctionViewController ()
{
    UITableView *_table;
    NSMutableArray *_dataSource;
}
@end

@implementation SoftwareFunctionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.navigationItem.title = @"软件功能";
    
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    
    _table.dataSource = self;
    _table.delegate = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    _table.backgroundColor = UIColorRGB(0xF1F2F3);
    
    [self.view addSubview:_table];
    
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Icon Arrow Left"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(popVc)];
    
    [self.navigationItem setLeftBarButtonItem:item];
    
    _dataSource = [NSMutableArray arrayWithObjects:@"notify", @"ring", @"vibrate", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)popVc
{
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else  {
        return 2;
    }
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    NSInteger row = [indexPath row];
    NSInteger section = [indexPath section];
    
    if (section == 0) {
        UILabel *LBNotify = [[UILabel alloc] initWithFrame:CGRectMake(20, (CELLHEIGHT - _size_S(16))/2, _size_W(80), _size_S(16))];
        
        [LBNotify setText:@"新消息推送"];
        [LBNotify setTextColor:UIColorRGB(0x555454)];
        [LBNotify setFont:[UIFont systemFontOfSize:_size_S(16)]];
        [cell.contentView addSubview:LBNotify];
        
        NSString *buttonSwitch = @"";
        if ([treatManager shareInstance].isOpenNotify) {
            buttonSwitch = @"已开启";
        } else {
            buttonSwitch = @"已关闭";
        }
        
        UILabel *LBSwitch = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 20 - _size_W(40), (CELLHEIGHT - _size_S(13))/2, _size_W(40), 14)];
        [LBSwitch setText:buttonSwitch];
        [LBSwitch setTextColor:UIColorRGB(0xAEAEAE)];
        [LBSwitch setFont:[UIFont systemFontOfSize:_size_S(13)]];
        [cell.contentView addSubview:LBSwitch];
        
        
    } else if (section == 1 && row == 0) {
        UILabel *LBNotify = [[UILabel alloc] initWithFrame:CGRectMake(20, (CELLHEIGHT - _size_S(16))/2, _size_W(80), _size_S(16))];
        
        [LBNotify setText:@"铃声"];
        [LBNotify setTextColor:UIColorRGB(0x555454)];
        [LBNotify setFont:[UIFont systemFontOfSize:_size_S(16)]];
        [cell.contentView addSubview:LBNotify];
        
        NSString *ringImage = @"";
        if ([treatManager shareInstance].isRing) {
            ringImage = @"Icon Toggle On";
        } else {
            ringImage = @"Icon Toggle Off";
        }
        
        UIButton *BTRing = [UIButton buttonWithType:UIButtonTypeCustom];
        [BTRing setBackgroundImage:[UIImage imageNamed:ringImage] forState:UIControlStateNormal];
        [BTRing setFrame:CGRectMake(SCREEN_WIDTH - 20 - 54, (CELLHEIGHT - 34)/2, 54, 34)];
        [BTRing addTarget:self action:@selector(actionClickRing) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:BTRing];

        
        
        
    } else if (section == 1 && row == 1) {
        UILabel *LBNotify = [[UILabel alloc] initWithFrame:CGRectMake(20, (CELLHEIGHT - _size_S(16))/2, _size_W(80), _size_S(16))];
        
        [LBNotify setText:@"震动"];
        [LBNotify setTextColor:UIColorRGB(0x555454)];
        [LBNotify setFont:[UIFont systemFontOfSize:_size_S(16)]];
        [cell.contentView addSubview:LBNotify];
        
        
        NSString *vibrateImage = @"";
        if ([treatManager shareInstance].isVibrate) {
            vibrateImage = @"Icon Toggle On";
        } else {
            vibrateImage = @"Icon Toggle Off";
        }
        
        UIButton *BTVibrate = [UIButton buttonWithType:UIButtonTypeCustom];
        [BTVibrate setBackgroundImage:[UIImage imageNamed:vibrateImage] forState:UIControlStateNormal];
        [BTVibrate setFrame:CGRectMake(SCREEN_WIDTH - 20 - 54, (CELLHEIGHT - 34)/2, 54, 34)];
        [BTVibrate addTarget:self action:@selector(actionClickVibrate) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:BTVibrate];
    }
    
    
    
    
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CELLHEIGHT - 1, SCREEN_WIDTH, 1)];
    line.backgroundColor = UIColorRGB(0xF2F2F2);
    [cell.contentView addSubview:line];
    
    return cell;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *background = [[UIView alloc] initWithFrame:CGRectZero];
    if (section == 1) {
        [background setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 52)];
        UILabel *des = [[UILabel alloc] initWithFrame:CGRectMake(19, 10, SCREEN_WIDTH - 19*2, 32)];
        [des setText:@"如果你要关闭或开启消息推送，请在iphone的“设置”－“通知”功能中，找到应用程序“BleMed”更改。"];
        [des setTextColor:UIColorRGB(0xAEAEAE)];
        [des setFont:[UIFont systemFontOfSize:_size_S(12)]];
        [des setNumberOfLines:2];
        [background addSubview:des];
    }
    
    return background;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *background = [[UIView alloc] initWithFrame:CGRectZero];
    if (section == 1) {
        [background setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 52)];
        UILabel *des = [[UILabel alloc] initWithFrame:CGRectMake(19, 10, SCREEN_WIDTH - 19*2, 32)];
        [des setText:@"当BLEMed在治疗时，你可以设置是否需要铃声或者震动提醒。"];
        [des setTextColor:UIColorRGB(0xAEAEAE)];
        [des setFont:[UIFont systemFontOfSize:_size_S(12)]];
        [des setNumberOfLines:2];
        [background addSubview:des];
    }
    
    return background;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView              // Default is 1 if not implemented
{
    return 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELLHEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 20;
    } else {
        return 52;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 52;
    }
    return 0;
}



- (void)actionClickRing
{
    [treatManager shareInstance].isRing = ![treatManager shareInstance].isRing;
    [_table reloadData];
   
}

- (void)actionClickVibrate
{
    [treatManager shareInstance].isVibrate = ![treatManager shareInstance].isVibrate;
    [_table reloadData];
}


@end
