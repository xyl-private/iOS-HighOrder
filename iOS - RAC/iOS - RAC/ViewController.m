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
#import <RACEXTScope.h>
#import "TwoViewController.h"

typedef void(^Next)(id x);
@interface ViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textfiled;
@property (nonatomic, strong) ArcView * arcview;
@property (weak, nonatomic) IBOutlet UILabel *showLa;

@property (weak, nonatomic) IBOutlet UIButton *notifactionBtn;
@property (nonatomic, copy) Next next;
@end

@implementation ViewController
- (IBAction)notfactionAction:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"xyanlNotification" object:@"xyanlNotification"];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    RAC(self.showLa,text) = self.textfiled.rac_textSignal;

    
    
//    [self rac_dictionary];
    
//    [self rac_base];
    
//    [self rac_filter];
    
//    [self rac_ignoreValue];
    
//    [self rac_notification];
    
//    [self rac_textfiledDelegate];
    
//    [self normalButton_targetAction];
    [self rac_buttonAddTargetAction];
}


- (IBAction)pushButton:(id)sender {
    TwoViewController * two = [[TwoViewController alloc] init];
    // 替代代理回调
    two.twoSubject = [RACSubject subject];
    // TwoViewController 按钮触发事件 发送回的信号
    [two.twoSubject subscribeNext:^(id  _Nullable x) {
        NSLog(@"two 点了 按钮 x %@",x);
    }];
    [self.navigationController pushViewController:two animated:YES];
}


- (void) rac_base{
    // 1. 创建 signal 信号
    RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
       
        // 3.发送信号
        [subscriber sendNext:@"我是订阅者,我发送的消息"];
        
        // 发送 error 信号
        NSError * error = [NSError errorWithDomain:NSURLErrorDomain code:1001 userInfo:@{@"errorMsg":@"this is a error message"}];
        [subscriber sendError:error];
        
        // 4. 销毁 信号
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"signal 已经销毁");
        }];
    }];
    
    
    //2.1 订阅信号
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"接收 信号信息 %@",x);
    }];
    
    // 2.2 针对实际可能出现的逻辑错误,RAC 提供了订阅 error 信号
    [signal subscribeError:^(NSError * _Nullable error) {
        NSLog(@"error => %@",error);
    }];
    
}


/** 数组遍历 */
- (void) rac_array{
    NSArray * numbers = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7"];
    [numbers.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    // 遍历高级用法, map 映射  将数组中的值映射出来
    NSArray * arr = [[numbers.rac_sequence map:^id _Nullable(id  _Nullable value) {
        NSLog(@"value = %@",value);
        return value;
    }] array];
    NSLog(@"str = %@",arr);
}

 /** 字典元组遍历 */
- (void) rac_dictionary{
    NSDictionary *dict = @{@"name":@"xmg",@"age":@18};
    // 字典元组遍历
    [dict.rac_sequence.signal subscribeNext:^(RACTuple * x) {
        RACTupleUnpack(NSString * key , NSString * value)  =x ;// 解 元组
        NSLog(@"key : %@  value : %@ ",key,value);
        RACTwoTuple *tuple = (RACTwoTuple *)x;
        NSLog(@"key == %@, value == %@",tuple[0],tuple[1]);
    }];
    
    RACTuple * tu = RACTuplePack(@"1",@"2");
    NSLog(@"%@",tu.allObjects);
}


- (void) rac_filter{
    @weakify(self);
    
    [[self.textfiled.rac_textSignal filter:^BOOL(NSString * _Nullable value) {
        @strongify(self);
        if (self.textfiled.text.length >= 6) {
            self.textfiled.text = [self.textfiled.text substringToIndex:6];
            self.textfiled.text = @"已经到6位了";
            self.textfiled.textColor = [UIColor redColor];
        }
        return value.length >= 6;
    }] subscribeNext:^(NSString * _Nullable x) {
      // 订阅逻辑区域
        NSLog(@"filter过滤后的订阅内容%@",x);
    }];
}

- (void) rac_ignoreValue{
    [[self.textfiled.rac_textSignal ignoreValues] subscribeNext:^(id  _Nullable x) {
        // 将 self.textfiled 的所有 textSignal 全部都过滤掉
        NSLog(@"ignoreValues %@",x);
    }];
    
    [[self.textfiled.rac_textSignal ignore:@"h"] subscribeNext:^(id  _Nullable x) {
        //将self.testTextField的textSignal中字符串为指定条件的信号过滤掉
        NSLog(@"ignore: %@",x);
    }];
}

- (void)rac_notification
{
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"xyanlNotification" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        NSLog(@"%@",x.object);
        self.showLa.text = x.object;
    }];
    
}

- (void)rac_textfiledDelegate{
    [[self rac_signalForSelector:@selector(textFieldDidBeginEditing:) fromProtocol:@protocol(UITextFieldDelegate)] subscribeNext:^(RACTuple * _Nullable x) {\
        UITextField * tf = (UITextField *)x.first;
        NSLog(@"textField delegate == %@",tf.text);
    }];
    self.textfiled.delegate = self;
}

/**  按钮 触发 事件 */
- (void)normalButton_targetAction
{
    [self.notifactionBtn addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)tapAction:(UIButton *)sender
{
    NSLog(@"按钮点击了");
}

- (void) rac_buttonAddTargetAction{
    [[self.notifactionBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"rac 按钮点击了");
        NSLog(@"%@",x);
    }];
    
    self.showLa.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] init];
    [self.showLa addGestureRecognizer:tap];
    
    [tap.rac_gestureSignal subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        NSLog(@"手势触发的事件");
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end

