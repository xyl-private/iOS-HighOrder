//
//  TwoViewController.m
//  iOS - RAC
//
//  Created by xyanl on 2019/7/29.
//  Copyright © 2019 徐彦龙. All rights reserved.
//

#import "TwoViewController.h"
#import <Masonry.h>
#import <ReactiveObjC.h>
@interface TwoViewController ()
@property (nonatomic, strong) UIButton * myBtn;
@end

@implementation TwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.myBtn.frame = CGRectMake(20, 120, 30, 20);
}

- (UIButton *) myBtn
{
    if(_myBtn == nil)
    {
        UIButton * btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [btn setTitle:@"点我" forState:(UIControlStateNormal)];
        [btn setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
        btn.adjustsImageWhenHighlighted = NO;// 点击后不高亮
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn addTarget:self action:@selector(myBtnAction) forControlEvents:(UIControlEventTouchUpInside)];
        _myBtn = btn;
        [self.view addSubview:btn];
    }
    return _myBtn;
}

- (void)myBtnAction{
    NSLog(@"你选了我,");
    if (self.twoSubject) {
        [self.twoSubject sendNext:[NSString stringWithFormat:@"%d",arc4random()%100]];
    }
}

- (void)dealloc{
    NSLog(@"dealloc - %s",__func__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
