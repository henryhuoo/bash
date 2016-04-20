//
//  UIAdaptor.h
//  testtab
//
//  Created by davidhu on 16/3/9.
//  Copyright © 2016年 davidhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#define SCREEN_WIDTH            getScreenWidth()
#define SCREEN_HEIGHT           getScreenHeight()

#define OPEN_AUTO_SCALE
#define _size_W(value)    fitScreenW(value)
#define _size_H(value)    fitScreenH(value)
#define _size_S(value)    fitScaleScreen(value)
#define _sizeScale        screenScale()

#define RGBACOLOR(r, g, b, a) UIColorARGB(((int)(a*255)<<24)|((int)(r)<<16)|((int)(g)<<8)|((int)(b)))
#define RGBCOLOR(r, g, b) UIColorRGB(((int)(r)<<16)|((int)(g)<<8)|((int)(b)))

#ifdef __cplusplus
extern "C" {
#endif

int getScreenWidth();
int getScreenHeight();
CGFloat fitScreenW(CGFloat value);
CGFloat fitScreenH(CGFloat value);
CGFloat fitScaleScreen(CGFloat value);
CGFloat screenScale();



UIColor *UIColorRGB(uint32_t colorRGB);
UIColor *UIColorARGB(uint32_t colorRGB);


#ifdef __cplusplus
}
#endif


@interface UIAdaptor : NSObject

@end
