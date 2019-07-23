//
//  SecondViewController.m
//  UI - Degelation
//
//  Created by xyl-apple on 15/3/12.
//  Copyright (c) 2015年 zeepson. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()
@property (strong, nonatomic) IBOutlet UITextField *input;

@end

@implementation SecondViewController
- (IBAction)back:(id)sender {
    //将委托人的需求 写入 协议方法中
    [self.delegate secondToOneValueDelegateWithValue:self.input.text];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}





@end
