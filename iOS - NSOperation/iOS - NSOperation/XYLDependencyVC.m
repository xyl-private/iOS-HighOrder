//
//  XYLDependencyVC.m
//  iOS - NSOperation
//
//  Created by xyanl on 2019/5/7.
//  Copyright © 2019 xyanl. All rights reserved.
//

#import "XYLDependencyVC.h"

@interface XYLDependencyVC ()
@property (strong, nonatomic) NSOperationQueue * queue;
@end

@implementation XYLDependencyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置依赖关系";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.queue = [[NSOperationQueue alloc] init];
    
    UIButton * dependencyBtn = [[UIButton alloc] initWithFrame:CGRectMake(80, 80, 150, 30)];
    [dependencyBtn setTitle:@"设置依赖关系" forState:(UIControlStateNormal)];
    dependencyBtn.backgroundColor = [UIColor redColor];
    
    [dependencyBtn addTarget:self action:@selector(dependencyAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:dependencyBtn];
    
    
    UIButton * addBtn = [[UIButton alloc] initWithFrame:CGRectMake(80,  130, 250, 30)];
    [addBtn setTitle:@" 添加" forState:(UIControlStateNormal)];
    addBtn.backgroundColor = [UIColor redColor];
    [addBtn addTarget:self action:@selector(addAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:addBtn];
    
    UIButton * pauseBtn = [[UIButton alloc] initWithFrame:CGRectMake(80,  180, 250, 30)];
    [pauseBtn setTitle:@"暂停" forState:(UIControlStateNormal)];
    pauseBtn.backgroundColor = [UIColor redColor];
    [pauseBtn addTarget:self action:@selector(pauseAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:pauseBtn];
    
    UIButton * resumeBtn = [[UIButton alloc] initWithFrame:CGRectMake(80,  230, 250, 30)];
    [resumeBtn setTitle:@"继续" forState:(UIControlStateNormal)];
    resumeBtn.backgroundColor = [UIColor redColor];
    [resumeBtn addTarget:self action:@selector(resumeAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:resumeBtn];
    
    
}

- (void) dependencyAction{
    NSLog(@"设置依赖关系");
    // 创建队列
    NSOperationQueue * queue = [[NSOperationQueue alloc] init];
    NSBlockOperation * blockOp1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"执行第1次操作,线程%@",[NSThread currentThread]);
    }] ;
    
    NSBlockOperation * blockOp2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"执行第2次操作,线程%@",[NSThread currentThread]);
    }] ;
    NSBlockOperation * blockOp3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"执行第3次操作,线程%@",[NSThread currentThread]);
    }] ;
    
    // 添加依赖关系
    [blockOp1 addDependency:blockOp2];
    [blockOp2 addDependency:blockOp3];
    [queue addOperation:blockOp1];
    [queue addOperation:blockOp2];
    [queue addOperation:blockOp3];
    
    
    /**
     输出结果是
     执行第3次操作
     执行第2次操作
     执行第1次操作
     
     是依次执行的顺序,最后添加依赖的最先执行
     
     
     
     */
}

// 添加 operation
- (void) addAction{
    // 设置操作的最大并发操作数
    self.queue.maxConcurrentOperationCount = 1;
    for (int i = 0; i < 20; i ++) {
        [self.queue addOperationWithBlock:^{
            // 模拟休眠
            [NSThread sleepForTimeInterval:1];
            NSLog(@"正在下载 %@ %d",[NSThread currentThread],i);
            if (i == 19) {
                NSLog(@"全部下载完成");
            }
        }];
    }
}

// 暂停
- (void) pauseAction{
    // 判断队列中是否有操作
    if (self.queue.operationCount == 0) {
        NSLog(@"没有操作");
        return;
    }
    
    // 如果没有被挂起,才需要暂停
    if (!self.queue.isSuspended) {
        NSLog(@"暂停");
        [self.queue setSuspended:YES];
    }else{
        NSLog(@"已经暂停");
    }
    
}
- (void) resumeAction{
    // 判断队列中是否有操作
    if (self.queue.operationCount == 0) {
        NSLog(@"没有操作");
        return;
    }
    
    // 如果没有被挂起,才需要暂停
    if (self.queue.isSuspended) {
        NSLog(@"继续");
        [self.queue setSuspended: NO];
    }else{
        NSLog(@"正在执行");
    }
    
    
}
@end
