//
//  pageInstructionViewController.h
//  bash
//
//  Created by 胡旭 on 16/3/29.
//  Copyright © 2016年 胡旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface pageInstructionViewController : UIViewController <UIScrollViewDelegate>

- (id)initWithImages:(NSArray *)imageArray withTitles:(NSArray *)titleArray withDes:(NSArray *)desArray;


@end
