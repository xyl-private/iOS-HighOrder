//
//  ViewController.m
//  iOS - KVO 观察者模式
//
//  Created by xyl-apple on 15/3/20.
//  Copyright (c) 2015年 xyl. All rights reserved.
//
/**
 IOS中观察者模式的实现方式：
 在iOS中观察者模式的实现有三种方法：Notification、KVO以及标准方法。
 
 
 KVO 实现原理
 利用运行时,系统会自动创建一个被观察者对象(A)的子类(B),B 类是以 NSKVONotifying_ 开头的 NSKVONotifying_A类,再将A 的 isa 指针指向了 B,重写 set 方法,在 set 方法中
 */
#import "ViewController.h"
#import "Person.h"
#import <objc/runtime.h>

#import "Student.h"
@interface ViewController ()
@property(nonatomic,copy)NSString * age;
@property(nonatomic,strong)Person * per;
@end

@implementation ViewController
-(IBAction)cancelKVO:(id)sender{
    //移除观察
    [self.per removeObserver:self forKeyPath:@"age"];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //实例化被观察的属性
    self.per = [[Person alloc]init];
    self.per.name = @"找死";
    
    // 注册,指定被观察者的属性
    // 打印被观察对象的类名,对比前后结果可以看出,指针地址没有改变,类名变了,也就证明了,被观察者的 isa 指针指向了他的子类
    NSLog(@"before : %s   指针地址:%p",object_getClassName(self.per),self.per);
    //查看注册观察者前 对象的子类
    NSLog(@"before:subClasses --> %@",[ViewController findSubClass:[self.per class]]);
    //    [self.per  addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew |NSKeyValueObservingOptionOld context:nil];
    NSLog(@"after : %s   指针地址:%p",object_getClassName(self.per),self.per);
    //查看注册后观察者 对象的子类, 输出结果表明新增一个NSKVONotifying_Person的子类
    NSLog(@"before:subClasses --> %@",[ViewController findSubClass:[self.per class]]);
    
    
    
    // 观察容器类
    //    [self.per addObserver:self forKeyPath:@"mArray" options:(NSKeyValueObservingOptionNew) context:nil];
    // 这样添加时监测不到变化的,因为监测是再重写的set方法中,而addObject不会调用set方法,这里需要用KVC来赋值
    // KVC 是 KVO的入口
    //[self.per.mArray addObject:@"one"];
    NSMutableArray * marr = [self.per mutableArrayValueForKeyPath:@"mArray"];
    [marr addObject:@"two"];
    NSLog(@"self.per.mArray -> %@",self.per.mArray);
    
    
    // 观察 被观察者里面的类
    //子路径来观察到,但是当属性多的话,会写很多的注册方法,这样很麻烦
    //    [self.per addObserver:self forKeyPath:@"student.name" options:(NSKeyValueObservingOptionNew) context:nil];
    //为了避免f麻烦可以重写子集路径关联
    [self.per addObserver:self forKeyPath:@"student" options:(NSKeyValueObservingOptionNew) context:nil];
    
    self.per.student.name = @"找三生三世";
    self.per.student.age = 12;
    
    
}
//实现回调方法
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"name"]) {
        NSLog(@"name -> new %@",[change objectForKey:@"new"]);
        NSLog(@"name -> old %@",[change objectForKey:@"old"]);
    }if ([keyPath isEqualToString:@"mArray"]){
        NSLog(@"mArray -- new : %@",change);
    }if ([keyPath isEqualToString:@"student"]){
        Student * stu = change[@"new"];
        NSLog(@"student -- new : name:%@ age:%d",stu.name,stu.age);
    }else{
        NSLog(@"----..%@",[change objectForKey:@"new"]);
    }
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([self.per.name isEqualToString: @""]) {
        self.per.name = @"张三";
    }else{
        self.per.name = [self.per.name stringByAppendingString:@"a"];
    }
    self.per.age ++;
    
}


+ (NSArray *) findSubClass:(Class)defaultClass{
    int count = objc_getClassList(NULL, 0);
    if (count < 0) {
        return [NSArray array];
    }
    
    NSMutableArray * output = [NSMutableArray arrayWithObject:defaultClass];
    Class * classes = (Class *) malloc(sizeof(Class )*count);
    objc_getClassList(classes, count);
    for (int i = 0 ; i < count; i++) {
        if (defaultClass == class_getSuperclass(classes[i])) {
            [output addObject:classes[i]];
        }
    }
    free(classes);
    return output;
}

@end
