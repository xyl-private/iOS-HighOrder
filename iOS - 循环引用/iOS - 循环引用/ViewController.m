//
//  ViewController.m
//  iOS - 循环引用
//
//  Created by xyanl on 2019/7/30.
//  Copyright © 2019 xyanl. All rights reserved.
//

#import "ViewController.h"
#import "Student.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
//
//    Student *student = [[Student alloc]init];
//
//    student.name = @"Hello World";
//
//    __block Student *stu = student;
//
//    student.study = ^{
//
//        NSLog(@"my name is = %@",stu.name);
//
//        stu = nil;
//
//    };
//    student.study();
    
    
    Student *student = [[Student alloc]init];
    
    student.name = @"Hello World";
    
    __weak typeof(student) weakSelf = student;
    
    student.study = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    NSLog(@"my name is = %@",weakSelf.name);
        }); 
    };
    student.study();
}
@end
