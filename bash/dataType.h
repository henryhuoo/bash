//
//  dataType.h
//  bash
//
//  Created by 胡旭 on 16/3/25.
//  Copyright © 2016年 胡旭. All rights reserved.
//

#ifndef dataType_h
#define dataType_h



typedef char int8;
typedef short int16;
typedef int int32;

#define secondToDegree(s) (s/100)


typedef enum{
    TreatOver = 0, //结束
    TreatBegin,    //开始
    TreatStop,     //暂停
} TreatType;


#endif /* dataType_h */
