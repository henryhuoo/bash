//
//  TreatmentViewController.m
//  bash
//
//  Created by 胡旭 on 16/3/15.
//  Copyright © 2016年 胡旭. All rights reserved.
//

#import "TreatmentViewController.h"
#import "BLEDeviceViewController.h"

@interface TreatmentViewController ()
{
    UITableView *_table;
    NSString *_title;
    cureMethodModel *_model;
    TreatButton *_beginButton;
    TreatButton *_addButton;
    TreatButton *_minusButton;
    TreatButton *_overButton;
    TreatDisplayButton *_disButton;
    long _timerCount;
    float _maxdegree;
}

@end

#define CELLHEIGHT 90


@implementation TreatmentViewController

- (id)initWithTitle:(NSString *)title
{
    if (self = [super init]) {
        _title = title;
        _disButton = [[TreatDisplayButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 259)/2, (SCREEN_HEIGHT - CELLHEIGHT- 259)/2, 260, 260)];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectPeripheralDevice) name:ConnectPeripheralDevice object:nil];
        
        cureMethodModel *treating = [[treatManager shareInstance] getTreatingModelWithIndex:_model.index];
        if (treating.Curing != TreatOver) {
            [treatManager shareInstance].delegate = self;
        }
        
    }
    
    return self;
}

- (id)initWithTreatModel:(cureMethodModel *)model
{
    _model = model;
    return [self initWithTitle:model.CureName];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _table.delegate = self;
    _table.dataSource = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    _table.backgroundColor = [UIColor clearColor];
    _table.scrollEnabled = NO;
    
        
    self.navigationItem.title = _title;
    
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Icon Arrow Left"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(popVc)];
    [self.navigationItem setLeftBarButtonItem:item];
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Bg-Treat"]];
    [backgroundView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
//    UIImage *image  = [UIImage imageNamed:@"Icon Bluetooth Signal-Connect"];
//    UIButton *BTBle = [UIButton buttonWithType:UIButtonTypeCustom];
//    [BTBle setFrame:CGRectMake(0, 0, 25, 25)];
//    [BTBle setBackgroundImage:image forState:UIControlStateNormal];
//    [BTBle setBackgroundColor:[UIColor clearColor]];
//    [BTBle addTarget:self action:@selector(clickBleButton) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *bleItem = [[UIBarButtonItem alloc] initWithCustomView:BTBle];
//    
//    if ([treatManager shareInstance].isConnecting) {
//        [BTBle setAlpha:1.0];
//    } else {
//        [BTBle setAlpha:0.2];
//    }
//    
//    [self.navigationItem setRightBarButtonItem:bleItem];

    [self.view addSubview:backgroundView];
    
    [self.view addSubview:_table];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - CELLHEIGHT)];
    view.backgroundColor = [UIColor clearColor];
    
    [view addSubview:_disButton];
    
    _table.tableHeaderView = view;
    
    _beginButton = [[TreatButton alloc] initWithTitle:@"开始" withImageName:@"Control  Begin" withType:TreatButtonBegin];
    [_beginButton setWithTitle:@"暂停" withImageName:@"Control  Stop" withType:TreatButtonStop];
    [_beginButton setWithTitle:@"开始" withImageName:@"Control  Begin" withType:TreatButtonContinue];
    
    
    [_beginButton addTarget:self action:@selector(clickBeginButton) forControlEvents:UIControlEventTouchUpInside];
    
    
    _addButton = [[TreatButton alloc] initWithTitle:@"加强" withImageName:@"Control  Add" withType:TreatButtonAdd];
    [_addButton addTarget:self action:@selector(clickAddButton) forControlEvents:UIControlEventTouchUpInside];
    
    _minusButton = [[TreatButton alloc] initWithTitle:@"减弱" withImageName:@"Control  Minus" withType:TreatButtonMinus];
    [_minusButton addTarget:self action:@selector(clickMinusButton) forControlEvents:UIControlEventTouchUpInside];
    _overButton = [[TreatButton alloc] initWithTitle:@"结束" withImageName:@"Control  Over" withType:TreatButtonOver];
    [_overButton addTarget:self action:@selector(clickOverButton) forControlEvents:UIControlEventTouchUpInside];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTreatingStatusCB:) name:updateTreatingStatus object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cleanTreatingStatusCB:) name:cleanTreatingStatus object:nil];
    
    //===============================================================================================
    
    


    
    //===============================================================================================
    if ([_model.CureName isEqualToString:@"肩膀复健方案"] && [globalFlagInterface isFirstOpenTreatWithVersion:[globalFlagInterface getBundleVersion] withPart:@"Shoulder"]) {
        
        UIImage *ins = [UIImage imageNamed:@"Hint Shoulder"];
        NSString *title = @"温馨提示";
        NSString *des = @"请将电极贴放置于肩部一侧如图标注的红点位置。如果双侧疼痛，则在治疗完毕后，换到对侧相同位置再来一次。";
        instrumentViewController *vc = [[instrumentViewController alloc] initWithImage:ins withTitle:title withDes:des withHint:@"Shoulder"];
        vc.delegate = self;
        vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [self presentViewController:vc animated:YES completion:nil];
    } else if ([_model.CureName isEqualToString:@"腰椎复健方案"] && [globalFlagInterface isFirstOpenTreatWithVersion:[globalFlagInterface getBundleVersion] withPart:@"Lumbar"]) {
        
        UIImage *ins = [UIImage imageNamed:@"Hint  Lumbar"];
        NSString *title = @"温馨提示";
        NSString *des = @"请将电极贴放置于腰部一侧如图标注的红点位置。如果双侧疼痛，则在治疗完毕后，换到对侧相同位置再来一次。";
        
        instrumentViewController *vc = [[instrumentViewController alloc] initWithImage:ins withTitle:title withDes:des withHint:@"Lumbar"];
        vc.delegate = self;
        vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [self presentViewController:vc animated:YES completion:nil];
    } else if ([_model.CureName isEqualToString:@"痛经镇痛方案"] && [globalFlagInterface isFirstOpenTreatWithVersion:[globalFlagInterface getBundleVersion] withPart:@"Algomenorrhea"]) {
        
        UIImage *ins = [UIImage imageNamed:@"Hint  Algomenorrhea"];
        NSString *title = @"温馨提示";
        NSString *des = @"请将电极贴放置于小腿一侧如图标注的红点位置。";
        
        instrumentViewController *vc = [[instrumentViewController alloc] initWithImage:ins withTitle:title withDes:des withHint:@"Algomenorrhea"];
        vc.delegate = self;
        vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [self presentViewController:vc animated:YES completion:nil];
    }

}

- (void)viewWillAppear:(BOOL)animated
{
    NSString *title = nil;
    NSString *description = nil;
    
    if ([treatManager shareInstance].isConnecting) {
        
        if ([self viewControllerIsTreating]) {
            cureMethodModel *treating = [[treatManager shareInstance] getTreatingModel];
            [_disButton startCountingDownWithTime:treating.remainCount withStrong:treating.strong];
        } else {
            title = @"开始";
            description = [NSString stringWithFormat:@"%g分钟", _model.treatTime / 60];
            [_disButton setTitle:title];
            [_disButton setDescription:description];
        }
        
        [self updateButtons];
        
    } else {
        title = @"设备未连接";
        description = @"请在“我的设备”进行连接";
        [_disButton setTitle:title];
        [_disButton setDescription:description];
        
        [self disenableButtons];
        
    }
    
    [_disButton setNeedsDisplay];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [treatManager shareInstance].delegate = nil;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)popVc
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma
#pragma instrumentViewControllerDelegate
- (void)clickConfirmButton:(NSString *)hint
{
    [globalFlagInterface setFirstOpenTreatWithVersion:[globalFlagInterface getBundleVersion] withPart:hint];
}

- (void)clickBleButton
{
    BLEDeviceViewController *vc = [[BLEDeviceViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickBeginButton
{
    
    int type = [_beginButton getType];
    
    if (type == TreatButtonBegin) {
        cureMethodModel *treat = [[treatManager shareInstance] getTreatingModel];
        if (treat != nil && ![_model.CureName isEqualToString:[treat CureName]]) {
            [[bleManager shareInstance] playend:treat.index];
            [[treatManager shareInstance] clearTreat:treat];
        }
        
        [_beginButton setType:TreatButtonStop];
        [[bleManager shareInstance] setIRate:_model.strong index:_model.index];
        [[bleManager shareInstance] play:_model.index];
        
        
        //点击开始治疗在使能加强和减小的按钮
        [_addButton setEnabled:YES];
        [_minusButton setEnabled:YES];
        
        //设置治疗页面的状态
        _model.Curing = TreatBegin;
        [[treatManager shareInstance] startCountdownUpdate];
        [_disButton startCountingDownWithTime:_model.remainCount withStrong:_model.strong];
        
        
        if ([treatManager shareInstance].delegate == nil) {
            [treatManager shareInstance].delegate = self;
        }
        
    } else if (type == TreatButtonStop) {
        [_beginButton setType:TreatButtonContinue];
        [[bleManager shareInstance] pause:_model.index];
        _model.Curing = TreatStop;
        
        [[treatManager shareInstance] pauseCountdownUpdate];
        
    } else if (type == TreatButtonContinue){
        [_beginButton setType:TreatButtonStop];
        //for test
        [[bleManager shareInstance] setIRate:_model.strong index:_model.index];
        [[bleManager shareInstance] go_on_play:_model.index];
        _model.Curing = TreatBegin;
        
        [[treatManager shareInstance] continueCountdownUpdate];
    }
    
    [_disButton changeTitleWithFontSize:22];
    [_disButton changeDesWithFontSize:12];
    [_beginButton setNeedsDisplay];
    //更新治疗页面的播放状态
    [[NSNotificationCenter defaultCenter] postNotificationName:@"onCureStateChange" object:nil];
}

- (void)clickAddButton
{
    [[bleManager shareInstance] setIRate:_model.strong++ index:_model.index];
    [_disButton setStrong:_model.strong];
    [_disButton changeTitleWithFontSize:12];
    [_disButton changeDesWithFontSize:22];
    [_disButton setNeedsDisplay];
}

- (void)clickMinusButton
{
    [[bleManager shareInstance] setIRate:_model.strong-- index:_model.index];
    [_disButton setStrong:_model.strong];
    [_disButton changeTitleWithFontSize:12];
    [_disButton changeDesWithFontSize:22];
    [_disButton setNeedsDisplay];
}

- (void)clickOverButton
{
    [[bleManager shareInstance] playend:_model.index];
    
    [_beginButton setType:TreatButtonBegin];
    
    [_addButton setEnabled:NO];
    [_minusButton setEnabled:NO];
    [_beginButton setNeedsDisplay];
    
    //设置治疗页面的状态
    _model.Curing = TreatOver;
    _model.remainCount = _model.treatTime;
    
    [_disButton setRemainTime:_model.treatTime];
    [_disButton changeTitleWithFontSize:22];
    [_disButton changeDesWithFontSize:12];
    [_disButton setProgress:0];
    [_disButton setNeedsDisplay];
    
    
    [[treatManager shareInstance] stopCountdownUpdate];
    
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
    return 1;
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
    
    cell.backgroundColor = [UIColor clearColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    int dvid = (SCREEN_WIDTH - 50)/4;
    
    
    
    [_beginButton setFrame:CGRectMake(0, 0, 45, 71)];
    [_beginButton setCenter:CGPointMake(25 + dvid/2, CELLHEIGHT/2)];
    [cell.contentView addSubview:_beginButton];
    
    
    
    
    [_addButton setFrame:CGRectMake(0, 0, 45, 71)];
    [_addButton setCenter:CGPointMake(25 + dvid + dvid/2, CELLHEIGHT/2)];
    [cell.contentView addSubview:_addButton];
    
    
    
    
    [_minusButton setFrame:CGRectMake(0, 0, 45, 71)];
    [_minusButton setCenter:CGPointMake(25 + dvid*2 +dvid/2, CELLHEIGHT/2)];
    [cell.contentView addSubview:_minusButton];
    
    
    
    
    [_overButton setFrame:CGRectMake(0, 0, 45, 71)];
    [_overButton setCenter:CGPointMake(25 + dvid*3 +dvid/2, CELLHEIGHT/2)];
    [cell.contentView addSubview:_overButton];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELLHEIGHT;
}

- (void)updateTreatingStatusCB:(NSNotification *)notification
{
    cureMethodModel *tmp = [[treatManager shareInstance] getTreatingModel];
    if ([tmp.CureName isEqualToString:_model.CureName]) {
        _model.remainCount = tmp.remainCount;
        _model.Curing = tmp.Curing;
    } else {
        _model.Curing = TreatOver;
        _model.remainCount = 0;
    }
    
    [self updateButtons];
    
    if (_model.Curing != TreatOver) {
        
        [[treatManager shareInstance] continueCountdownUpdate];
        
        [_disButton startCountingDownWithTime:tmp.remainCount withStrong:tmp.strong];
    }
    
    
    [_table reloadData];
    
}

- (void)cleanTreatingStatusCB:(NSNotification *)notification
{
    _model.Curing = TreatOver;
    _model.remainCount = 0;
    
    [[treatManager shareInstance] stopCountdownUpdate];
    
    
    NSString *title = @"设备未连接";
    NSString *description = @"请在“我的设备”进行连接";
    [_disButton setTitle:title];
    [_disButton setDescription:description];
    
    
    [_disButton setProgress:0];
    [_disButton setNeedsDisplay];
    
    [self disenableButtons];
    
    [_table reloadData];
}

- (void)connectPeripheralDevice
{
    
    NSString *title = @"开始";
    NSString *description = [NSString stringWithFormat:@"%g分钟", _model.treatTime / 60];
    [_disButton setTitle:title];
    [_disButton setDescription:description];
    [_disButton setNeedsDisplay];
    
    [self updateButtons];
    
    [_table reloadData];
}


- (void)updateButtons
{
    if (_model.Curing == TreatBegin) {
        [_beginButton setType:TreatButtonStop];
        [_addButton setEnabled:YES];
        [_minusButton setEnabled:YES];
        [_beginButton setEnabled:YES];
        [_overButton setEnabled:YES];
    } else if (_model.Curing == TreatStop) {
        [_beginButton setType:TreatButtonContinue];
        [_addButton setEnabled:YES];
        [_minusButton setEnabled:YES];
        [_beginButton setEnabled:YES];
        [_overButton setEnabled:YES];
    }else {
        [_beginButton setType:TreatButtonBegin];
        [_addButton setEnabled:NO];
        [_minusButton setEnabled:NO];
        [_beginButton setEnabled:YES];
        [_overButton setEnabled:YES];
    }
    
    [_beginButton setNeedsDisplay];
    [_addButton setNeedsDisplay];
    [_minusButton setNeedsDisplay];
    [_overButton setNeedsDisplay];
    
}

- (void)setPlayStatus:(BOOL)isPlaying
{
    
}

#pragma
#pragma treatManagerDelegate
- (void)treatManagerUpdateTreatingProgress:(float)progress
{
    cureMethodModel *treating = [[treatManager shareInstance] getTreatingModel];
    
    if (![treating.CureName isEqualToString:_model.CureName]) {
        return;
    }
    
    _disButton.progress =  progress;
    
    [_disButton setNeedsDisplay];
}

- (void)treatManagerUpdateTreatingStatus
{
    cureMethodModel *treating = [[treatManager shareInstance] getTreatingModel];

    [_disButton setRemainTime:treating.remainCount];
}
- (void)treatManagerContinueTreating
{
    
}
- (void)treatManagerStopTreating
{
    [self updateButtons];
    
    [_disButton setTitle:@"开始"];
    NSString *description = [NSString stringWithFormat:@"%g分钟", _model.treatTime / 60];
    [_disButton setDescription:description];
    [_disButton setNeedsDisplay];
}
- (void)treatManagerStartTreating
{
    //开始治疗
}
- (void)treatManagerPauseTreating
{
    [self updateButtons];
    
    [_disButton setTitle:@"开始"];
    NSString *description = [NSString stringWithFormat:@"%g分钟", _model.treatTime / 60];
    [_disButton setDescription:description];
    [_disButton setNeedsDisplay];

}

- (BOOL)viewControllerIsTreating
{
    cureMethodModel *treatModel = [[treatManager shareInstance] getTreatingModelWithIndex:_model.index];
    if (treatModel.Curing != TreatOver) {
        return YES;
    }
    return NO;
}

- (void)disenableButtons
{
    [_addButton setEnabled:NO];
    [_minusButton setEnabled:NO];
    [_beginButton setEnabled:NO];
    [_overButton setEnabled:NO];
    
    [_beginButton setNeedsDisplay];
    [_addButton setNeedsDisplay];
    [_minusButton setNeedsDisplay];
    [_overButton setNeedsDisplay];
}


@end

@interface TreatButton ()
{
    NSString *_title;
    NSString *_imageName;
    int _type;
    NSMutableDictionary *_bindTitleData;
    NSMutableDictionary *_bindImageData;
}
@end

@implementation TreatButton

- (id)initWithTitle:(NSString *)title withImageName:(NSString *)imageName withType:(int)type
{
    if (self = [super init]) {
        
        _title = title;
        _imageName = imageName;
        _type = type;
        _bindTitleData = [[NSMutableDictionary alloc] initWithCapacity:2];
        _bindImageData = [[NSMutableDictionary alloc] initWithCapacity:2];
        
        [_bindTitleData setObject:title forKey:[NSNumber numberWithInt:type]];
        [_bindImageData setObject:imageName forKey:[NSNumber numberWithInt:type]];
        
    }
    
    return self;
}

- (void)setWithTitle:(NSString *)title withImageName:(NSString *)imageName withType:(int)type
{
    [_bindTitleData setObject:title forKey:[NSNumber numberWithInt:type]];
    [_bindImageData setObject:imageName forKey:[NSNumber numberWithInt:type]];
}

- (void)setType:(int)type
{
    _type = type;
}

- (int)getType
{
    return _type;
}



- (void)drawRect:(CGRect)rect
{
    
    NSString *title = [_bindTitleData objectForKey:[NSNumber numberWithInt:_type]];
    NSString *imageName = [_bindImageData objectForKey:[NSNumber numberWithInt:_type]];
    
    [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateNormal];
    
//    [self setFrame:CGRectMake(0, 0, 45, 71)];
    
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, 0, rect.size.height - self.imageView.bounds.size.height, 0)];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(self.imageView.bounds.size.height + 12, (rect.size.width - self.imageView.bounds.size.width)/2 - self.imageView.bounds.size.width, 0, 0)];
}

@end

@interface TreatDisplayButton()
{
    NSString *_timeDes;
    NSString *_strongDes;
    BOOL _startAnimation;
    UIImageView *_bgView1;
    UIImageView *_bgView2;
    UIImageView *_bgView3;
    UIImageView *_bgView4;
    UIImageView *_bgView5;
    UILabel *_Title;
    UILabel *_des;
    UILabel *_strong;
    CountdownView *_countdownView;
    CGRect _desRect;
    CGRect _titleRect;
    int _titleFontSize;
    int _desFontSize;
}
@end


#import <QuartzCore/QuartzCore.h>
#define PI 3.14159265358979323846

//static int i = 0;
@implementation TreatDisplayButton

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _bgView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Icon Count down bg"]];
        _bgView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Icon Count down bg"]];
        _bgView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Icon Count down bg"]];
        _bgView4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Icon Count down"]];
        _bgView5 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Icon Count down bg"]];
        _countdownView = [[CountdownView alloc] init];
        
        _Title = [[UILabel alloc] init];

        _des = [[UILabel alloc] init];
        
        _titleRect = CGRectMake(0, 106, frame.size.width, 22);
        
        _titleFontSize = 22;
        
        _desRect = CGRectMake(0, 106 + 22 + 16, frame.size.width, 12);
        
        _desFontSize = 12;
        
    }
    return self;
}

- (void)setDisplayStartAnimation:(BOOL)YesOrNo
{
    _startAnimation = YesOrNo;
}

- (void)drawRect:(CGRect)rect
{
    
//    int radius = rect.size.width / 2;
//    int x = rect.origin.x + radius;
//    int y = rect.origin.y + radius;
    
    [_bgView1 setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    [_bgView1 setAlpha:0.1];
    
    [self addSubview:_bgView1];
    
    
    
    [_bgView2 setFrame:CGRectMake(14, 14, rect.size.width - 28, rect.size.height - 28)];
    [_bgView2 setAlpha:0.2];
    
    [self addSubview:_bgView2];
    
    [_bgView3 setFrame:CGRectMake(29, 29, rect.size.width - 58, rect.size.height - 58)];
    [_bgView3 setAlpha:1];
    
    [self addSubview:_bgView3];
    
    
    [_bgView4 setFrame:CGRectMake(29, 29, rect.size.width - 58, rect.size.height - 58)];
    [_bgView4 setAlpha:1];
    
    [self addSubview:_bgView4];


    [_countdownView setFrame:CGRectMake(29, 29, rect.size.width - 58, rect.size.height - 58)];
    [_countdownView setNeedsDisplay];
    [self addSubview:_countdownView];
    
    [_bgView5 setFrame:CGRectMake(37, 37, rect.size.width - 74, rect.size.height - 74)];
    [_bgView5 setAlpha:0.5];
    
    [self addSubview:_bgView5];
    
    [_Title setFrame: _titleRect];
    [_Title setText:_timeDes];
    [_Title setTextColor:UIColorRGB(0x555454)];
    [_Title setFont:[UIFont systemFontOfSize:_titleFontSize]];
    [_Title setTextAlignment:NSTextAlignmentCenter];
    
    [self addSubview:_Title];
    
    [_des setFrame:_desRect];
    [_des setText:_strongDes];
    [_des setTextColor:UIColorRGB(0xAAAAAA)];
    [_des setFont:[UIFont systemFontOfSize:_desFontSize]];
    [_des setTextAlignment:NSTextAlignmentCenter];
    
    [self addSubview:_des];
    
}

- (void)setTitle:(NSString*)title
{
    _timeDes = title;
}

- (void)setDescription:(NSString *)description
{
    _strongDes = description;
}

- (void)setProgress:(float)progress
{
    _countdownView.progress = progress;
}

- (void)setStrong:(int)strong
{
    _strongDes = [NSString stringWithFormat:@"强度: %d", strong];
    [_des setText:_strongDes];
    
}

- (void)startCountingDownWithTime:(int)remainTime withStrong:(int)strong
{
    _timeDes = [NSString stringWithFormat:@"%dm %ds", [util convertMinutes:remainTime], [util convertSeconds:remainTime]];
    _strongDes = [NSString stringWithFormat:@"强度: %d", strong];
    
    [_Title setText:_timeDes];
    [_des setText:_strongDes];
    [[treatManager shareInstance] setContinueTreatInfo:remainTime];
    
    
    [self setNeedsDisplay];
}


- (void)setRemainTime:(int)remainTime
{
    _timeDes = [NSString stringWithFormat:@"%dm %ds", [util convertMinutes:remainTime], [util convertSeconds:remainTime]];
    [_Title setText:_timeDes];
}

- (void)changeTitleWithFontSize:(int)size
{
    CGRect titleRect = _Title.frame;
    _titleRect = CGRectMake(0, 106, titleRect.size.width, size);
    _titleFontSize = size;
    [_Title setFrame: _titleRect];
    [_Title setFont:[UIFont systemFontOfSize:_titleFontSize]];
}

- (void)changeDesWithFontSize:(int)size
{
    CGRect desRect = _des.frame;
    
    int move = 12;
    if (size == 12) move = 22;
    if (size == 22) move = 12;
        
    _desRect = CGRectMake(0, 106 + move + 16, desRect.size.width, size);
    _desFontSize = size;
    [_des setFrame:_desRect];
    [_des setFont:[UIFont systemFontOfSize:_desFontSize]];
}





@end

@interface CountdownView ()

@end

@implementation CountdownView

- (id)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 5;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    int radius = rect.size.width / 2 - 5;
    int x = rect.origin.x + rect.size.width / 2;
    int y = rect.origin.y + rect.size.height / 2;
    
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor whiteColor] set];
    

    
    CGContextSetLineWidth(ctx, 10);
    CGContextSetLineCap(ctx, kCGLineCapSquare);
    CGFloat to = - M_PI * 0.5 + self.progress * M_PI * 2 + 0.05; // 初始值0.05
    CGContextAddArc(ctx, x, y, radius, - M_PI * 0.5, to, 1);
    CGContextStrokePath(ctx);
    
    // 进度数字
//    NSString *progressStr = [NSString stringWithFormat:@"%.0f", self.progress * 100];
//    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
//    attributes[NSFontAttributeName] = [UIFont boldSystemFontOfSize:20 * SDProgressViewFontScale];
//    attributes[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
//    [self setCenterProgressText:progressStr withAttributes:attributes];
}


@end

