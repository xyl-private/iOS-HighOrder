//
//  ArcView.m
//  iOS - RAC
//
//  Created by xyanl on 2019/7/15.
//  Copyright © 2019 徐彦龙. All rights reserved.
//

#import "ArcView.h"
#import <ReactiveObjC/ReactiveObjC.h>
@interface ArcView()

@end

@implementation ArcView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor greenColor];
        [self setupUI];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor greenColor];
        [self setupUI];
    }
    return self;
}
- (void) setupUI{
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 50, 20)];
    [btn setTitle:@"按钮" forState:(UIControlStateNormal)];
    [btn setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:btn];
    [[btn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"rac action");
        
        self.name = [NSString stringWithFormat:@"%d",arc4random()%2000];
    }];
}

- (void)btnAction:(UIButton *)sender{
    NSLog(@"我点击了");
}
@end
