//
//  RACBindViewController.m
//  iOS - RAC
//
//  Created by xyanl on 2019/7/30.
//  Copyright © 2019 徐彦龙. All rights reserved.
//

#import "RACBindViewController.h"
#import <ReactiveObjC.h>
#import <RACReturnSignal.h>
@interface RACBindViewController ()
@property (weak, nonatomic) IBOutlet UITextField *bindTextField;

@end

@implementation RACBindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"RAC 进阶 - Bind";
    [self textFieldBind];
}

- (void) textFieldBind{
    // 假设想监听文本框的内容，并且在每次输出结果的时候，都在文本框的内容拼接一段文字“输出：”
    [self.bindTextField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"输出:%@",x);
    }];
    // 方式二:在返回结果前，拼接，使用RAC中bind方法做处理。
    // bind方法参数:需要传入一个返回值是RACStreamBindBlock的block参数
    // RACStreamBindBlock是一个block的类型，返回值是信号，参数（value,stop），因此参数的block返回值也是一个block。
    
    // RACStreamBindBlock:
    // 参数一(value):表示接收到信号的原始值，还没做处理
    // 参数二(*stop):用来控制绑定Block，如果*stop = yes,那么就会结束绑定。
    // 返回值：信号，做好处理，在通过这个信号返回出去，一般使用RACReturnSignal,需要手动导入头文件RACReturnSignal.h。
    
    // bind方法使用步骤:
    // 1.传入一个返回值RACStreamBindBlock的block。
    // 2.描述一个RACStreamBindBlock类型的bindBlock作为block的返回值。
    // 3.描述一个返回结果的信号，作为bindBlock的返回值。
    // 注意：在bindBlock中做信号结果的处理。
    
    // 底层实现:
    // 1.源信号调用bind,会重新创建一个绑定信号。
    // 2.当绑定信号被订阅，就会调用绑定信号中的didSubscribe，生成一个bindingBlock。
    // 3.当源信号有内容发出，就会把内容传递到bindingBlock处理，调用bindingBlock(value,stop)
    // 4.调用bindingBlock(value,stop)，会返回一个内容处理完成的信号（RACReturnSignal）。
    // 5.订阅RACReturnSignal，就会拿到绑定信号的订阅者，把处理完成的信号内容发送出来。
    
    // 注意:不同订阅者，保存不同的nextBlock，看源码的时候，一定要看清楚订阅者是哪个。
    // 这里需要手动导入#import <ReactiveCocoa/RACReturnSignal.h>，才能使用RACReturnSignal。
    
    [[self.bindTextField.rac_textSignal bind:^RACSignalBindBlock _Nonnull{
        return ^RACSignal * (id value , BOOL * stop){
            return [RACReturnSignal return:[NSString stringWithFormat:@"Bind输出 : %@",value]];
        };
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
}

@end
