//
//  bleManager+control.m
//  bash
//
//  Created by 胡旭 on 16/3/23.
//  Copyright © 2016年 胡旭. All rights reserved.
//

#import "bleManager+control.h"

@implementation bleManager(control)

//实时控制
- (void)play:(int)index
{
    char buf[] = {EPLAY, index};
    NSData *data = [NSData dataWithBytes:buf length:2];
    [self writeBLEData:data];
}

- (void)pause:(int)index
{
    char buf[] = {EPAUSE, index};
    NSData *data = [NSData dataWithBytes:buf length:2];
    [self writeBLEData:data];
}


- (void)go_on_play:(int)index
{
    char buf[] = {EGOONPLAY, index};
    NSData *data = [NSData dataWithBytes:buf length:2];
    [self writeBLEData:data];
}


- (void)playend:(int)index
{
    char buf[] = {EPLAYEND, index};
    NSData *data = [NSData dataWithBytes:buf length:2];
    [self writeBLEData:data];
}


- (void)getPlayStatus:(int)index
{
    char buf[] = {EGETPLAYSTATUS, index};
    NSData *data = [NSData dataWithBytes:buf length:2];
    [self writeBLEData:data];
}

- (void)setIRate:(int)rate index:(int)index
{
    if (rate <= 0 ) {
        return;
    } else if (rate >= 99) {
        return;
    }
    
    
    char buf[] = {ESETIRATE, index, rate};
    NSData *data = [NSData dataWithBytes:buf length:3];
    [self writeBLEData:data];
}


//非实时控制
//cmd + index + hash（2Byte） + subnum（2Byte）
- (void)setIndexInfo:(int)index hash:(int)hash subnum:(int)subnum
{
//    char buf[] = {ESETINDEXINFO, index, hash, subnum};
    SetIndexInfo info;
    info.cmd = ESETINDEXINFO;
    info.index = index;
    info.hash = htons(hash);
    info.subnum = htons(subnum);
    NSData *data = [NSData dataWithBytes:&info length:sizeof(info)];
    [self writeBLEData:data];
}

//cmd + index
- (void)getIndexInfp:(int)index
{
    char buf[] = {EGETINDEXINFO, index};
    NSData *data = [NSData dataWithBytes:buf length:2];
    [self writeBLEData:data];
}

//cmd + index + subindex + data
- (void)downloadIndexData:(int)index subIndex:(int)subIndex data:(NSData *)data
{
//    char buf[20] = {EDOWNLOADINDEXDATA, index, subIndex};
//    sprintf(buf + 3, "%s", [data bytes]);
//    NSData *rdata = [NSData dataWithBytes:buf length:sizeof(buf)];
    [self writeBLEData:data];
}

//cmd + index + subindex + data
- (void)downloadTreatData:(NSData *)data
{
    [self writeBLEData:data];
}

- (void)getIndexData:(int)index subIndex:(int)subIndex
{
    char buf[] = {EGETINDEXDATA, index, subIndex};
    NSData *data = [NSData dataWithBytes:buf length:3];
    [self writeBLEData:data];
}

- (void)crcIndexData:(int)index
{
    char buf[] = {ECRCINDEXDATA, index};
    NSData *data = [NSData dataWithBytes:buf length:2];
    [self writeBLEData:data];
}


//版本信息
- (void)setID:(int)ID
{
    SetID info;
    info.cmd = ESETID;
    info.ID = htonl(ID);
    NSData *data = [NSData dataWithBytes:&info length:sizeof(info)];
    [self writeBLEData:data];
}

- (void)getID
{
    char buf[] = {EGETID};
    NSData *data = [NSData dataWithBytes:buf length:1];
    [self writeBLEData:data];
}

- (void)getPhyStatus
{
    NSLog(@"getPhyStatus");
    char buf[] = {EGETPHYSTATUS};
    NSData *data = [NSData dataWithBytes:buf length:1];
    [self writeBLEData:data];
}


- (void)parseBleMessage:(Byte)cmd withRt:(int)result withRawData:(Byte *)rawData
{
    if (result == 0) {
        
        NSLog(@"parseBleMessage fail cmd %x result %d", cmd, result);
        return;
    }
    
    if (cmd == EGETPLAYSTATUS) {
        [self parseGetPhyStatus:rawData];
    } else if (cmd == EELECTRODESDROP) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请检查电极是否脱落，确认电极安放良好，并继续治疗。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:pauseTreatingStatus object:nil];
    }
}

- (void)parseGetPhyStatus:(Byte *)data
{
    //status（1Byte） + index + hash（2Byte） + Irate(1B) + timestamp(2B)
    //查询当前运行的实时状态00空闲  01运行  02暂停
    
    int i = 0;
    int8 status = data[i++];
    int8 index = data[i++];
    int16 hh = 0;
    memcpy(&hh, &data[i], 2);
    int16 hash = ntohs(hh);
    i += 2;
    int8 rate = data[i++];
    int16 ts = 0;
    memcpy(&ts, &data[i], 2);
    int16 timeStamp = ntohs(ts);
    
    
    cureMethodModel *model = [[treatManager shareInstance] getTreatingModelWithIndex:index];
    model.strong = rate;
    model.remainCount = timeStamp;
    
    
    switch (status) {
        case 0:
            model.Curing = TreatOver;
            break;
        case 1:
            model.Curing = TreatBegin;
            break;
        case 2:
            model.Curing = TreatStop;
            break;
        default:
            break;
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:updateTreatingStatus object:nil];
    
}

@end
