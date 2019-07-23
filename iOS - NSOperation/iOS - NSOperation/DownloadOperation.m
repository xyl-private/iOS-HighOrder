//
//  DownloadOperation.m
//  iOS - NSOperation
//
//  Created by xyanl on 2019/5/6.
//  Copyright © 2019 xyanl. All rights reserved.
//

#import "DownloadOperation.h"

@implementation DownloadOperation
//重写 main 方法
- (void)main{
    @autoreleasepool {
        // 获取下载图片的 URL
        NSURL * url = [NSURL URLWithString:self.url];
        // 从网络下载图片
        NSData * data = [NSData dataWithContentsOfURL:url];
        // 生成图片
        UIImage * image = [UIImage imageWithData:data];
        
        // 在主操作队列通知调用方更新 UI
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSLog(@"图片下载完成......");
            if ([self.delegate respondsToSelector:@selector(downLoadOperation:image:)]) {
                [self.delegate downLoadOperation:self image:image];
            }
        }];
        
    }
}

@end
