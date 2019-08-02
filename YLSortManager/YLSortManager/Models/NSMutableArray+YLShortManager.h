//
//  NSMutableArray+YLShortManager.h
//  YLSortManager
//
//  Created by xyanl on 2019/8/1.
//  Copyright © 2019 xyanl. All rights reserved.
//

#import <Foundation/Foundation.h>

//NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger,YLSortType){
    YLSortTypeSelectionSort,         //选择排序
    YLSortTypeBubbleSort,            //冒泡排序
    YLSortTypeInsertionSort,         //插入排序
    YLSortTypeMergeSort,             //归并排序
    YLSortTypeQuickSort,             //原始快速排序
    YLSortTypeIdenticalQuickSort,    //双路快速排序
    YLSortTypeQuick3WaysSort,        //三路快速排序
    YLSortTypeHeapSort,              //堆排序
};

typedef NSComparisonResult(^YLSortComparator)(id  obj1, id obj2);


@interface NSMutableArray (YLShortManager)

- (void)yl_sortUsingComparator:(YLSortComparator )comparator sortType:(YLSortType )sortType;
    
@end

//NS_ASSUME_NONNULL_END
