//
//  TreatmentViewController.h
//  bash
//
//  Created by 胡旭 on 16/3/15.
//  Copyright © 2016年 胡旭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cureMethodModel.h"
#import "instrumentViewController.h"

@interface TreatmentViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, instrumentViewControllerDelegate, treatManagerDelegate>


//- (id)initWithTitle:(NSString *)title;
- (id)initWithTreatModel:(cureMethodModel *)model;
@end


typedef enum{
    TreatButtonBegin = 0,
    TreatButtonAdd,
    TreatButtonMinus,
    TreatButtonOver,
    TreatButtonStop,
    TreatButtonContinue,
} buttonType;


@interface TreatButton : UIButton

- (id)initWithTitle:(NSString *)title withImageName:(NSString *)imageName withType:(int)type;
- (void)setWithTitle:(NSString *)title withImageName:(NSString *)imageName withType:(int)type;
- (void)setType:(int)type;
- (int)getType;
@end

@interface TreatDisplayButton : UIButton
@property int allSecond;
@property int countdown;

- (void)setDisplayStartAnimation:(BOOL)YesOrNo;

- (void)setTitle:(NSString*)title;

- (void)setDescription:(NSString *)description;

- (void)setProgress:(float)progress;

- (void)startCountingDownWithTime:(int)remainTime withStrong:(int)strong;

- (void)setRemainTime:(int)remainTime;

- (void)setStrong:(int)strong;

- (void)changeTitleWithFontSize:(int)size;

- (void)changeDesWithFontSize:(int)size;


@end


@interface CountdownView : UIView
@property float progress;
@end