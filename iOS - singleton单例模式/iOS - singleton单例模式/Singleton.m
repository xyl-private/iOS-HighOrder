//
//  Singleton.m
//  iOS - singleton单例模式
//
//  Created by xyl-apple on 15/3/20.
//  Copyright (c) 2015年 xyl. All rights reserved.
//
/**
 *  1.单例模式的要点：
 
 　　显然单例模式的要点有三个；
    一是某个类只能有一个实例；
    二是它必须自行创建这个实例；
    三是它必须自行向整个系统提供这个实例。
 
    2.单例模式的优点：
 
 　　1.实例控制：Singleton 会阻止其他对象实例化其自己的 Singleton 对象的副本，从而确保所有对象都访问唯一实例。
 　　2.灵活性：因为类控制了实例化过程，所以类可以更加灵活修改实例化过程


 
    IOS中的单例模式
 　　在objective-c中要实现一个单例类，至少需要做以下四个步骤：
 　　1、为单例对象实现一个静态实例，并初始化，然后设置成nil，
 　　2、实现一个实例构造方法检查上面声明的静态实例是否为nil，如果是则新建并返回一个本类的实例，
 　　3、重写allocWithZone方法，用来保证其他人直接使用alloc和init试图获得一个新实力的时候不产生一个新实例，
 　　4、适当实现allocWitheZone，copyWithZone，release和autorelease。
 */
#import "Singleton.h"

@interface Singleton ()

@end

@implementation Singleton

static Singleton * shareSingleton = nil;

+(Singleton * )sharedManager{

    if (shareSingleton == nil) {
//        shareSingleton = [[Singleton alloc]init];
        shareSingleton = [[self alloc]init];
    }
    return shareSingleton;
}
+ (id)sharedInstance {
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        shareSingleton = [[self alloc] init];
    });
    
    return shareSingleton;
}

@end
