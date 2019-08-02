//
//  Student.h
//  iOS - 循环引用
//
//  Created by xyanl on 2019/7/30.
//  Copyright © 2019 xyanl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^Study)(void);

@interface Student : NSObject

@property (copy , nonatomic) NSString *name;

@property (copy , nonatomic) Study study;
@end

NS_ASSUME_NONNULL_END
