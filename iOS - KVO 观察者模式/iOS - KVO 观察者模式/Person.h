//
//  Person.h
//  iOS - KVO 观察者模式
//
//  Created by xyl-apple on 15/3/20.
//  Copyright (c) 2015年 xyl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Student.h"
@interface Person : NSObject
@property(nonatomic)int age;
@property(nonatomic,copy)NSString * name;

@property (strong, nonatomic) NSMutableArray * mArray;

@property (strong, nonatomic) Student * student;
@end
