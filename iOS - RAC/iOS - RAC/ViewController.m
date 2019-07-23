//
//  ViewController.m
//  iOS - RAC
//
//  Created by xyanl on 2019/7/15.
//  Copyright © 2019 徐彦龙. All rights reserved.
//

#import "ViewController.h"
#import "ArcView.h"
#import <ReactiveObjC.h>

typedef void(^Next)(id x);
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textfiled;
@property (nonatomic, strong) ArcView * arcview;

@property (nonatomic, copy) Next next;
@end

@implementation ViewController

- (void)sendNext:(id)value {
    @synchronized (self) {
        void (^nextBlock)(id) = [self.next copy];
        if (nextBlock == nil) return;
        
        nextBlock(value);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.next(@"20");
    [self sendNext:@"30"];
    
    self.next = ^(id x) {
        NSLog(@"x %@",x);
    };
//    self.arcview = [[ArcView alloc] initWithFrame:CGRectMake(20, 80, 100, 100)];
//    [self.view addSubview:self.arcview];
//    RACSignal * signal = [self createSignal];
//    [signal subscribeNext:^(id  _Nullable x) {
//        NSLog(@"aaa");
//    }];
//    [self.textfiled.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
//        NSLog(@"x %@",x);
//    }];
    
//    [[self.arcview rac_signalForSelector:@selector(btnAction:)] subscribeNext:^(RACTuple * _Nullable x) {
//        NSLog(@"你竟然响应我了 厉害了");
//        NSLog(@"%@",x);
//    }];
//
//    [RACObserve(self.arcview, name) subscribeNext:^(id  _Nullable x) {
//        NSLog(@"我的名字:%@",x);
//    }];
//
//    [[self.textfiled rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
//        NSLog(@"textfiled %@",x);
//    }];
//
//    [[self.textfiled rac_signalForControlEvents:(UIControlEventEditingDidEnd)] subscribeNext:^(__kindof UIControl * _Nullable x) {
//        UITextField * tf = (UITextField *)x;
//        NSLog(@"changed %@",tf.text);
//    }];
//
//    [[self.textfiled.rac_textSignal filter:^BOOL(NSString * _Nullable value) {
//        return value.length > 5;
//    }] subscribeNext:^(NSString * _Nullable x) {
//
//        NSLog(@"%@",x);
//    }];
}

- (RACSignal *) createSignal{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"signal created");
        return nil;
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
