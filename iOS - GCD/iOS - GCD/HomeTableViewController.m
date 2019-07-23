//
//  HomeTableViewController.m
//  GCD-Demo
//
//  Created by xyl_pro on 2017/4/14.
//  Copyright © 2017年 Xiaopeng_Service_Project. All rights reserved.
//

#import "HomeTableViewController.h"
#import "QueueGroupViewController.h"
@interface HomeTableViewController ()

@property (strong, nonatomic) dispatch_group_t group;
@property (strong, nonatomic) dispatch_queue_t queue;
@end

@implementation HomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    资料链接
    //https://my.oschina.net/hejunbinlan/blog/483909
    //http://blog.csdn.net/hello_hwc/article/details/54293280
    //https://www.jianshu.com/p/35ae27c6c192
    
    /**
     DISPATCH_QUEUE_SERIAL: 串行队列，填写 NULL时默认的就是串行队列,等待现在执行中的处理结果，队列中的任务是一个一个的依次执行的。
     DISPATCH_QUEUE_CONCURRENT：并发队列,不等待现在执行中的处理结果，首先执行第一个任务，不管第一个任务是否执行结束，都会开始执行后面的任务，如此重复循环。
     XNU 内核决定应道使用的线程数。
     
     
     同步线程:不会开辟新的线程,任务添加到队列中马上执行
     
     异步线程:开辟新的线程,将所有的任务都添加到队列好才会执行
     */
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                [self funcConcurrentSync];
                break;
            case 1:
                [self funcConcurrentAsync];
                break;
            case 2:
                [self funcSerialSync];
                break;
            case 3:
                [self fucnSerialAsync];
                break;
            case 4:
//                [self func];
                //主队列+同步   死锁
                [self funcMainSync];
                break;
            case 5:{
                dispatch_queue_t queue = dispatch_queue_create("test.queue", DISPATCH_QUEUE_CONCURRENT);
                dispatch_async(queue, ^{
                    /*
                     在其他线程中使用主队列 + 同步执行可看到：所有任务都是在主线程中执行的，并没有开启新的线程。而且由于主队列是串行队列，所以按顺序一个一个执行。
                     同时我们还可以看到，所有任务都在打印的syncConcurrent---begin和syncConcurrent---end之间，这说明任务是添加到队列中马上执行的。
                     */
                    [self funcMainSync];
                    
                });
            }break;
            case 6:
                [self funcMainAsync];
                break;
            case 7:
                [self func];
                break;
            default:
                break;
        }
    }else if (indexPath.section == 1){
        //         5. GCD线程之间的通讯
        [self gcdTong];
    }else if (indexPath.section == 2){
        switch (indexPath.row) {
            case 0:
                [self funcMethod1];
                break;
            case 1:
                [self funcMethod2];
                break;
            case 2:
                [self funcMethod3];
                break;
            case 3:
                [self funcMethod4];
                break;
            case 4:
                [self funcMethod5];
                break;
            case 5:
                [self funcMethod6];
                break;
            case 6:
                NSLog(@"信号量");
                [self funcMethod7];
                break;
            default:
                break;
        }
    }
    
    
}
#pragma mark - 4.GCD的基本使用
/**
 
 主队列:异步不会开辟新的线程
 并发队列:在当前的线程中执行,多个任务同时执行,
 
 串行队列:在当前的线程中执行,一个任务执行完之后再去执行下一个任务.
 
 
 同步:不会开辟新线程,任务是添加到队列中后马上执行的,执行完一个任务再执行下一个任务.
 异步:开辟新的线程,将所有的任务添加到队列后,n 个任务才同时执行,(在主队列里是不会开辟新的线程)
 */
- (void)func{
    dispatch_queue_t queue = dispatch_queue_create("funcConcurrentSync", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"线程 开始");
    dispatch_sync(queue, ^{
        
        NSLog(@"(1)func任务 begain =>%@",[NSThread currentThread]);
        [self funcSerialSync];
        NSLog(@"(1)func任务 end =>%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"(2)func任务 begain =>%@",[NSThread currentThread]);
        [self funcSerialSync];
        NSLog(@"(2)func任务 end =>%@",[NSThread currentThread]);
    });
    
    NSLog(@"线程 结束");
}

/**
 1. 并发队列 + 同步执行
 不会开启新线程，执行完一个任务，再执行下一个任务
 
 从并发队列 + 同步执行中可以看到，所有任务都是在主线程中执行的。由于只有一个线程，所以任务只能一个一个执行。
 同时我们还可以看到，所有任务都在打印的syncConcurrent---begin和syncConcurrent---end之间，这说明任务是添加到队列中马上执行的。
 */
- (void)funcConcurrentSync{
    //这里的名字能够方便开发者进行Debug   concurrent 是线程名字
//    dispatch_queue_t queue = dispatch_queue_create("funcConcurrentSync", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    NSLog(@"线程 开始");
    dispatch_sync(queue, ^{
        for (int i = 0 ; i < 3; i ++) {
            NSLog(@"(一)任务(%d)=>%@",i,[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0 ; i < 3; i ++) {
            NSLog(@"(二)任务(%d)=>%@",i,[NSThread currentThread ]);
        }
    });
    NSLog(@"线程 结束");
}


/**
 2. 并发队列 + 异步执行
 在并发队列 + 异步执行中可以看出，除了主线程，又开启了2个线程，并且任务是交替着同时执行的。
 另一方面可以看出，所有任务是在打印的syncConcurrent---begin和syncConcurrent---end之后才开始执行的。说明任务不是马上执行，而是将所有任务添加到队列之后才开始异步执行。
 */
- (void)funcConcurrentAsync{
    dispatch_queue_t queue = dispatch_queue_create("funcConcurrentAsync", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"funcConcurrentAsync 开始");
    dispatch_async(queue, ^{
        for (int i = 0 ; i < 3; i ++) {
            sleep(1);
            NSLog(@"(一)任务(%d)=>%@",i,[NSThread currentThread ]);
            
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0 ; i < 3; i ++) {
            sleep(1);
            NSLog(@"(二)任务(%d)=>%@",i,[NSThread currentThread ]);
            
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0 ; i < 3; i ++) {
            sleep(1);
            NSLog(@"(三)任务(%d)=>%@",i,[NSThread currentThread ]);
            
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0 ; i < 3; i ++) {
            sleep(1);
            NSLog(@"(四)任务(%d)=>%@",i,[NSThread currentThread ]);
            
        }
    });
    
    NSLog(@"funcConcurrentAsync 结束");
}


/**
 3. 串行队列 + 同步执行
 不会开启新线程，在当前线程执行任务。任务是串行的，执行完一个任务，再执行下一个任务
 在串行队列 + 同步执行可以看到，所有任务都是在主线程中执行的，并没有开启新的线程。而且由于串行队列，所以按顺序一个一个执行。
 同时我们还可以看到，所有任务都在打印的syncConcurrent---begin和syncConcurrent---end之间，这说明任务是添加到队列中马上执行的。
 */
- (void)funcSerialSync{
    NSLog(@"funcSerialSync start");
    dispatch_queue_t queue = dispatch_queue_create("funcSerialSync", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(queue, ^{
        for (int i = 0 ; i < 3; i ++) {
            NSLog(@"(一)任务(%d)=>%@",i,[NSThread currentThread ]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0 ; i < 3; i ++) {
            NSLog(@"(二)任务(%d)=>%@",i,[NSThread currentThread ]);
        }
    });
    
    
    NSLog(@"funcSerialSync end");
    
}

/**
 4. 串行队列 + 异步执行
 会开启新线程，但是因为任务是串行的，执行完一个任务，再执行下一个任务
 因为是串行队列,任务是要一个一个依次执行的,所以不需要开辟那么多新线程,一个新线程就可以满足需求了。
 另一方面可以看出，所有任务是在打印的syncConcurrent---begin和syncConcurrent---end之后才开始执行的。说明任务不是马上执行，而是将所有任务添加到队列之后才开始同步执行。
 */
- (void)fucnSerialAsync{
    NSLog(@"fucnSerialAsync start");
    dispatch_queue_t queue = dispatch_queue_create("fucnSerialAsync", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        for (int i = 0 ; i < 3; i ++) {
            NSLog(@"(一)任务(%d)=>%@",i,[NSThread currentThread ]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0 ; i < 3; i ++) {
            NSLog(@"(二)任务(%d)=>%@",i,[NSThread currentThread ]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0 ; i < 3; i ++) {
            NSLog(@"(三)任务(%d)=>%@",i,[NSThread currentThread ]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0 ; i < 3; i ++) {
            NSLog(@"(四)任务(%d)=>%@",i,[NSThread currentThread ]);
        }
    });
    
    NSLog(@"fucnSerialAsync end");
    
}

/**
 5. 主队列 + 同步执行
 
 互等卡住不可行(在主线程中调用)
 
 这时候，我们惊奇的发现，在主线程中使用主队列 + 同步执行，任务不再执行了，而且funcMainSync---end也没有打印。这是为什么呢？
 
 这是因为我们在主线程中执行这段代码。我们把任务放到了主队列中，也就是放到了主线程的队列中。而同步执行有个特点，就是对于任务是立马执行的。那么当我们把第一个任务放进主队列中，它就会立马执行。但是主线程现在正在处理funcMainSync方法，所以任务需要等funcMainSync执行完才能执行。而funcMainSync执行到第一个任务的时候，又要等第一个任务执行完才能往下执行第二个和第三个任务。
 
 那么，现在的情况就是funcMainSync方法和第一个任务都在等对方执行完毕。这样大家互相等待，所以就卡住了，所以我们的任务执行不了，而且funcMainSync---end也没有打印。
 
 要是如果不再主线程中调用，而在其他线程中调用会如何呢？
 
 不会开启新线程，执行完一个任务，再执行下一个任务（在其他线程中调用）
 */
- (void)funcMainSync{
    NSLog(@"funcMainSync---begin");
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_sync(queue, ^{
        for (int i = 0 ; i < 3; i ++) {
            NSLog(@"(一)任务(%d)=>%@",i,[NSThread currentThread ]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0 ; i < 3; i ++) {
            NSLog(@"(二)任务(%d)=>%@",i,[NSThread currentThread ]);
        }
    });
    
    
    NSLog(@"funcMainSync---end");
}

/**
 6. 主队列 + 异步执行
 
 只在主线程中执行任务，执行完一个任务，再执行下一个任务
 
 我们发现所有任务都在主线程中，虽然是异步执行，具备开启线程的能力，但因为是主队列，所以所有任务都在主线程中，并且一个接一个执行。
 另一方面可以看出，所有任务是在打印的syncConcurrent---begin和syncConcurrent---end之后才开始执行的。说明任务不是马上执行，而是将所有任务添加到队列之后才开始同步执行。
 */
- (void)funcMainAsync{
    NSLog(@"funcMainAsync---begin");
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    dispatch_async(queue, ^{
        for (int i = 0 ; i < 3; i ++) {
            NSLog(@"(一)任务(%d)=>%@",i,[NSThread currentThread ]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0 ; i < 3; i ++) {
            NSLog(@"(二)任务(%d)=>%@",i,[NSThread currentThread ]);
        }
    });
    
    NSLog(@"funcMainAsync---end");
}

#pragma mark - 6. GCD的其他方法

/**
 1. GCD的栅栏方法 dispatch_barrier_async
 
 我们有时需要异步执行两组操作，而且第一组操作执行完之后，才能开始执行第二组操作。这样我们就需要一个相当于栅栏一样的一个方法将两组异步执行的操作组给分割起来，当然这里的操作组里可以包含一个或多个任务。这就需要用到dispatch_barrier_async方法在两个操作组间形成栅栏。
 
 可以看出在执行完栅栏前面的操作之后，才执行栅栏操作，最后再执行栅栏后边的操作。
 */
- (void)funcMethod1{
    dispatch_queue_t queue = dispatch_queue_create("barrier_async", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        NSLog(@"----1-----%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"----2-----%@", [NSThread currentThread]);
    });
    
    dispatch_barrier_async(queue, ^{
        NSLog(@"----barrier-----%@", [NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"----3-----%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"----4-----%@", [NSThread currentThread]);
    });
}

/**
 2. GCD的延时执行方法 dispatch_after
 
 当我们需要延迟执行一段代码时，就需要用到GCD的dispatch_after方法。
 */
- (void)funcMethod2{
    NSLog(@"延时 2 秒钟-----开始");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 2秒后异步执行这里的代码...
        NSLog(@"run-----");
    });
}

/**
 3. GCD的一次性代码(只执行一次) dispatch_once
 
 我们在创建单例、或者有整个程序运行过程中只执行一次的代码时，我们就用到了GCD的dispatch_once方法。使用dispatch_once函数能保证某段代码在程序运行过程中只被执行1次。
 */
- (void)funcMethod3{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"只执行1次的代码(这里面默认是线程安全的)");
    });
}

/**
 4. GCD的快速迭代方法 dispatch_apply
 
 通常我们会用for循环遍历，但是GCD给我们提供了快速迭代的方法dispatch_apply，使我们可以同时遍历。比如说遍历0~5这6个数字，for循环的做法是每次取出一个元素，逐个遍历。dispatch_apply可以同时遍历多个数字。
 */
- (void)funcMethod4{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_apply(6, queue, ^(size_t index) {
        NSLog(@"%zd------%@",index, [NSThread currentThread]);
        //从输出结果中前边的时间中可以看出，几乎是同时遍历的。
    });
}

/**
 5. GCD的队列组 dispatch_group
 
 有时候我们会有这样的需求：分别异步执行2个耗时操作，然后当2个耗时操作都执行完毕后再回到主线程执行操作。这时候我们可以用到GCD的队列组。
 我们可以先把任务放到队列中，然后将队列放入队列组中。
 调用队列组的dispatch_group_notify回到主线程执行操作。
 */
- (void)funcMethod5{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("QueueGroup", 0);
    dispatch_group_async(group, queue, ^{
        // 执行1个耗时的异步操作
        for (int i = 0 ; i < 3; i ++) {
            NSLog(@"1.1==%d -> %@",i,[NSThread currentThread]);
            sleep(2);
            NSLog(@"1.2==%d -> %@",i,[NSThread currentThread]);
        }
    });
    dispatch_group_async(group, queue, ^{
        // 执行1个耗时的异步操作
        for (int i = 0 ; i < 3; i ++) {
            NSLog(@"2.1==%d ->  %@",i,[NSThread currentThread]);
            sleep(4);
            NSLog(@"2.2==%d ->  %@",i,[NSThread currentThread]);
        }
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 等前面的异步操作都执行完毕后，回到主线程...
        NSLog(@"都执行完成 %@",[NSThread currentThread]);
        
    });
}


/**
 队列组下载
 */
- (void)funcMethod6{
    QueueGroupViewController * queueC = [[QueueGroupViewController alloc] init];
    [self.navigationController pushViewController:queueC animated:YES];
}


/**
 gcd 信号量
 */
- (void)funcMethod7{
    self.group = dispatch_group_create();
    self.queue = dispatch_queue_create("QueueGroup", 0);
    
    [self funcMethod71];
    [self funcMethod72];
    
    dispatch_group_notify(self.group, dispatch_get_main_queue(), ^{
        // 等前面的异步操作都执行完毕后，回到主线程...
        NSLog(@"都执行完成 %@",[NSThread currentThread]);
        
    });
}
- (void)funcMethod71{
    dispatch_group_enter(self.group);
    dispatch_group_async(self.group, self.queue, ^{
        // 执行1个耗时的异步操作
            NSLog(@"1.1== -> %@",[NSThread currentThread]);
            sleep(2);
            NSLog(@"1.2== -> %@",[NSThread currentThread]);
        dispatch_group_leave(self.group);
    });
}
- (void)funcMethod72{
    dispatch_group_enter(self.group);
    dispatch_group_async(self.group, self.queue, ^{
        // 执行1个耗时的异步操作
            NSLog(@"2.1== ->  %@",[NSThread currentThread]);
            sleep(4);
            NSLog(@"2.2== ->  %@",[NSThread currentThread]);
        dispatch_group_leave(self.group);
    });
}



#pragma mark - 5. GCD线程之间的通讯
/**
 5. GCD线程之间的通讯
 
 在iOS开发过程中，我们一般在主线程里边进行UI刷新，例如：点击、滚动、拖拽等事件。我们通常把一些耗时的操作放在其他线程，比如说图片下载、文件上传等耗时操作。而当我们有时候在其他线程完成了耗时操作时，需要回到主线程，那么就用到了线程之间的通讯。
 */
- (void)gcdTong{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"1------%@",[NSThread currentThread]);
        }
        
        // 回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"2-------%@",[NSThread currentThread]);
        });
    });
    
}

@end
