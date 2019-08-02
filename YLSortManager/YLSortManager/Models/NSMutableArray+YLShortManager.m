//
//  NSMutableArray+YLShortManager.m
//  YLSortManager
//
//  Created by xyanl on 2019/8/1.
//  Copyright © 2019 xyanl. All rights reserved.
//

#import "NSMutableArray+YLShortManager.h"
#import <objc/message.h>

@interface  NSMutableArray()
@property(nonatomic, copy) YLSortComparator comparator;

@end

@implementation NSMutableArray (YLShortManager)

- (void)yl_sortUsingComparator:(YLSortComparator)comparator sortType:(YLSortType)sortType{
    self.comparator = comparator;
    switch (sortType) {
        case YLSortTypeSelectionSort:
            //选择排序
            [self yl_selectionSort];
            break;
        case YLSortTypeBubbleSort:
            //冒泡排序
            [self yl_bubbleSort];
            break;
        case YLSortTypeInsertionSort:
            //插入排序
            [self yl_insertionSort];
            break;
        case YLSortTypeMergeSort:
            //归并排序
            [self megerSortAscendingOrderSort];
            break;
        case YLSortTypeQuickSort:
            //快速排序

            break;
        case YLSortTypeIdenticalQuickSort:
            //双路快速排序

            break;
        case YLSortTypeQuick3WaysSort:
            //三路快速排序

            break;
        case YLSortTypeHeapSort:
            //堆排序

            break;
        default:
            break;
    }
}


#pragma mark - 私有排序算法

#pragma mark - /**选择排序*/
- (void)yl_selectionSort{
    for (int i = 0; i < self.count; i++) {
        for (int j = i + 1; j < self.count ; j++) {
            if (self.comparator(self[i],self[j]) == NSOrderedDescending) {
                [self yl_exchangeWithIndexA:i  indexB:j];
            }
        }
    }
}
#pragma mark - /**冒泡排序*/
- (void)yl_bubbleSort{
    bool swapped;
    do {
        swapped = false;
        for (int i = 1; i < self.count; i++) {
            if (self.comparator(self[i - 1],self[i]) == NSOrderedDescending) {
                swapped = true;
                [self yl_exchangeWithIndexA:i  indexB:i- 1];
            }
        }
    } while (swapped);
}

#pragma mark - /**插入排序*/
- (void)yl_insertionSort{
    for (int i = 0; i < self.count; i++) {
        id e = self[i];
        int j;
        for (j = i; j > 0 && self.comparator(self[j - 1],e) == NSOrderedDescending; j--) {
            [self yl_exchangeWithIndexA:j  indexB:j- 1];
        }
        self[j] = e;
    }
}

#pragma mark - /**归并排序 自顶向下*/
- (void)yl_mergeSort{
    NSInteger lastIndex = [self indexOfObject:self.lastObject];
    NSLog(@"last %ld",(long)lastIndex);
    
    
    [self yl_mergeSortArray:self LeftIndex:0 rightIndex:(int)self.count - 1];
}
- (void)yl_mergeSortArray:(NSMutableArray *)array LeftIndex:(int )l rightIndex:(int)r{
    if(l >= r) return;
    int mid = (l + r) / 2;
    [self yl_mergeSortArray:self LeftIndex:l rightIndex:mid]; //左边有序
    [self yl_mergeSortArray:self LeftIndex:mid + 1 rightIndex:r]; //右边有序
    [self yl_mergeSortArray:self LeftIndex:l midIndex:mid rightIndex:r]; //再将二个有序数列合并
}

- (void)yl_mergeSortArray:(NSMutableArray *)array LeftIndex:(int )l midIndex:(int )mid rightIndex:(int )r{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // 开辟新的空间 r-l+1的空间
        NSMutableArray *aux = [NSMutableArray arrayWithCapacity:r-l+1];
        for (int i = l; i <= r; i++) {
            // aux 中索引 i-l 的对象 与 array 中索引 i 的对象一致
            // aux[i-l] = array[i];
            [aux addObject:array[i]];
        }
        // 初始化，i指向左半部分的起始索引位置l；j指向右半部分起始索引位置mid+1
        int i = l, j = mid + 1;
        for ( int k = l; k <= r; k++) {
            if (i > mid) { // 如果左半部分元素已经全部处理完毕
                self.comparator(nil, nil);
                self[k] = aux[j - l];
                j++;
            }else if(j > r){// 如果右半部分元素已经全部处理完毕
                self.comparator(nil, nil);
                self[k] = aux[i - l];
                i++;
            }else if(self.comparator(aux[i - l], aux[j - l]) == NSOrderedAscending){// 左半部分所指元素 < 右半部分所指元素
                array[k] = aux[i - l];
                i++;
            }else{
                self.comparator(nil, nil);
                array[k] = aux[j - l];
                j++;
            }
        }
        
    });
    
}


- (void)megerSortAscendingOrderSort//:(NSMutableArray *)ascendingArr
{
    //tempArray数组里存放ascendingArr个数组，每个数组包含一个元素
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:1];
    for (NSNumber *num in self) {
        NSMutableArray *subArray = [NSMutableArray array];
        [subArray addObject:num];
        [tempArray addObject:subArray];
    }
    //开始合并为一个数组
    while (tempArray.count != 1) {
        NSInteger i = 0;
        while (i < tempArray.count - 1) {
            tempArray[i] = [self mergeArrayFirstList:tempArray[i] secondList:tempArray[i + 1]];
            [tempArray removeObjectAtIndex:i + 1];
            i++;
        }
    }
    NSLog(@"归并升序排序结果：%@", tempArray[0]);
}

- (NSArray *)mergeArrayFirstList:(NSArray *)array1 secondList:(NSArray *)array2 {
    NSMutableArray *resultArray = [NSMutableArray array];
    NSInteger firstIndex = 0, secondIndex = 0;
    while (firstIndex < array1.count && secondIndex < array2.count) {
        if ([array1[firstIndex] floatValue] < [array2[secondIndex] floatValue]) {
            [resultArray addObject:array1[firstIndex]];
            firstIndex++;
        } else {
            [resultArray addObject:array2[secondIndex]];
            secondIndex++;
        }
    }
    while (firstIndex < array1.count) {
        [resultArray addObject:array1[firstIndex]];
        firstIndex++;
    }
    while (secondIndex < array2.count) {
        [resultArray addObject:array2[secondIndex]];
        secondIndex++;
    }
    return resultArray.copy;
}

/// 交换两个元素
- (void)yl_exchangeWithIndexA:(NSInteger)indexA indexB:(NSInteger)indexB{
    if (indexA >= self.count || indexB >= self.count ) {
        NSLog(@"indexA:%ld,indexB:%ld",(long)indexA,(long)indexB);
        return;
    }
    id temp = self[indexA];
    self[indexA] = self[indexB];
    self[indexB] = temp;
}



#pragma mark - Getter && Setter 给NSMutableArray 类动态添加属性 comparator
- (void)setComparator:(YLSortComparator)comparator{
    // objc_setAssociatedObject（将某个值跟某个对象关联起来，将某个值存储到某个对象中）
    // object:给哪个对象添加属性
    // key:属性名称
    // value:属性值
    // policy:保存策略
    objc_setAssociatedObject(self, @"comparator",comparator, OBJC_ASSOCIATION_COPY);
}
- (YLSortComparator)comparator{
    return objc_getAssociatedObject(self, @"comparator");
}

@end
