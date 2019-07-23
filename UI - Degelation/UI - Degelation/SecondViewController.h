//
//  SecondViewController.h
//  UI - Degelation
//
//  Created by xyl-apple on 15/3/12.
//  Copyright (c) 2015年 zeepson. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SecondViewController;
//创建个协议
@protocol SecondDelegate <NSObject>
//协议方法
-(void)secondToOneValueDelegateWithValue:(NSString * )value;

@end
@interface SecondViewController : UIViewController
@property(nonatomic,weak)id<SecondDelegate> delegate; //定义个委托人
@end
