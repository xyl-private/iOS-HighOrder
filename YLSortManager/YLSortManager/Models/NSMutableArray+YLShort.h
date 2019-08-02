//
//  NSMutableArray+YLShort.h
//  YLSortManager
//
//  Created by xyanl on 2019/8/1.
//  Copyright © 2019 xyanl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewController.h"
//NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger,MBSortType){
    MBSelectionSort,         //选择排序
    MBBubbleSort,            //冒泡排序
    MBInsertionSort,         //插入排序
    MBMergeSort,             //归并排序
    MBQuickSort,             //原始快速排序
    MBIdenticalQuickSort,    //双路快速排序
    MBQuick3WaysSort,        //三路快速排序
    MBHeapSort,              //堆排序
};

typedef NSComparisonResult(^MBSortComparator)(id  obj1, id obj2);


@interface NSMutableArray (YLShort)

@property(nonatomic, strong) UIViewController *vc;


- (void)mb_sortUsingComparator:(MBSortComparator )comparator sortType:(MBSortType )sortType;
- (void)mb_exchangeWithIndexA:(NSInteger)indexA indexB:(NSInteger)indexB;

@end

//NS_ASSUME_NONNULL_END
