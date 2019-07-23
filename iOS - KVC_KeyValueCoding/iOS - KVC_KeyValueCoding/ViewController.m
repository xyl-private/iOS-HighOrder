//
//  ViewController.m
//  iOS - KVC_KeyValueCoding
//
//  Created by xyl-apple on 15/3/20.
//  Copyright (c) 2015年 xyl. All rights reserved.
//

#import "ViewController.h"
#import "Father.h"
@interface ViewController ()

@end

@implementation ViewController
- (IBAction)cancel:(id)sender {
}
/*
    通过setValue 将给属性赋值
 
 
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    Father * fa = [[Father alloc]init];
    [fa setValue:@"张三" forKey:@"name"];
    [fa setValue:@"13" forKey:@"age"];
//    [fa setValue:@"男" forKey:@"sex"]; // 没有这个sex 属性   程序会崩溃
    
    NSLog(@"%@",[fa valueForKey:@"name"]);
    NSLog(@"%@",[fa valueForKey:@"age"]);
//     NSLog(@"%@",[fa valueForKey:@"sex"]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
