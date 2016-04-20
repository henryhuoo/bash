//
//  ViewController.m
//  bash
//
//  Created by 胡旭 on 16/3/10.
//  Copyright © 2016年 胡旭. All rights reserved.
//

#import "ViewController.h"
#import "UIAdaptor.h"
#import "cureMethodModel.h"
#import "TreatmentViewController.h"
#import "pageInstructionViewController.h"
#import "BLEDeviceViewController.h"


@interface ViewController ()
{
    UITableView *_table;
    NSMutableArray *_cureMethodArray;
    cureMethodModel *_cureModel;
}
@end

#define CELLHEIGHT 70
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"治疗方案";
    //支持右滑
    self.navigationController.interactivePopGestureRecognizer.delegate = self;


    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _table.backgroundColor =  UIColorRGB(0xF1F2F3);
    _table.delegate = self;
    _table.dataSource = self;
    _table.sectionHeaderHeight = 10;
    _table.rowHeight = CELLHEIGHT;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_table];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCureStateChange:) name:@"onCureStateChange" object:nil];
    
    //判断是否是首次启动
    if ([globalFlagInterface isFirstOpenFlagWithVersion:[globalFlagInterface getBundleVersion]]) {
        
        UIImage *ins1 = [UIImage imageNamed:@"lead_1"];
        UIImage *ins2 = [UIImage imageNamed:@"lead_2"];
        UIImage *ins3 = [UIImage imageNamed:@"lead_3"];
        NSString *title = @"温馨提示";
        NSArray *array = [NSArray arrayWithObjects:ins1, ins2, ins3, nil];
        
        
        NSString *des1 = @"禁止将设备与以下电子器材合并使用：心脏起搏器；人工心肺；心电监护仪。";
        NSString *des2 = @"以下人群应遵医嘱使用：孕妇，恶性肿瘤患者，心脏障碍患者，血压异常患者，皮肤知觉障碍患者，感染症状患者，其他正在接受治疗或身体不适的患者。";
        NSString *des3 = @"请勿使用于以下部位：心脏附近，头部，面部，口腔内部，阴部和皮肤疾病患处";
        
        pageInstructionViewController *pageCtr = [[pageInstructionViewController alloc] initWithImages:array withTitles:@[title, title, title] withDes:@[des1, des2, des3]];
        pageCtr.modalPresentationStyle = UIModalPresentationOverFullScreen;
        pageCtr.preferredContentSize = CGSizeMake(252, 363);
//        [self presentViewController:pageCtr animated:YES completion:nil];
        
        [self presentViewController:pageCtr animated:YES completion:^{
            
            if ([globalFlagInterface isFirstOpenDeviceWithVersion:[globalFlagInterface getBundleVersion]]) {
                BLEDeviceViewController *vc = [[BLEDeviceViewController alloc] init];
                vc.title = @"设备连接";
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
                
                [globalFlagInterface setFirstOpenDeviceWithVersion:[globalFlagInterface getBundleVersion]];
            }
        }];
    }
    
    _cureMethodArray = [[treatManager shareInstance] treatMethodList];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    _cureModel = [[treatManager shareInstance] getTreatingModel];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"onCureStateChange" object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onCureStateChange:(NSNotification *)notification
{
    [_table reloadData];
}





- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
    }
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    NSInteger index = [indexPath row];
    
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    
    cureMethodModel *model = [_cureMethodArray objectAtIndex:index];
    if (model) {
        
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(79, 15, _size_W(98), _size_H(16))];
        [name setTextColor:UIColorRGB(0x555454)];
        [name setFont:[UIFont systemFontOfSize:_size_S(16)]];
        [name setText:model.CureName];
        
        UILabel *num = [[UILabel alloc] initWithFrame:CGRectMake(182, 18, _size_W(67), _size_H(12))];
        [num setTextColor:UIColorRGB(0x7d7d7d)];
        [num setFont:[UIFont systemFontOfSize:_size_S(12)]];
        [num setText:model.CureNum];
        
        
        UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(79, 41, _size_W(50), _size_H(12))];
        [time setTextColor:UIColorRGB(0xaeaeae)];
        [time setFont:[UIFont systemFontOfSize:_size_S(12)]];
        [time setText:model.CureTime];
        
        UILabel *strength = [[UILabel alloc] initWithFrame:CGRectMake(135, 41, _size_W(80), _size_H(12))];
        [strength setTextColor:UIColorRGB(0xaeaeae)];
        [strength setFont:[UIFont systemFontOfSize:_size_S(12)]];
        [strength setText:model.CureStrength];
        
        UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:model.iconStr]];
        [icon setFrame:CGRectMake(14, 9, 51, 51)];
        
        [cell.contentView addSubview:name];
        [cell.contentView addSubview:icon];
        [cell.contentView addSubview:num];
        [cell.contentView addSubview:time];
        [cell.contentView addSubview:strength];
        
    }
    

    if ([[treatManager shareInstance] getTreatingModel]) {
        tableView.sectionHeaderHeight = 40;
    }
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, tableView.rowHeight - 1, SCREEN_WIDTH, 1)];
    line.backgroundColor = UIColorRGB(0xF2F2F2);
    [cell.contentView addSubview:line];


    
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 70;
//}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_cureModel.Curing == TreatBegin || _cureModel.Curing == TreatStop) {
        return 40;
    }
    
    return 14;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *backgroundview = nil;
    if (_cureModel.Curing == TreatBegin || _cureModel.Curing == TreatStop) {
        backgroundview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        backgroundview.backgroundColor = UIColorRGB(0xF9C15B);
        UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, _size_W(179), _size_H(17))];
        [content setFont:[UIFont systemFontOfSize:16]];
        [content setTextColor:UIColorRGB(0xffffff)];
        [content setText:[NSString stringWithFormat:@"当前运行：%@", _cureModel.CureName]];
        [backgroundview addSubview:content];
        
        
        UITapGestureRecognizer *tapGeture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickHeaderView:)];
        [backgroundview addGestureRecognizer:tapGeture];
        
    }
    
    return backgroundview;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger row = [indexPath row];
    cureMethodModel *model = _cureMethodArray[row];
    
    TreatmentViewController *vc = [[TreatmentViewController alloc] initWithTreatModel:model];
    //隐藏tab bar
    vc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (void)clickHeaderView:(id)sender
{
    NSLog(@"test");
    
    cureMethodModel *treating = [[treatManager shareInstance] getTreatingModel];
    
    if (treating == nil) return;
    
    TreatmentViewController *vc = [[TreatmentViewController alloc] initWithTreatModel:treating];
    //隐藏tab bar
    vc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
