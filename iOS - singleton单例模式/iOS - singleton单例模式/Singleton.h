//
//  Singleton.h
//  iOS - singleton单例模式
//
//  Created by xyl-apple on 15/3/20.
//  Copyright (c) 2015年 xyl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Singleton : NSObject
+ (Singleton * )sharedManager;
@end
