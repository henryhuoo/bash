//
//  treatManager.h
//  bash
//
//  Created by 胡旭 on 16/3/12.
//  Copyright © 2016年 胡旭. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "bleManager.h"
#import "cureMethodModel.h"



@interface personDetail : NSObject <NSCoding>
@property (nonatomic, strong)NSString *nickname;
@property (nonatomic, assign)BOOL isMale;
@property (nonatomic, assign)int age;
@property (nonatomic, assign)int height;
@property (nonatomic, assign)int weight;
@end




@protocol treatManagerDelegate <NSObject>

- (void)treatManagerUpdateTreatingStatus;
- (void)treatManagerUpdateTreatingProgress:(float)progress;
- (void)treatManagerContinueTreating;
- (void)treatManagerStopTreating;
- (void)treatManagerStartTreating;
- (void)treatManagerPauseTreating;


@end


@interface treatManager : NSObject
@property (nonatomic, strong)personDetail *info;
@property (nonatomic, strong)bleManager *manager;
@property (nonatomic, assign)BOOL isConnecting;
@property (nonatomic, strong)NSMutableArray *treatMethodList;
@property (nonatomic, assign)BOOL isOpenNotify;
@property (nonatomic, assign)BOOL isRing;
@property (nonatomic, assign)BOOL isVibrate;
@property (nonatomic, assign)NSString *version;
@property id<treatManagerDelegate> delegate;
+ (instancetype)shareInstance;

- (BOOL)isMale;
- (void)setMale:(BOOL)YESOrNO;
- (void)setPersonalDetailWithNickName:(NSString *)nickname withIsMale:(BOOL)isMale withAge:(int)age withHeight:(int)height withWeight:(int)weight;
- (BOOL)savePersonalInfo;
- (personDetail *)loadPersonalInfo;
- (void)startTreat:(cureMethodModel *)model;
- (void)clearTreat:(cureMethodModel *)model;
- (cureMethodModel *)getTreatingModel;
- (cureMethodModel *)getTreatingModelWithIndex:(int)index;
- (void)stopCountdownUpdate;
- (void)pauseCountdownUpdate;
- (void)startCountdownUpdate;
- (void)continueCountdownUpdate;

- (void)setContinueTreatInfo:(int)remainTime;





@end

@interface treatModel : NSObject
@property (nonatomic, assign)int elapse;
@end
