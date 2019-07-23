//
//  ViewController.m
//  iOS - NSThread
//
//  Created by xyanl on 2019/5/5.
//  Copyright © 2019 xyanl. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (assign, nonatomic) int count;

@property (weak, nonatomic) IBOutlet UIImageView *showImageView;

@end

@implementation ViewController
- (IBAction)saleTickets:(id)sender {
    self.count = 20;
    NSThread * threadA = [[NSThread alloc] initWithTarget:self selector:@selector(sale:) object:@"1号售票口"];
    threadA.name = @"1号售票口";
    [threadA start];
    
    NSThread * threadB= [[NSThread alloc] initWithTarget:self selector:@selector(sale:) object:@"2号售票口"];
    threadB.name = @"2号售票口";
    [threadB start];
    
    NSThread * threadC = [[NSThread alloc] initWithTarget:self selector:@selector(sale:) object:@"3号售票口"];
    threadC.name = @"3号售票口";
    [threadC start];
    
}

- (void)sale:(NSString *) name{
    while (true) {
        [NSThread sleepForTimeInterval:1];
        @synchronized (self) {
            if (self.count >0) {
                self.count -- ;
                NSLog(@"<%@>售出一张,剩余%d",name,self.count);
            }else{
                NSLog(@"<%@>票卖光了",name);
                break;
            }
        }
    }
}

- (IBAction)downLoadImageClick:(UIButton *)sender {
    
    [NSThread detachNewThreadSelector:@selector(downloading) toTarget:self withObject:nil];
}

// 下载
- (void) downloading{
    NSLog(@"开始下载图片 %@",[NSThread currentThread]);
    //2.下载第一张图片
    
    NSString * imagePathStr = @"http://g.hiphotos.baidu.com/image/h%3D300/sign=e328dca175899e51678e3c1472a6d990/e824b899a9014c08b8d427f9047b02087af4f4fb.jpg";
    UIImage * image1 = [self downLoadImage:imagePathStr];
    NSLog(@"图片 1 下载结束");
    if (image1 != nil) {
        [self performSelectorOnMainThread:@selector(downloadingFinish:) withObject:image1 waitUntilDone:NO];
    }else{
        NSLog(@"图片下载失败");
    }
    
}

- (UIImage *)downLoadImage:(NSString *)path{
    NSURL * url = [NSURL URLWithString:path];
    NSData * data = [NSData dataWithContentsOfURL:url];
    return [UIImage imageWithData:data];
}

- (void) downloadingFinish:(UIImage *)image{
    self.showImageView.image = image;
    NSLog(@"downloadingFinish - > %@",[NSThread currentThread]);
}
- (void)viewDidLoad {
    [super viewDidLoad];
}
@end
