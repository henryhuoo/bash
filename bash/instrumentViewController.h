//
//  instrumentViewController.h
//  bash
//
//  Created by 胡旭 on 16/3/30.
//  Copyright © 2016年 胡旭. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol instrumentViewControllerDelegate <NSObject>

- (void)clickConfirmButton:(NSString *)hint;

@end

@interface instrumentViewController : UIViewController
@property id <instrumentViewControllerDelegate> delegate;

- (id)initWithImage:(UIImage *)image withTitle:(NSString *)title withDes:(NSString *)des;
- (id)initWithImage:(UIImage *)image withTitle:(NSString *)title withDes:(NSString *)des withHint:(NSString *)hint;


@end
