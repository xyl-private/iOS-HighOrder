//
//  main.m
//  iOS - Category 分类
//
//  Created by xyl-apple on 15/4/12.
//  Copyright (c) 2015年 xyl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Student.h"
#import "Student+Test.h"
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        Student * stu = [[Student alloc]init];
        [stu test1];//student 中的方法
        [stu test2];//分类category 中的方法
        [stu test3];
    }
    return 0;
}
