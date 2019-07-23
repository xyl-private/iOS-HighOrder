//
//  Singeleton2.m
//  iOS - singleton单例模式
//
//  Created by xyl-apple on 15/4/15.
//  Copyright (c) 2015年 xyl. All rights reserved.
//

#import "Singeleton2.h"

@implementation Singeleton2
static Singeleton2 *sharedObj = nil; //第一步：静态实例，并初始化。

+ (Singeleton2*) sharedInstance  //第二步：实例构造检查静态实例是否为nil
{
    @synchronized (self)
    {
        if (sharedObj == nil)
        {
           sharedObj =  [[self alloc] init];
        }
    }
    return sharedObj;
}

+ (id) allocWithZone:(NSZone *)zone //第三步：重写allocWithZone方法
{
    @synchronized (self) {
        if (sharedObj == nil) {
            sharedObj = [super allocWithZone:zone];
            return sharedObj;
        }
    }
    return nil;
}

//- (id) copyWithZone:(NSZone *)zone //第四步
//{
//    return self;
//}
//
//- (id) retain
//{
//    return self;
//}
//
//- (unsigned) retainCount
//{
//    return UINT_MAX;
//}
//
//- (oneway void) release
//{
//    
//}
//
//- (id) autorelease
//{
//    return self;
//}
//- (id)init
//{
//    @synchronized(self) {
//        [super init];//往往放一些要初始化的变量.
//        return self;
//    }
//}
@end
