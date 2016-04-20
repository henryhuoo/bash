//
//  BLEDeviceViewController.m
//  bash
//
//  Created by 胡旭 on 16/3/18.
//  Copyright © 2016年 胡旭. All rights reserved.
//

#import "BLEDeviceViewController.h"

@interface BLEDeviceViewController ()
{
    UITableView *_table;
    NSArray *_deviceList;
    UIView *_nodeviceInsView;
    UIView *_connectDeviceView;
}
@end


#define CELLHEIGHT 70


@implementation BLEDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT - 20) style:UITableViewStylePlain];
    _table.delegate = self;
    _table.dataSource = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    _table.backgroundColor = UIColorRGB(0xF1F2F3);
    
    [self.view addSubview:_table];
    
    
//    self.navigationItem.title = @"管理设备";
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Icon Arrow Left"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(popVc)];
    [self.navigationItem setLeftBarButtonItem:item];
    
    _deviceList = [[bleManager shareInstance] getDeviceList];
    [bleManager shareInstance].delegate = self;
    
    
    [[[treatManager shareInstance] manager] initCenteralManger];
    _nodeviceInsView = nil;
    _connectDeviceView = nil;
    
    
    if ([self.title isEqualToString:@"设备连接"]) {
        _nodeviceInsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [_nodeviceInsView setBackgroundColor:UIColorRGB(0xF0F3F3)];
        UIImageView *notConnectedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NotConnected"]];
        CGFloat imageW = notConnectedImageView.bounds.size.width;
        CGFloat imageH = notConnectedImageView.bounds.size.height;
        [notConnectedImageView setFrame:CGRectMake((SCREEN_WIDTH - imageW)/2, (SCREEN_HEIGHT - imageH)/2 - 25 - 30, imageW, imageH)];
        [_nodeviceInsView addSubview:notConnectedImageView];
        
        
        UILabel *description = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 228)/2, notConnectedImageView.frame.origin.y + notConnectedImageView.frame.size.height + 25, 228, 30)];
        [description setText:@"未找到设备，请给Relev充电，并将手机尽量靠近Relev。"];
        [description setTextAlignment:NSTextAlignmentCenter];
        [description setNumberOfLines:2];
        [description setTextColor:UIColorRGB(0x919192)];
        [description setFont:[UIFont systemFontOfSize:12]];
        [_nodeviceInsView addSubview:description];
        
        
        [self.view addSubview:_nodeviceInsView];
        
        
        _connectDeviceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 250)];
        UIImageView *connectedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Connected"]];
        CGFloat conImageW = connectedImageView.bounds.size.width;
        CGFloat conImageH = connectedImageView.bounds.size.height;
        [connectedImageView setFrame:CGRectMake((SCREEN_WIDTH - conImageW)/2, (250 - conImageH)/2, conImageW, conImageH)];
        [_connectDeviceView addSubview:connectedImageView];
        
        UILabel *connectDes = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 228)/2, connectedImageView.frame.origin.y + connectedImageView.frame.size.height + 35, 228, 30)];
        [connectDes setText:@"设备已连接，请选择信号强度较大的Relev，并使用信号灯为蓝色的Relev。"];
        [connectDes setTextAlignment:NSTextAlignmentCenter];
        [connectDes setNumberOfLines:2];
        [connectDes setTextColor:UIColorRGB(0x919192)];
        [connectDes setFont:[UIFont systemFontOfSize:12]];
        [_connectDeviceView addSubview:connectDes];
//        _table.tableFooterView = _connectDeviceView;
        
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [bleManager shareInstance].delegate = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[bleManager shareInstance] startScan];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[bleManager shareInstance] stopScan];
}

- (void)updateBLEDevice:(NSArray *)deviceList
{
    _deviceList = deviceList;
    
    if ([_deviceList count] > 0 && _nodeviceInsView != nil) {
        [_nodeviceInsView removeFromSuperview];
    }
    
    if ([[bleManager shareInstance] isConnected] && _connectDeviceView != nil) {
        _table.tableFooterView = _connectDeviceView;
    }
    
    if ([[bleManager shareInstance] isConnected]) {
        [[RActivityIndicator shareInstance] stopWaiting];
    }
    
    [_table reloadData];
}

- (void)popVc
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_deviceList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CELLHEIGHT - 1, SCREEN_WIDTH, 1)];
    line.backgroundColor = UIColorRGB(0xF2F2F2);
    [cell.contentView addSubview:line];
    
    NSInteger row = [indexPath  row];
    bleModel *model = [_deviceList objectAtIndex:row];
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(20, (CELLHEIGHT - 50)/2, 50, 50)];
    NSString *connect = nil;
    if (model.connected) {
        
        [image setImage:[UIImage imageNamed:@"Icons Blemed Connected"]];
        
        connect = @"已连接";
    } else {
        
        [image setImage:[UIImage imageNamed:@"Icons Blemed Not connected"]];
        
        connect = @"未连接";
    }
    
    [cell.contentView addSubview:image];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 + 50 + 11, 20, SCREEN_WIDTH/2, 13)];
    [nameLabel setText:model.name];
    [nameLabel setTextColor:UIColorRGB(0x555454)];
    [nameLabel setFont:[UIFont systemFontOfSize:13]];
    
    [cell.contentView addSubview:nameLabel];
    
    //for test
    NSString *imageName = [NSString stringWithFormat:@"%d", [[bleManager shareInstance] convertRssiToStrength:model.RSSI]];
    UIImageView *signal = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    [signal setFrame:CGRectMake(20 + 50 + 11 + 50 + _size_W(27), 20, 15, 13)];
    
    [cell.contentView addSubview:signal];
    
    UILabel *signaleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 + 50 + 11, 20 + 13 + 4, SCREEN_WIDTH/2, 12)];
    [signaleLabel setText:[NSString stringWithFormat:@"信号:%@", model.RSSI]];
    [signaleLabel setTextColor:UIColorRGB(0xAEAEAE)];
    [signaleLabel setFont:[UIFont systemFontOfSize:12]];
    
    [cell.contentView addSubview:signaleLabel];
    
    
    UILabel *stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 20 - 40, (CELLHEIGHT - 28)/2, 42, 28)];
    [stateLabel setText:connect];
    [stateLabel setTextColor:UIColorRGB(0x555454)];
    [stateLabel setFont:[UIFont systemFontOfSize:14]];
    
    [cell.contentView addSubview:stateLabel];
    
    UILabel *deviceID = [[UILabel alloc] initWithFrame:CGRectMake(20 + 50 + 11 + 50, 20 + 13 + 4, SCREEN_WIDTH/2, 12)];
    [deviceID setText:[NSString stringWithFormat:@"%@", model.manufacturerData]];
    [deviceID setFont:[UIFont systemFontOfSize:12]];
    [cell.contentView addSubview:deviceID];
    
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELLHEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger row = [indexPath row];
    
    bleModel *model = [_deviceList objectAtIndex:row];
    
    [[bleManager shareInstance] connectPeripheral:model.peripheral withModel:model];
    
    [[RActivityIndicator shareInstance] startWaitingOverView:self.view];
}

@end
