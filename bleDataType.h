//
//  bleDataType.h
//  bash
//
//  Created by 胡旭 on 16/3/25.
//  Copyright © 2016年 胡旭. All rights reserved.
//

#ifndef bleDataType_h
#define bleDataType_h

#include "dataType.h"

//CURE_DATA
struct Treat_Data{
    int8 cmd;
    int8 index;
    int16 subIndex;
    int8 Irate;
    int16 T;
    int8 F;
    int8 W;
    int8 STEP;
    int8 NPB;
    int16 P;
    int16 D;
    int8 IPI;
    int16 TIME_STAMP;
    
}  __attribute__((packed));

typedef struct Treat_Data TreatData;


struct setIndexInfo {
    int8 cmd;
    int8 index;
    int16 hash;
    int16 subnum;
}__attribute__((packed));

typedef struct setIndexInfo SetIndexInfo;


struct setID {
    int8 cmd;
    int32 ID;
}__attribute__((packed));

typedef struct setID SetID;





#endif /* bleDataType_h */
