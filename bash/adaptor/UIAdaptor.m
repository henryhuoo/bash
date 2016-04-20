//
//  UIAdaptor.m
//  testtab
//
//  Created by davidhu on 16/3/9.
//  Copyright © 2016年 davidhu. All rights reserved.
//

#import "UIAdaptor.h"


#pragma 
#pragma UI Color

UIColor *UIColorARGB(uint32_t hex){
    int a = (hex >> 24) & 0xFF;
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:a / 255.0f];
}

UIColor *UIColorRGB(uint32_t colorHexRGB){
    return UIColorARGB(0xFF000000|colorHexRGB);
}


#pragma 
#pragma UI Adaptor
static int static_statusbarHeight = 0;

int getScreenWidth()
{
    static int s_scrWidth = 0;
    if (s_scrWidth == 0){
        UIScreen* screen = [UIScreen mainScreen];
        CGRect screenFrame = screen.bounds;
        s_scrWidth = MIN(screenFrame.size.width, screenFrame.size.height);
        
        //解决在ipad中app启动时[UIScreen mainScreen].CZ_B_SizeW于768px的问题
        if (s_scrWidth >= 768) {
            s_scrWidth = 320 * (s_scrWidth / 768.0f);
        }
    }
    
    return s_scrWidth;
}

int getScreenHeight()
{
    static int s_scrHeight = 0;
    if (s_scrHeight == 0){
        UIScreen* screen = [UIScreen mainScreen];
        CGRect screenFrame = screen.bounds;
        s_scrHeight = MAX(screenFrame.size.height, screenFrame.size.width);
        
        //解决在ipad中app启动时[UIScreen mainScreen].CZ_B_SizeH于1024x的问题
        if (s_scrHeight >= 1024) {
            s_scrHeight = 480 * (s_scrHeight / 1024.0f);
        }
    }
    return s_scrHeight;
}

int getScreenScale()
{
    static int scale = 0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        scale = [UIScreen mainScreen].scale;
    });
    
    return scale;
}



CGFloat screenScale()
{
    return 1.f;
    
//#ifndef OPEN_AUTO_SCALE
//    return 1.0f;
//#else
//    
//    return [[QQDynamicFontManager GetInstances] dynamicFontScale];
//#endif
}



CGFloat screenFontSize()
{
    //设计师rachel说不再需要32号的字
    //     if(320 == getScreenWidth()) return 16.0f*screenScale();
    return 17.0f*screenScale();
}

//以iPhone5s屏幕宽度为基准
CGFloat fitScreenW(CGFloat value)
{
    CGFloat tValue = value;
    int rValue =(tValue/320.0f)*getScreenWidth();
    return rValue;
}


CGFloat fitScreenH(CGFloat value)
{
#ifndef OPEN_AUTO_SCALE
    return value;
#else
    return value*MAX(1.0f,screenScale());
#endif
}


CGFloat fitScaleScreen(CGFloat value)
{
#ifndef OPEN_AUTO_SCALE
    return value;
#else
    return value*MAX(1.0f,screenScale());
#endif
    
}


@implementation UIAdaptor

@end
