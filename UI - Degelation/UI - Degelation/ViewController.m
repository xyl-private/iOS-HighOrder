//
//  ViewController.m
//  UI - Degelation
//
//  Created by xyl-apple on 15/3/12.
//  Copyright (c) 2015年 zeepson. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"
/*
    委托
    有委托方 和 被委托方
 
*/
@interface ViewController ()<SecondDelegate>// 遵守被委托方的协议
@property (strong, nonatomic) IBOutlet UILabel *showLabel;

@end

@implementation ViewController
- (IBAction)goToSecond:(id)sender {
    //跳转第二界面
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    SecondViewController * svc = segue.destinationViewController;
    svc.delegate = self;// 告诉被委托方  我是委托人

}
// 实现委托方法  获得想要的数据
-(void)secondToOneValueDelegateWithValue:(NSString *)value{
    self.showLabel.text = value;

}

@end
