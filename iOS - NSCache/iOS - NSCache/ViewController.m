//
//  ViewController.m
//  iOS - NSCache
//
//  Created by xyanl on 2019/5/17.
//  Copyright © 2019 xyanl. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSCacheDelegate>
{
    NSCache * _cache;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _cache = [[NSCache alloc] init];
    // 设置成本上限的数量, ps:当前 _cache缓存对象中存放的需要被缓存的对象最大个数
    _cache.countLimit = 10;
    
    _cache.delegate = self;
}

- (IBAction)saveCacheClick:(UIButton *)sender {
    [_cache removeAllObjects];
    for (int i = 0 ; i < 20; i++) {
        NSString * string = [NSString stringWithFormat:@"缓存图片 name:%d",i];
        // 将 string 对象存入_cache 中
        [_cache setObject:string forKey:@(i)];
        NSLog(@"缓存里面的数据---->%@",[_cache objectForKey:@(i)]);
    }
}
- (IBAction)showCacheClick:(UIButton *)sender {
    // _cache 是不可以被遍历的,只能通过 key 获取
    for (int i = 0 ; i < 20; i++) {
        NSLog(@"---->%@",[_cache objectForKey:@(i)]);
    }
}

// 缓存中的对象将要被移除时的回调
- (void)cache:(NSCache *)cache willEvictObject:(id)obj{
    NSLog(@"将要被移除的对象 ---> %@",obj);
}
@end
