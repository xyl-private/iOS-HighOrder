//
//  Button.h
//  iOS - Block回调01
//
//  Created by xyl-apple on 15/4/11.
//  Copyright (c) 2015年 xyl. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Button;
typedef void (^ButtonBlock) (Button * );
@interface Button : NSObject
@property(nonatomic,copy)ButtonBlock bb;
-(void)click;

@end
