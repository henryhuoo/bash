//
//  treatManager.m
//  bash
//
//  Created by 胡旭 on 16/3/12.
//  Copyright © 2016年 胡旭. All rights reserved.
//

#import "treatManager.h"


@implementation personDetail
@synthesize nickname = _nickname;
@synthesize isMale = _isMale;
@synthesize age = _age;
@synthesize height = _height;
@synthesize weight = _weight;


- (id)init
{
    if (self = [super init]) {
        self.isMale = YES;
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeBool:_isMale forKey:@"male"];
    [aCoder encodeObject:_nickname forKey:@"nickname"];
    [aCoder encodeInt:_age forKey:@"age"];
    [aCoder encodeInt:_height forKey:@"height"];
    [aCoder encodeInt:_weight forKey:@"weight"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        _isMale = [aDecoder decodeBoolForKey:@"male"];
        _nickname = [aDecoder decodeObjectForKey:@"nickname"];
        _age = [aDecoder decodeIntForKey:@"age"];
        _height = [aDecoder decodeIntForKey:@"height"];
        _weight = [aDecoder decodeIntForKey:@"weight"];
    }
    
    return self;
}
@end


@interface treatManager ()
{
    NSTimer *_treatingTimer;
    long _timerCount;
    float _progress;
}
@end

static treatManager *_treatManager = nil;

@implementation treatManager


+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_treatManager == nil) {
            _treatManager = [[treatManager alloc] init];
        }
    });
    
    return _treatManager;
}

- (id)init
{
    if (self = [super init]) {
        self.info = [self loadPersonalInfo];
        self.manager = [bleManager shareInstance];
        self.isOpenNotify = YES;
        self.version = @"版本号:1.0.0";
        _treatMethodList = [self createTreatData];
        _treatingTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(countdownUpdate) userInfo:nil repeats:YES];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pauseTreating) name:pauseTreatingStatus object:nil];
    }
    
    return self;
}

- (BOOL)isConnecting
{
    return [self.manager isConnected];
}

- (BOOL)isMale
{
    return self.info.isMale;
}

- (void)setMale:(BOOL)YESOrNO
{
    self.info.isMale = YESOrNO;
}

- (BOOL)isOpenNotify
{
    return [globalFlagInterface getRemoteNotificationOpenStatus];
}

- (BOOL)isVibrate
{
    //QQAlert
    return NO;
}

- (BOOL)isRing
{
    //QQAlert
    return NO;
}

- (void)setPersonalDetailWithNickName:(NSString *)nickname withIsMale:(BOOL)isMale withAge:(int)age withHeight:(int)height withWeight:(int)weight
{
    self.info.nickname = nickname;
    self.info.isMale = isMale;
    self.info.age = age;
    self.info.height = height;
    self.info.weight = weight;
}

- (BOOL)savePersonalInfo
{
    NSString *path = [[util getDocPath] stringByAppendingString:@"/account"];
    BOOL ret =  [NSKeyedArchiver archiveRootObject:self.info toFile:path];
    return ret;
}

- (personDetail *)loadPersonalInfo
{
    personDetail *info = [NSKeyedUnarchiver unarchiveObjectWithFile:[[util getDocPath] stringByAppendingString:@"/account"]];
    if (info == nil) {
        info = [[personDetail alloc] init];
    }
    return info;
}


- (NSMutableArray *)createTreatData
{
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    cureMethodModel *mtd1 = [[cureMethodModel alloc] init];
    mtd1.iconStr = @"Icons Cure shoulder";
    mtd1.CureName = @"肩膀复健方案";
    mtd1.CureNum = @"No.00768";
//    mtd1.CureTime = @"15分钟";
    mtd1.CureStrength = @"强度：40%";
    mtd1.treatTime = 120;//秒
    mtd1.index = 2;
    mtd1.treatData = waistTreat;
    mtd1.strong = [globalFlagInterface getGlobalStrong];
    mtd1.Curing = TreatOver;
    mtd1.remainCount = 120;//秒
    mtd1.secondPerDegree = [self convertRemaincountToMPD:mtd1.remainCount];
    
    [list addObject:mtd1];
    
    cureMethodModel *mtd2 = [[cureMethodModel alloc] init];
    mtd2.iconStr = @"Icons Cure lumbar";
    mtd2.CureName = @"腰椎复健方案";
    mtd2.CureNum = @"No.00000";
//    mtd2.CureTime = @"15分钟";
    mtd2.CureStrength = @"强度：40%";
    mtd2.treatTime = 30;
    mtd2.index = 1;
    mtd2.treatData = waistTreat;
    mtd2.strong = [globalFlagInterface getGlobalStrong];
    mtd2.Curing = TreatOver;
    mtd2.remainCount = 30;
    mtd2.secondPerDegree = [self convertRemaincountToMPD:mtd2.remainCount];
    
    [list addObject:mtd2];
    
    cureMethodModel *mtd3 = [[cureMethodModel alloc] init];
    mtd3.iconStr = @"Icons Cure  algomenorrhea";
    mtd3.CureName = @"痛经镇痛方案";
    mtd3.CureNum = @"No.04353";
//    mtd3.CureTime = @"15分钟";
    mtd3.CureStrength = @"强度：60%";
    mtd3.treatTime = 900;
    mtd3.index = 0;
    mtd3.treatData = femaleTreat;
    mtd3.strong = [globalFlagInterface getGlobalStrong];
    mtd3.Curing = TreatOver;
    mtd3.remainCount = 900;
    mtd3.secondPerDegree = [self convertRemaincountToMPD:mtd3.remainCount];
    
    [list addObject:mtd3];
    
    return list;
}


- (cureMethodModel *)getTreatingModel
{
    for (cureMethodModel *model in _treatMethodList)
    {
        if (model.Curing == TreatBegin || model.Curing == TreatStop) {
            return model;
        }
    }
    
    return nil;
}

- (cureMethodModel *)getTreatingModelWithIndex:(int)index
{
    for (cureMethodModel *model in _treatMethodList)
    {
        if (model.index == index) {
            return model;
        }
    }
    
    return nil;
}

- (void)startTreat:(cureMethodModel *)model
{
    for (cureMethodModel *treatModel in _treatMethodList) {
        if ([treatModel.CureName isEqualToString:model.CureName]) {
            treatModel.Curing = TreatBegin;
        }
    }
}

- (void)pauseTreat:(cureMethodModel *)model
{
    for (cureMethodModel *treatModel in _treatMethodList) {
        if ([treatModel.CureName isEqualToString:model.CureName]) {
            treatModel.Curing = TreatStop;
            [self pauseCountdownUpdate];
        }
    }
}

- (void)clearTreat:(cureMethodModel *)model
{
    for (cureMethodModel *treatModel in _treatMethodList) {
        if ([treatModel.CureName isEqualToString:model.CureName]) {
            treatModel.Curing = TreatOver;
            treatModel.remainCount = 0;
        } 
    }
}

- (float)convertRemaincountToMPD:(float)remaincount
{
    //转换成ms，timer间隔100ms之行一次
    return remaincount / 10;
}

- (void)countdownUpdate
{
    cureMethodModel *treatingModel = [self getTreatingModel];
    
    if (treatingModel.Curing != TreatBegin) {
        return;
    }
    
    _timerCount++;
    
    NSLog(@"_timerCount++ %ld", _timerCount);
    
    if (treatingModel.remainCount > 0) {
        
        //
        if (_timerCount % (int)treatingModel.secondPerDegree == 0) {
            
            
            _progress += 0.01;
            if (_progress >= 1 ) _progress = 0;
            
            NSLog(@"update progress %g", _progress);
            
            if ([_delegate respondsToSelector:@selector(treatManagerUpdateTreatingProgress:)]) {
                
                [_delegate treatManagerUpdateTreatingProgress:_progress];
            }
        }
        
        //倒计时
        if (_timerCount % 10 == 0) {
            treatingModel.remainCount -= 1;
            
            NSLog(@"update second %g", treatingModel.remainCount);
            
            if ([_delegate respondsToSelector:@selector(treatManagerUpdateTreatingStatus)]) {
                [_delegate treatManagerUpdateTreatingStatus];
            }
            
        }
    }
    
    if (treatingModel.remainCount <= 0) {
        [self stopCountdownUpdate];
    }
}

- (void)stopCountdownUpdate
{
    cureMethodModel *treatingModel = [self getTreatingModel];

    NSLog(@"stopCountdownUpdate");
    treatingModel.remainCount = 0;
    [_treatingTimer setFireDate:[NSDate distantFuture]];
    
    treatingModel.Curing = TreatOver;
    if ([_delegate respondsToSelector:@selector(treatManagerStopTreating)]) {
        [_delegate treatManagerStopTreating];
    }

}

- (void)pauseCountdownUpdate
{
    [_treatingTimer setFireDate:[NSDate distantFuture]];
    if ([_delegate respondsToSelector:@selector(treatManagerPauseTreating)]) {
        [_delegate treatManagerPauseTreating];
    }
}

- (void)startCountdownUpdate
{
    cureMethodModel *treatingModel = [self getTreatingModel];

    [_treatingTimer setFireDate:[NSDate date]];
    _timerCount = 0;
    _progress = 0;
    
    treatingModel.remainCount = treatingModel.treatTime;
    
    if ([_delegate respondsToSelector:@selector(treatManagerStartTreating)]) {
        [_delegate treatManagerStartTreating];
    }
}

- (void)continueCountdownUpdate
{
    [_treatingTimer setFireDate:[NSDate date]];
    if ([_delegate respondsToSelector:@selector(treatManagerContinueTreating)]) {
        [_delegate treatManagerContinueTreating];
    }
}

- (void)setContinueTreatInfo:(int)remainTime
{
    cureMethodModel *treatingModel = [self getTreatingModel];
    
    treatingModel.remainCount = remainTime;
    
    int finishTime = treatingModel.treatTime - treatingModel.remainCount;
    
    int startAngle = finishTime * 10 / treatingModel.secondPerDegree;
    
    _progress = startAngle * 0.01;
    
    if ([_delegate respondsToSelector:@selector(treatManagerUpdateTreatingProgress:)]) {
        [_delegate treatManagerUpdateTreatingProgress:_progress];
    }
}


- (void)pauseTreating
{
    cureMethodModel *model = [self getTreatingModel];
    [self pauseTreat:model];
}

@end


@implementation treatModel



@end
