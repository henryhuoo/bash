//
//  InfoViewController.m
//  bash
//
//  Created by 胡旭 on 16/3/12.
//  Copyright © 2016年 胡旭. All rights reserved.
//

#import "InfoViewController.h"
#import "UIAdaptor.h"
#import "treatManager.h"

@interface InfoViewController ()
{
    UITableView *_table;
    NSMutableArray *_dataSource;
    UITextField *_TFNick;
    UITextField *_TFAge;
    UITextField *_TFHeight;
    UITextField *_TFWeight;
    CGFloat _keyboardHeight;
    CGFloat _moveHeight;
    UITextField *_clickTextfield;
}
@end


#define CELLHEIGHT  48
#define CELLMARGIN  15
@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:UIColorRGB(0xF1F2F3)];
    
    
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    
    _table.delegate = self;
    _table.dataSource = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    _table.backgroundColor = UIColorRGB(0xF1F2F3);
    
    self.navigationItem.title = @"个人信息";
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Icon Arrow Left"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(popVc)];
    
    [self.navigationItem setLeftBarButtonItem:item];
    
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(saveInfo)];
    rightItem.tintColor = [UIColor whiteColor];
    
//    [self.navigationItem setRightBarButtonItem:rightItem];
    
    [self.view addSubview:_table];
    
    
    _dataSource = [NSMutableArray arrayWithObjects:@"info", @"nick", @"sex", @"age", @"height", @"weight", nil];
    
    _TFNick = [[UITextField alloc] initWithFrame:CGRectMake(CELLMARGIN*2 + _size_W(60) + 10, (CELLHEIGHT - _size_S(16))/2, _size_W(120), _size_S(16))];
    
    _TFAge = [[UITextField alloc] initWithFrame:CGRectMake(CELLMARGIN*2 + _size_W(60) + 10, (CELLHEIGHT - _size_S(16))/2, _size_W(150), _size_S(16))];

    _TFHeight = [[UITextField alloc] initWithFrame:CGRectMake(CELLMARGIN*2 + _size_W(60) + 10, (CELLHEIGHT - _size_S(16))/2, _size_W(150), _size_S(16))];
    
    _TFWeight = [[UITextField alloc] initWithFrame:CGRectMake(CELLMARGIN*2 + _size_W(60) + 10, (CELLHEIGHT - _size_S(16))/2, _size_W(150), _size_S(16))];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];


    _keyboardHeight = 216;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)popVc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[treatManager shareInstance] setPersonalDetailWithNickName:_TFNick.text withIsMale:[[treatManager shareInstance] isMale] withAge:[_TFAge.text intValue] withHeight:[_TFHeight.text intValue] withWeight:[_TFWeight.text intValue]];
    [[treatManager shareInstance] savePersonalInfo];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveInfo
{
    return;
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
    return CELLHEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 20;
    } else if (section == 1) {
        return 21;
    } else {
        return 10;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
        view.backgroundColor = UIColorRGB(0xF0F3F3);
        return view;
    } else if (section == 1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 21)];
        view.backgroundColor = UIColorRGB(0xF0F3F3);
        return view;
    } else {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        view.backgroundColor = UIColorRGB(0xF0F3F3);
        return view;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dataSource count];
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
    
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, tableView.rowHeight - 1, SCREEN_WIDTH, 1)];
    line.backgroundColor = UIColorRGB(0xF2F2F2);
    [cell.contentView addSubview:line];
    
    
    
//    NSInteger row = [indexPath row];
    NSInteger section = [indexPath section];
    
    cell.backgroundColor = UIColorRGB(0xF1F2F3);
    
    NSString *kind = _dataSource[section];
    
    if ([kind isEqualToString:@"info"]) {
        UILabel *nick = [[UILabel alloc] initWithFrame:CGRectMake(CELLMARGIN, 0, _size_W(290), _size_H(18))];
        NSString *tmp = @"";
        if ([treatManager shareInstance].info.nickname == nil || [[treatManager shareInstance].info.nickname length] == 0) {
            tmp = @"您的信息";
        } else {
            tmp = [NSString stringWithFormat:@"%@的信息", [treatManager shareInstance].info.nickname];
        }
        nick.text = tmp;
        nick.textColor = UIColorRGB(0x555454);
        nick.font = [UIFont boldSystemFontOfSize:_size_S(18)];
        
        [cell.contentView addSubview:nick];
        
        UILabel *detail = [[UILabel alloc] initWithFrame:CGRectMake(CELLMARGIN, 27, _size_W(290), _size_H(12))];
        detail.text = @"请填写准确信息，以便我们为您提供最合适的治疗方案";
        detail.textColor = UIColorRGB(0xAEAEAE);
        detail.font = [UIFont systemFontOfSize:_size_S(12)];
        
        [cell.contentView addSubview:detail];
        
        
        
    } else if ([kind isEqualToString:@"nick"]) {
        
        UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Input"]];
        [backgroundView setFrame:CGRectMake(CELLMARGIN, 0, SCREEN_WIDTH - CELLMARGIN * 2, 48)];
        [cell.contentView addSubview:backgroundView];
        
        UILabel *nick = [[UILabel alloc] initWithFrame:CGRectMake(CELLMARGIN*2, (CELLHEIGHT - _size_S(16))/2, _size_W(60), _size_S(16))];
        nick.text = @"昵称";
        nick.textColor = UIColorRGB(0xAEAEAE);
        [cell.contentView addSubview:nick];
        
        
        _TFNick.textColor = UIColorRGB(0x555454);
        [cell.contentView addSubview:_TFNick];
        [_TFNick setText:[treatManager shareInstance].info.nickname];
        [_TFNick setFont:[UIFont systemFontOfSize:16]];
        [_TFNick setKeyboardType:UIKeyboardTypeNamePhonePad];
        [_TFNick setDelegate:self];
        
    } else if ([kind isEqualToString:@"sex"]) {
        
        int viewW = (SCREEN_WIDTH - CELLMARGIN*2 - 10)/2;
//        UIImageView *maleBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Input Select"]];
//        [maleBG setFrame:CGRectMake(CELLMARGIN, 0, viewW, CELLHEIGHT)];
//        
//        UIImageView *femaleBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"input Select"]];
//        [femaleBG setFrame:CGRectMake(SCREEN_WIDTH - CELLMARGIN - viewW, 0, viewW, CELLHEIGHT)];
        
        UIButton *BTMale = [UIButton buttonWithType:UIButtonTypeCustom];
        [BTMale setBackgroundColor:[UIColor clearColor]];
        [BTMale setBackgroundImage:[UIImage imageNamed:@"Input Select"] forState:UIControlStateNormal];
        [BTMale setBackgroundImage:[UIImage imageNamed:@"Input Select Down"] forState:UIControlStateSelected];
        [BTMale setFrame:CGRectMake(CELLMARGIN, 0, viewW, CELLHEIGHT)];
        
        UIButton *BTFemale = [UIButton buttonWithType:UIButtonTypeCustom];
        [BTFemale setBackgroundImage:[UIImage imageNamed:@"Input Select"] forState:UIControlStateNormal];
        [BTFemale setFrame:CGRectMake(SCREEN_WIDTH - CELLMARGIN - viewW, 0, viewW, CELLHEIGHT)];
        
        [cell.contentView addSubview:BTMale];
        [cell.contentView addSubview:BTFemale];
        
        UILabel *LBMale = [[UILabel alloc] initWithFrame:CGRectMake(CELLMARGIN, (CELLHEIGHT - _size_S(16))/2, _size_W(32+10), _size_S(16))];
        [LBMale setText:@"男士"];
        [LBMale setTextColor:UIColorRGB(0x555454)];
        [LBMale setFont:[UIFont systemFontOfSize:16]];
        
        [BTMale addSubview:LBMale];
        
        UILabel *LBFemale = [[UILabel alloc] initWithFrame:CGRectMake(CELLMARGIN, (CELLHEIGHT - _size_S(16))/2, _size_W(32+10), _size_S(16))];
        [LBFemale setText:@"女士"];
        [LBFemale setTextColor:UIColorRGB(0x555454)];
        [LBFemale setFont:[UIFont systemFontOfSize:16]];
        
        [BTFemale addSubview:LBFemale];
        
        NSString *maleImage = nil;
        if ([treatManager shareInstance].isMale) {
            maleImage = @"Icon Select Blue";
        }else {
            maleImage = @"Icon Select Gray";
        }
        UIImageView *iconMaleCheck = [[UIImageView alloc] initWithImage:[UIImage imageNamed:maleImage]];
        int iconCheckW = iconMaleCheck.bounds.size.width;
        int iconCheckH = iconMaleCheck.bounds.size.height;
        [iconMaleCheck setFrame:CGRectMake(viewW - 10 - iconCheckW, (CELLHEIGHT - iconCheckH)/2, iconCheckW, iconCheckH)];
        [BTMale addTarget:self action:@selector(actionClickBTMale) forControlEvents:UIControlEventTouchUpInside];
        
        [BTMale addSubview:iconMaleCheck];
        
        
        NSString *femaleImage = nil;
        if (![treatManager shareInstance].isMale) {
            femaleImage = @"Icon Select Blue";
        }else {
            femaleImage = @"Icon Select Gray";
        }
        UIImageView *iconFemaleCheck = [[UIImageView alloc] initWithImage:[UIImage imageNamed:femaleImage]];
        iconCheckW = iconFemaleCheck.bounds.size.width;
        iconCheckH = iconFemaleCheck.bounds.size.height;
        [iconFemaleCheck setFrame:CGRectMake(viewW - 10 - iconCheckW, (CELLHEIGHT - iconCheckH)/2, iconCheckW, iconCheckH)];
        
        [BTFemale addTarget:self action:@selector(actionClickBTFemale) forControlEvents:UIControlEventTouchUpInside];
        [BTFemale addSubview:iconFemaleCheck];
        
        
        
        
    
    } else if ([kind isEqualToString:@"age"]) {
        UIImageView *inputView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Input"]];
        [inputView setFrame:CGRectMake(15, 0, SCREEN_WIDTH - CELLMARGIN * 2, 48)];
        [cell.contentView addSubview:inputView];
        
        UILabel *nick = [[UILabel alloc] initWithFrame:CGRectMake(CELLMARGIN*2, (CELLHEIGHT - _size_S(16))/2, _size_W(60), _size_S(16))];
        nick.text = @"年龄";
        nick.textColor = UIColorRGB(0xAEAEAE);
        [cell.contentView addSubview:nick];
        
        _TFAge.textColor = UIColorRGB(0x555454);
        _TFAge.font = [UIFont systemFontOfSize:_size_S(16)];
        [cell.contentView addSubview:_TFAge];
        
        if ([treatManager shareInstance].info.age > 0) {
            [_TFAge setText:[NSString stringWithFormat:@"%d", [treatManager shareInstance].info.age]];
        }
        
        [_TFAge setKeyboardType:UIKeyboardTypeNumberPad];
        [_TFAge setDelegate:self];
        
    } else if ([kind isEqualToString:@"height"]) {
        
        UIImageView *inputView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Input"]];
        [inputView setFrame:CGRectMake(15, 0, SCREEN_WIDTH - CELLMARGIN * 2, 48)];
        [cell.contentView addSubview:inputView];
        
        UILabel *nick = [[UILabel alloc] initWithFrame:CGRectMake(CELLMARGIN*2, (CELLHEIGHT - _size_S(16))/2, _size_W(60), _size_S(16))];
        nick.text = @"身高";
        nick.textColor = UIColorRGB(0xAEAEAE);
        [cell.contentView addSubview:nick];
        
        _TFHeight.textColor = UIColorRGB(0x555454);
        [cell.contentView addSubview:_TFHeight];
        
        if ([treatManager shareInstance].info.height > 0) {
            [_TFHeight setText:[NSString stringWithFormat:@"%d", [treatManager shareInstance].info.height]];
        }
        
        [_TFHeight setKeyboardType:UIKeyboardTypeNumberPad];
        [_TFHeight setDelegate:self];
        
    } else if ([kind isEqualToString:@"weight"]) {
        UIImageView *inputView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Input"]];
        [inputView setFrame:CGRectMake(15, 0, SCREEN_WIDTH - CELLMARGIN * 2, 48)];
        [cell.contentView addSubview:inputView];
        
        UILabel *nick = [[UILabel alloc] initWithFrame:CGRectMake(CELLMARGIN*2, (CELLHEIGHT - _size_S(16))/2, _size_W(60), _size_S(16))];
        nick.text = @"体重";
        nick.textColor = UIColorRGB(0xAEAEAE);
        [cell.contentView addSubview:nick];
        
        _TFWeight.textColor = UIColorRGB(0x555454);
        [cell.contentView addSubview:_TFWeight];
        
        if ([treatManager shareInstance].info.weight > 0) {
            [_TFWeight setText:[NSString stringWithFormat:@"%d", [treatManager shareInstance].info.weight]];
        }
        
        [_TFWeight setKeyboardType:UIKeyboardTypeNumberPad];
        [_TFWeight setDelegate:self];
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger section = [indexPath section];
    
    NSString *kind = _dataSource[section];
    
    if ([kind isEqualToString:@"nick"]) {
        [_TFNick becomeFirstResponder];
    } else if ([kind isEqualToString:@"age"]) {
        [_TFAge becomeFirstResponder];
    } else if ([kind isEqualToString:@"height"]) {
        [_TFHeight becomeFirstResponder];
    } else if ([kind isEqualToString:@"weight"]) {
        [_TFWeight becomeFirstResponder];
    }

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_TFNick resignFirstResponder];
    [_TFAge resignFirstResponder];
    [_TFHeight resignFirstResponder];
    [_TFWeight resignFirstResponder];
}


#pragma 
#pragma click
- (void)actionClickBTMale
{
    [[treatManager shareInstance] setMale:YES];
    [_table reloadData];
}

- (void)actionClickBTFemale
{
    [[treatManager shareInstance] setMale:NO];
    [_table reloadData];
}

#pragma 
#pragma  UITextFieldDelegate

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    CGFloat keyboardTop = keyboardRect.origin.y;
    CGRect newTextViewFrame = self.view.bounds;
    newTextViewFrame.size.height = keyboardTop - self.view.bounds.origin.y;
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    _table.frame = newTextViewFrame;
    [UIView commitAnimations];
}

- (void) keyboardWillHidden:(NSNotification *)notification
{
    NSDictionary* userInfo = [notification userInfo];
    
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    _table.frame = self.view.bounds;
    
    [UIView commitAnimations];
    
}



@end
