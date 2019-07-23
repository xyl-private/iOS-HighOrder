//
//  Student+Test.h
//  iOS - Category 分类
//
//  Created by xyl-apple on 15/4/12.
//  Copyright (c) 2015年 xyl. All rights reserved.
//

#import "Student.h"
/**
 *  （）代表着 分类
    ：代表着 继承
    （）中的是分类的名称
    Student 表示着  这个分类是Student的分类
 
    分类中只可以写方法  不可以添加属性
 */
@interface Student (Test)
-(void)test2;
@end
