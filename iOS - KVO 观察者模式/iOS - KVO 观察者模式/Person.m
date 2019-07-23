//
//  Person.m
//  iOS - KVO 观察者模式
//
//  Created by xyl-apple on 15/3/20.
//  Copyright (c) 2015年 xyl. All rights reserved.
//

#import "Person.h"

@implementation Person

-(instancetype)init{
    self = [super init];
    if (self) {
        self.mArray = [NSMutableArray array];
        self.student = [Student new];
    }
    return self;
}




// 重写 set 方法
- (void)setName:(NSString *)name{
    [self willChangeValueForKey:name];
    _name = name;
    [self didChangeValueForKey:name];
}

- (void)willChangeValueForKey:(NSString *)key{
    [super willChangeValueForKey:key];
}
- (void)didChangeValueForKey:(NSString *)key{
    [super didChangeValueForKey:key];
}


// 重写子集路径关联
+ (NSSet<NSString *> *)keyPathsForValuesAffectingValueForKey:(NSString *)key{
    NSSet * keySet = [super keyPathsForValuesAffectingValueForKey:key];
    if ([key isEqual:@"student"]) {
        // setWithObject:这个参数一定要有_  否则会崩溃
        NSSet * ageSet = [NSSet setWithObject:@"_student.age"];
        NSSet * nameSet = [NSSet setWithObject:@"_student.name"];
        keySet = [keySet setByAddingObjectsFromSet:ageSet];
        keySet = [keySet setByAddingObjectsFromSet:nameSet];
    }
    return keySet;
}

@end
