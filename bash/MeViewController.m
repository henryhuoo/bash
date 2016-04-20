//
//  MeViewController.m
//  bash
//
//  Created by 胡旭 on 16/3/12.
//  Copyright © 2016年 胡旭. All rights reserved.
//

#import "MeViewController.h"
#import "UIAdaptor.h"
#import "InfoViewController.h"
#import "SoftwareFunctionViewController.h"
#import "HelpViewController.h"
#import "VersionViewController.h"
#import "BLEDeviceViewController.h"

@interface MeViewController ()
{
    UITableView *_table;
    NSMutableArray *_list;
}
@end

#define CELLHEIGHT 70

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //支持右滑
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44) style:UITableViewStylePlain];
    _table.delegate = self;
    _table.dataSource = self;
    _table.backgroundColor = UIColorRGB(0xF1F2F3);
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    _table.rowHeight = CELLHEIGHT;
    
    [self.view addSubview:_table];

    NSArray *list1 = @[@"个人信息"];
    NSArray *list2 = @[@"我的设备", @"软件功能", @"设备说明", @"帮助反馈", @"版本信息"];
    _list = [[NSMutableArray alloc] init];
    [_list addObject:list1];
    [_list addObject:list2];
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 28;
    } else {
        return 16;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView             // Default is 1 if not implemented
{
    return [_list count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [[_list objectAtIndex:section] count];
    } else{
        return [[_list objectAtIndex:section] count];
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
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    NSInteger section = [indexPath section];
    NSInteger index = [indexPath row];
    
//    if (section == 0 && index == 0) {
//        cell.textLabel.text = @"个人信息";
//    }else if(section == 1 && index == 0){
//        cell.textLabel.text = @"软件功能";
//    }else if(section == 1 && index == 1){
//        cell.textLabel.text = @"设备说明";
//    }else if(section == 1 && index == 2){
//        cell.textLabel.text = @"帮助反馈";
//    }else if(section == 1 && index == 3){
//        cell.textLabel.text = @"版本信息";
//    }
    
    

    NSArray *namelist = [_list objectAtIndex:section];
    NSString *name = [namelist objectAtIndex:index];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 22, _size_W(88), _size_H(22))];
    [label setText:name];
    [label setFont:[UIFont systemFontOfSize:_size_S(16)]];
    [label setTextColor:UIColorRGB(0x555454)];
    
    UIImageView *next = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Icon Arrow Right"]];
    [next setFrame:CGRectMake(SCREEN_WIDTH - 20 - 22, 20, 12, 21)];
    
    [cell.contentView addSubview:label];
    [cell.contentView addSubview:next];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, tableView.rowHeight - 1, SCREEN_WIDTH, 1)];
    line.backgroundColor = UIColorRGB(0xF2F2F2);
    [cell.contentView addSubview:line];

        
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    NSArray *nameList = [_list objectAtIndex:section];
    NSString *name = [nameList objectAtIndex:row];
    
    
    UIViewController *vc = nil;
    if ([name isEqualToString:@"个人信息"]) {
        vc = [[InfoViewController alloc] init];
        
    } else if ([name isEqualToString:@"软件功能"]){
        vc = [[SoftwareFunctionViewController alloc] init];
        
    } else if ([name isEqualToString:@"设备说明"]){
    
    } else if ([name isEqualToString:@"帮助反馈"]){
        vc = [[HelpViewController alloc] init];
    } else if ([name isEqualToString:@"版本信息"]){
        vc = [[VersionViewController alloc] init];
    } else if ([name isEqualToString:@"我的设备"]) {
        vc = [[BLEDeviceViewController alloc] init];
        vc.title = name;
    }
    
    vc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
