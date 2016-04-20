//
//  util.m
//  bash
//
//  Created by 胡旭 on 16/3/22.
//  Copyright © 2016年 胡旭. All rights reserved.
//

#import "util.h"

@implementation util

+ (NSString *)getDocPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    return docDir;
}


+ (char *)convertString:(char *)string length:(int)length
{
    
    if (string == NULL) {
        return NULL;
    }
    
    
    int len = (int)length/2;
    
    char *buf = malloc(len);
    memset(buf, 0x00, len);
    
    decodehexstr2bin(string, length, buf);
    
    return buf;
}



char hexc2bin(char *what)
{
    register char digit;
    
    digit = (what[0] >= 'A' ? ((what[0] & 0xdf) - 'A')+10 : (what[0] - '0'));
    digit *= 16;
    digit += (what[1] >= 'A' ? ((what[1] & 0xdf) - 'A')+10 : (what[1] - '0'));
    return(digit);
}

void decodehexstr2bin(const char *str, int strlen, char *hex)
{
    char tmp[2]={0};
    int len = strlen / 2;
    for(int i=0; i < len; ++i)
    {
        tmp[0] = toupper(str[2*i]);
        tmp[1] = toupper(str[2*i+1]);
        char cc = hexc2bin(tmp);
        hex[i] = cc;
    }
}

+ (int)convertMinutes:(int)time
{
    return time / 60;
}

+ (int)convertSeconds:(int)time
{
    return time % 60;
}



+ (void)openBlueTooth
{
    NSURL *url = [NSURL URLWithString:@"prefs:root=Bluetooth"];
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
    }
}
@end
