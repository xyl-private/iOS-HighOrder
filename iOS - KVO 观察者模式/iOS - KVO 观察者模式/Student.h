//
//  Student.h
//  iOS - KVO 观察者模式
//
//  Created by xyanl on 2019/5/16.
//  Copyright © 2019 xyl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Student : NSObject
@property (strong, nonatomic) NSString * name;
@property (assign, nonatomic) int age;

@end

NS_ASSUME_NONNULL_END
