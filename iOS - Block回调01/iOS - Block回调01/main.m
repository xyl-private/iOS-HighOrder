//
//  main.m
//  iOS - Block回调01
//
//  Created by xyl-apple on 15/4/11.
//  Copyright (c) 2015年 xyl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Button.h"
void  func (){
    Button * but = [[Button alloc]init];
    
    //bb 是 ButtonBlock 类型的
    //ButtonBlock 是block 类型  参数是 button
    but.bb = ^(Button * bu){
        NSLog(@"回掉");
    };

    [but click];
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        func();
    }
    return 0;
}
