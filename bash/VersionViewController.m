//
//  VersionViewController.m
//  bash
//
//  Created by 胡旭 on 16/3/14.
//  Copyright © 2016年 胡旭. All rights reserved.
//

#import "VersionViewController.h"


#define CELLHEIGHT 50

@interface VersionViewController ()
{
    UITableView *_table;
}
@end

@implementation VersionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"版本信息";
    
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    
    _table.delegate = self;
    _table.dataSource = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    _table.backgroundColor = UIColorRGB(0xF1F2F3);

    [self.view addSubview:_table];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Icon Arrow Left"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(popVc)];
    
    [self.navigationItem setLeftBarButtonItem:item];
    
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 129)];
    headView.backgroundColor = UIColorRGB(0xF0F3F3);
    _table.tableHeaderView = headView;
    
    UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Icon App"]];
    [logoView setFrame:CGRectMake((SCREEN_WIDTH - 66)/2, (129 - 66)/2, 66, 66)];
    [headView addSubview:logoView];
    
    UILabel *LBVersion = [[UILabel alloc] initWithFrame:CGRectMake(0, (129 - 66)/2 + 66 +13, SCREEN_WIDTH, 12)];
    [LBVersion setText:[treatManager shareInstance].version];
    [LBVersion setTextColor:UIColorRGB(0x555454)];
    [LBVersion setFont:[UIFont systemFontOfSize:12]];
    [LBVersion setTextAlignment:NSTextAlignmentCenter];
    [headView addSubview:LBVersion];
    
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
    return 2;
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
    
    NSInteger row = [indexPath row];
    if (row == 0) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, (CELLHEIGHT - _size_S(17))/2, _size_W(80), _size_S(17))];
        
        [label setText:@"服务条款"];
        [label setTextColor:UIColorRGB(0x555454)];
        [label setFont:[UIFont systemFontOfSize:_size_S(17)]];
        
        [cell.contentView addSubview:label];
    } else {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, (CELLHEIGHT - _size_S(17))/2, _size_W(80), _size_S(17))];
        
        [label setText:@"隐私政策"];
        [label setTextColor:UIColorRGB(0x555454)];
        [label setFont:[UIFont systemFontOfSize:_size_S(17)]];
        
        [cell.contentView addSubview:label];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELLHEIGHT;
}

@end
