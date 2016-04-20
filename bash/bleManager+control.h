//
//  bleManager+control.h
//  bash
//
//  Created by 胡旭 on 16/3/23.
//  Copyright © 2016年 胡旭. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    EPLAY = 0x01,
    EPAUSE = 0x02,
    EGOONPLAY = 0x03,
    EPLAYEND = 0x04,
    EGETPLAYSTATUS = 0x05,
    ESETIRATE = 0x06,
    
    
    ESETINDEXINFO = 0x10,
    EGETINDEXINFO = 0x11,
    EDOWNLOADINDEXDATA = 0x13,
    EGETINDEXDATA = 0x14,
    ECRCINDEXDATA = 0x15,
    
    
    
    ESETID = 0x20,
    EGETID = 0x21,
    
    
    EGETPHYSTATUS = 0x31,
    
    EELECTRODESDROP = 0x40,
} EControl;






@interface bleManager (control)


//实时控制
- (void)play:(int)index;
- (void)pause:(int)index;
- (void)go_on_play:(int)index;
- (void)playend:(int)index;
- (void)getPlayStatus:(int)index;
- (void)setIRate:(int)rate index:(int)index;


//非实时控制
- (void)setIndexInfo:(int)index hash:(int)hash subnum:(int)subnum;
- (void)getIndexInfp:(int)index;
- (void)downloadIndexData:(int)index subIndex:(int)subIndex data:(NSData *)data;
- (void)downloadTreatData:(NSData *)data;
- (void)getIndexData:(int)index subIndex:(int)subIndex;
- (void)crcIndexData:(int)index;


//版本信息
- (void)setID:(int)ID;
- (void)getID;
- (void)getPhyStatus;

//========================================================================================



- (void)parseBleMessage:(Byte)cmd withRt:(int)result withRawData:(Byte *)rawData;
- (void)parseGetPhyStatus:(Byte *)data;

@end


