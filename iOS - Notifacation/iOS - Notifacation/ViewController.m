//
//  ViewController.m
//  iOS - Notifacation
//
//  Created by xyanl on 2019/5/8.
//  Copyright © 2019 xyanl. All rights reserved.
//

#import "ViewController.h"
#import "AlarmClockVC.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)alarmClockAction:(UIButton *)sender {
    AlarmClockVC * vc = [[AlarmClockVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
