//
//  HomeTableViewController.h
//  GCD-Demo
//
//  Created by xyl_pro on 2017/4/14.
//  Copyright © 2017年 Xiaopeng_Service_Project. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableViewController : UITableViewController
/**
 为什么要用GCD呢？

 因为GCD有很多好处啊，具体如下：

 GCD可用于多核的并行运算
 GCD会自动利用更多的CPU内核（比如双核、四核）
 GCD会自动管理线程的生命周期（创建线程、调度任务、销毁线程）
 程序员只需要告诉GCD想要执行什么任务，不需要编写任何线程管理代码
 既然GCD有这么多的好处，那么下面我们就来系统的学习一下GCD的使用方法。
 
 多线程原理
 同一时间，CPU只能处理1条线程，只有1条线程在工作（执行）
 多线程并发（同时）执行是假象，其实是快速地在多个线程之间调度（切换）
 如果CPU调度线程的时间足够快，就造成了多线程并发执行的假象
 
 多线程优点

 能适当提高程序的执行效率
 能适当提高资源利用率（CPU\内存利用率）
 
 多线程的缺点
 
 创建线程是有开销的，iOS下主要成本包括：内核数据结构（大约1kb）、栈空间（子线程512kb，主线程1MB,也可以使用-setStackSize:设置，但必须是4k的倍数，而且最小是16k）,创建线程大约需要90毫秒的创建时间
 如果开启大量的线程，会降低程序的性能
 线程越多，CPU在调度线程的开销就越大
 程序设计更加复杂：比如线程之间的通信、多线程的数据共享

 */
@end
