//
//  HelpViewController.m
//  bash
//
//  Created by 胡旭 on 16/3/14.
//  Copyright © 2016年 胡旭. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()
{
    UITableView *_table;
}
@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.navigationItem.title = @"帮助反馈";
    
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _table.delegate = self;
    _table.dataSource = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    _table.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_table];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Icon Arrow Left"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(popVc)];
    
    [self.navigationItem setLeftBarButtonItem:item];

    
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

- (void)popVc
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

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
    
//    NSBundle* bundle = [NSBundle mainBundle];
//    NSString* s = [bundle pathForResource:@"Icon Help" ofType:@"png"];
//    
//    NSInteger row = [indexPath row];
    NSInteger section = [indexPath section];
    if (section == 0) {
        UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Icon Help"]];
        [view setFrame:CGRectMake((SCREEN_WIDTH - 130)/2, 0, 130, 130)];
        [cell.contentView addSubview:view];
        
    } else {
        
        UILabel *LBDes = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _size_S(14))];
        [LBDes setText:@"关注即可获取帮助及反馈服务"];
        [LBDes setTextColor:UIColorRGB(0x555454)];
        [LBDes setTextAlignment:NSTextAlignmentCenter];
        [LBDes setFont:[UIFont systemFontOfSize:_size_S(14)]];
        [cell.contentView addSubview:LBDes];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    if (row == 0) {
        return 130;
    } else {
        return 14;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 20;
    } else {
        return 13;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = nil;
    if (section == 0) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    } else {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 13)];
    }
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

@end
