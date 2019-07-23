//
//  ViewController.m
//  iOS - NSOperation
//
//  Created by xyanl on 2019/5/6.
//  Copyright © 2019 xyanl. All rights reserved.
//
/**
 一、NSOperation 简介
 
 得知任务当前状态,NSOperationd 提供了 4 个属性来判断.
 
 @property (readonly, getter=isCancelled) BOOL cancelled;// 取消
 @property (readonly, getter=isExecuting) BOOL executing; // 运行
 @property (readonly, getter=isFinished) BOOL finished;  // 完成
 @property (readonly, getter=isReady) BOOL ready;//  就绪
 
 
 // 开启 NSOperation 对象的执行
 - (void)start;
 
 // 执行非并发的任务,此方法被默认实现,也可以重写此方法来执行多次需要执行的任务
 - (void)main;
 
 // 取消当前 NSOperation 任务
 - (void)cancel;
 
 // 添加任务的依赖,当依赖的任务执行完毕后,才会执行当前任务,
 - (void)addDependency:(NSOperation *)op;
 
 //取消任务的依赖,依赖的任务关系不会自动消除,必须调用该方法.
 - (void)removeDependency:(NSOperation *)op;
 
 //当前  NSOperation 执行完毕后,设置想要执行的操作
 @property (nullable, copy) void (^completionBlock)(void) API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0));
 
 
 1.执行操作
 2.取消操作
 当操作开始执行之后,默认会一直执行知道完成,但是也可以调用 cancel 方法中途取消操作的执行.当然,这个操作并非常见的取消,实质上取消操作是按照如下方式作用的:
 如果这个操作在队列中没有执行,而这个时候取消这个操作,并将状态 finished 设置为 YES,那么这时的取消就是直接取消了;如果这个操作已经在执行,则只能等待这个操作完成,调用 cancel 方法也只是将 isCancellede 的状态设置为 YES.
 因此,开发者应该在每个操作开始前,或者在每个有意义的实际操作完成后,先检查下这个属性是不是已经设置为 YES,如果是 YES,则后面的操作可以不必再执行了.
 3.添加依赖
 NSOperation 中可以将操作分解为若干个小任务,通过添加他们之间的依赖关系进行操作,就可以对添加的操作设置优先级.
 注:两个任务间不能添加相互依赖,如 A依赖 B,同时 B 又依赖 A,这样会造成死锁,在每个操作完成时,需要将 isFinished 设置为 YES,不然后续的操作是不会开始执行的.
 4.监听操作
 如果想在一个 NSOperation 执行完毕后做一些其他的事情,就调用 setCompletionBlock: 方法来这只想做的事情.
 
 二、NSOperationQueue 简介
 NSOperationQueue 类s的实例代表一个队列，与 GCD 中的队列一样，先进先出，负责管理多个 NSOperation 对象，NSOperationQueue 底层维护一个线程池，会按照NSOperation 对象添加到队列中的顺序来启动相应的线程。
 
 NSOperationQueue 类的常用方法
 1.添加 NSOperation 到 NSOperationQueue 中
 2.修改 NSOperation 对象的执行书序
 执行顺序取决于以下两点:
 (1).查看NSOperation 对象是否已经就绪,这个是由对象的依赖关系确定的。
 (2).根据所有 NSOperation 对象的相对优先级别来确定执行顺序。
 NSOperation 提供了 queuePriority 属性，用于改变添加到队列中的 NSOperation 对象的优先级，
  @property NSOperationQueuePriority queuePriority;

 typedef NS_ENUM(NSInteger, NSOperationQueuePriority) {
 NSOperationQueuePriorityVeryLow = -8L, // 非常低
 NSOperationQueuePriorityLow = -4L, // 低
 NSOperationQueuePriorityNormal = 0, // 一般
 NSOperationQueuePriorityHigh = 4, // 高
 NSOperationQueuePriorityVeryHigh = 8 // 非常高
 };
 
 优先级不能代替依赖关系，优先级只是对已经准备好的NSOperation对象确定执行顺序。在执行中先满足依赖关系，然后在根据优先级从所有准备好的操作中选择优先级最高的那个执行。
 
 
 3. 设置或者获取队列的最大并发操作数量
 队列中的线程过多时，会影响到应用的执行效率。通过设置队列的最大并发操作数量，可以约束队列中线程的个数，这样就可以设置队列中最多支持多少个并发线程。
 
 @property NSInteger maxConcurrentOperationCount;
 
 当maxConcurrentOperationCount 设为 1 时,表示队列每次智能执行一个操作,但是串行化的 NSOperationQueue 并不等同于 GCD 中的串行 Dispatch Queue.
 
 4.等待 NSOperation 操作执行完成
 // 会阻塞当前线程,等到某个 NSOperation 执行完毕
 [operation waitUntilFinished];
 注：operation表示一个操作，该操作会等到其余的某个操作执行完毕后再执行。应注意避免编写这样的代码，这不仅影响整个应用的并发性，而且也降低了用户的体验。
 
 
 //会阻塞当前线程,等待queue 的所有操作执行完毕
 [queue waitUntilAllOperationsAreFinished];
注：在等待一个queue时，应用的其他线程仍然可以向队列中添加其他操作，因此可能会加长线程的等待时间。绝对不要在应用的主线程中等待一个或者多个NSOperation，而要在子线程中，否则主线程阻塞会导致应用无法响应用户事件，应用也将表现为无响应。
 
 
 5.暂停和继续 NSOperationQueue 队列
 如果想临时暂停队列中所有的 NSOperation 操作的执行，可以将suspended设置为 YES。
 @property (getter=isSuspended) BOOL suspended;
 注意的是，暂停一个Queue队列不会导致正在执行的NSOperation操作在中途暂停，只是简单地阻止调度新的NSOperation操作的执行。
 
 使用NSOperation 子类操作
 1.NSInvocationOperation 类用于将特定对象的特定方法封装成NSOperation,基于一个对象和 selector 来创建操作。
 2.NSBlockOperation 类用于将代码块封装成 NSOperation，能够并发的执行一个或者多个 block 对象，所有相关的 block 代码块都执行完成之后，操作才算完成。
 通过调用start方法来开启线程,但是operation添加的3个block是并发执行,也就是在不同的线程中执行,因此,当同一个操作中的任务量大于1时,该操作会实现异步执行.
 
 */
#import "ViewController.h"
#import "DownloadOperation.h"
#import "XYLDependencyVC.h"
@interface ViewController ()<DownloadOperationDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *showImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)invocationOperationClick:(UIButton *)sender {
    // 创建操作
    NSInvocationOperation * invocation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(downloading) object:nil];
    // 创建队列
    NSOperationQueue * queue = [[NSOperationQueue alloc] init];
    // 将操作添加到队列中,会自动异步执行
    [queue addOperation:invocation];
   // [invocation start];// 使用同步执行
    
}
- (IBAction)blockOperation:(id)sender {
    NSBlockOperation * operation = [[NSBlockOperation alloc] init];
    [operation addExecutionBlock:^{
        NSLog(@"-- 下载图片--1--%@",[NSThread currentThread]);
    }];
    [operation addExecutionBlock:^{
        NSLog(@"-- 下载图片--2--%@",[NSThread currentThread]);
    }];
    [operation addExecutionBlock:^{
        NSLog(@"-- 下载图片--3--%@",[NSThread currentThread]);
    }];
    [operation start];
    
}
- (void) downloading{
    NSLog(@"downloading - > %@",[NSThread currentThread]);
}

// 自定义 NSOperation 子类
- (IBAction)custormOperationClick:(UIButton *)sender {
    // 创建队列
    NSOperationQueue * queue = [[NSOperationQueue alloc] init];
    //创建 operation
    DownloadOperation * op = [[DownloadOperation alloc] init];
    op.url = @"http://g.hiphotos.baidu.com/image/h%3D300/sign=e328dca175899e51678e3c1472a6d990/e824b899a9014c08b8d427f9047b02087af4f4fb.jpg";
    op.delegate = self;
    // 添加到队列
    [queue addOperation:op];
}
- (void)downLoadOperation:(DownloadOperation *)operation image:(UIImage *)image{
    self.showImageView.image = image;
}
- (IBAction)setDependencyClick:(id)sender {
    XYLDependencyVC * vc = [[XYLDependencyVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
