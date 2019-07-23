//
//  QueueGroupViewController.m
//  iOS - GCD
//
//  Created by xyanl on 2019/4/29.
//  Copyright © 2019 xyanl. All rights reserved.
//

#import "QueueGroupViewController.h"

@interface QueueGroupViewController ()

@property (strong, nonatomic) UIImageView * imageView;
@end

@implementation QueueGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.imageView];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       
    });
     [self func];
}

- (void) func{
    //1.创建一个队列和组
    dispatch_queue_t queue = dispatch_queue_create("queue", 0);
    dispatch_group_t group = dispatch_group_create();
    //2.下载第一张图片
    __block UIImage * image1 = nil;
    dispatch_group_async(group, queue, ^{
        NSString * imagePathStr = @"http://g.hiphotos.baidu.com/image/h%3D300/sign=e328dca175899e51678e3c1472a6d990/e824b899a9014c08b8d427f9047b02087af4f4fb.jpg";
        image1 = [self downLoadImage:imagePathStr];
        NSLog(@"图片 1 下载结束");
    });
    
    //3.下载第二张图片
    __block UIImage * image2 = nil;
    dispatch_group_async(group, queue, ^{
        NSString * imagePathStr = @"http://www.socialmediaportal.com/Data/News/00027209/Baidu-logo-small.jpeg";
        image2 = [self downLoadImage:imagePathStr];
        NSLog(@"图片 2 下载结束");
    });
    
    __block UIImage * fullImg = nil;
    //4.合并图片
    dispatch_group_async(group, queue, ^{
        //4.1 开启一个位图上下文
        UIGraphicsBeginImageContextWithOptions(image1.size, NO, 0.0);
        //4.2 绘制第一张图
        CGFloat image1W = 200;
        CGFloat image1H = 400;
        [image1 drawInRect:CGRectMake(0, 0,image1W, image1H)];
        //4.3 绘制第二张图
        [image2 drawInRect:CGRectMake(0, 0, 50, 25)];
        
        //4.4 得到上下文的图片
        UIImage * fullImage = UIGraphicsGetImageFromCurrentImageContext();
        
        //4.5 结束上下文
        UIGraphicsEndImageContext();
        NSLog(@"图片 合成结束");
        fullImg = fullImage;
    });
    
    dispatch_group_notify(group, queue, ^{
        NSLog(@"%@",[NSThread currentThread]);
        //4.6 回到主线程显示图片
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = fullImg;
            NSLog(@"图片显示");
        });
    });
}

- (UIImage *)downLoadImage:(NSString *)path{
    NSURL * url = [NSURL URLWithString:path];
    NSData * data = [NSData dataWithContentsOfURL:url];
    return [UIImage imageWithData:data];
}

- (UIImageView *)imageView{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 400)];
        _imageView.center = self.view.center;
        _imageView.backgroundColor = [UIColor redColor];
    }
    return _imageView;
}
@end
