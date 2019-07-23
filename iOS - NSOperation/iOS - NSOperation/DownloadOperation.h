//
//  DownloadOperation.h
//  iOS - NSOperation
//
//  Created by xyanl on 2019/5/6.
//  Copyright © 2019 xyanl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@class DownloadOperation;

// 定义代理
@protocol  DownloadOperationDelegate<NSObject>

- (void) downLoadOperation:(DownloadOperation *) operation image:(UIImage *) image;

@end
@interface DownloadOperation : NSOperation
// 需要传入的图片
@property (strong, nonatomic) NSString * url;

//声明代理属性
/**声明代理属性*/
@property ( nonatomic, weak) id <DownloadOperationDelegate>  delegate;

@end

NS_ASSUME_NONNULL_END
