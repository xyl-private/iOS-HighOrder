//
//  main.m
//  iOS - Block 基础
//
//  Created by xyl-apple on 15/4/11.
//  Copyright (c) 2015年 xyl. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  将block MySum 定义成Block 类型
 */
typedef int (^MySum)(int ,int );

void func (){
    /**
     *  声明MySum 类型的变量
        MySum 是 block 类型
     */
    
    MySum sum = ^(int a , int b ){
        
        return a+b;
    };

    NSLog(@"block变量 ==== > %d",sum(12,31));
    
}




//block做参数的使用
int func1(int(^myBlock)(int),int c ,int b) {
    int a = c + myBlock(b) ;
    NSLog(@"func1   %d",myBlock(b));
    return a ;
}
void func3 (){
    int outA = 8;
    int (^myPtr)(int) = ^(int a){
        return outA + a;
    }; //block里面可以读取同一类型的outA的值
    
    outA = 5;  //在调用myPtr之前改变outA的值
    int result = myPtr(3);  // result的值仍然是11，并不是8
    NSLog(@"result=%d", result);
    
    //需要注意的是，这里copy的值是变量的值，如果它是一个记忆体的位置（地址），换句话说，就是这个变量是个指针的话，那么地址是不变的，地址上的值是会改变的
    
    //它的值是可以在block里被改变的。如下例子：
    NSMutableArray *mutableArray = [NSMutableArray arrayWithObjects:@"one", @"two", @"three", nil];
    
    int result1 = ^(int a){
        [mutableArray removeLastObject];
        return a*a;
    }(5);
    NSLog(@"test array :%@", mutableArray);
}
void func4(){
    //当变量是static 类型的时候  就不会copy了  也可以在block主体里面的修改该变量
    //        static int outA = 8;
    __block int outA = 9;
    int (^myPtr)(int) = ^(int a){
        outA = 10*2;
        return outA + a;
    };
    //        outA = 5;
    int result = myPtr(3);  //result的值是8，因为outA是static类型的变量
    NSLog(@"result=%d", result);
    
}

//在某个变量前面如果加上修饰字“__block”的话（注意，block前面有两个下划线），这个变量就称作block variable。

//那么在block里面就可以任意修改此变量的值，如下代码：
void func5(){
    __block int num = 5;
    
    int (^myPtr)(int) = ^(int a){return num++;};
    int (^myPtr2)(int) = ^(int a){return num++;};
    int result = myPtr(0);
    NSLog(@"result=%d", result);//result的值为5，num的值为6
    result = myPtr2(0);      //result的值为6，num的值为7
    NSLog(@"result=%d", result);
    
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        //回传值(^名字)(参数列);
        int (^myblcok) (int) = ^(int a ){ return  a*a;};
        
        int a = myblcok(5);
        NSLog(@"%d %d ",a,myblcok(5));
        
        int b =^(int a ){ return  a*a;}(2);
        
        NSLog(@"%d",b);
        
        int k = func1(myblcok,2,4);
        NSLog(@"%d",k);
        
        //        func2();
        func3();
        func4();
        func5();
        
        func();
    }
    return 0;
}

