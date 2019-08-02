//
//  ViewController.m
//  YLSortManager
//
//  Created by xyanl on 2019/8/1.
//  Copyright © 2019 xyanl. All rights reserved.
//

#import "ViewController.h"
#import "NSMutableArray+YLShort.h"
#import "YLShortBarView.h"

#import "NSMutableArray+YLShortManager.h"
#import <Masonry.h>
@interface ViewController ()

@property (nonatomic, strong) UISegmentedControl *segmentControl;
@property (nonatomic, strong) UISegmentedControl *countSegmentControl;
@property (nonatomic, strong) UISegmentedControl *orderSegmentControl;
@property (nonatomic, strong) NSMutableArray<YLShortBarView *> *barArray;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) dispatch_semaphore_t sema;

@property(nonatomic, assign) NSInteger barCount;
@property(nonatomic, assign) BOOL repeatState;
@property(nonatomic, assign) BOOL orderState;
@property(nonatomic, assign) NSInteger index;
@property(nonatomic, assign) CGFloat barBottom;
@property(nonatomic, assign) CGFloat barAreaHeight;

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, assign) NSTimeInterval nowTime;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.barCount = 100;
//
    [self setupUI];
//    [self onReset];
}

- (void) onSortMy{
    NSMutableArray * marr = [NSMutableArray arrayWithCapacity:100];
    for (int i = 0; i < 100; i ++) {
        [marr addObject:[NSNumber numberWithInt:arc4random() % 1000]];
    }
    __weak typeof(self) weakSelf = self;
    [marr yl_sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [weakSelf compareWithObjectOne:obj1 objTwo:obj2];
    } sortType:(YLSortTypeMergeSort)];
    
    NSLog(@"%@",marr);
}


- (void) setupUI{
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"重置" style:UIBarButtonItemStylePlain target:self action:@selector(onReset)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"排序" style:UIBarButtonItemStylePlain target:self action:@selector(onSortMy)];
    
    [self.segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(72);
        make.left.equalTo(self.view.mas_left).offset(8);
        make.right.equalTo(self.view.mas_right).offset(-8);
        make.height.offset(30);
    }];
    
    [self.countSegmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segmentControl.mas_bottom).offset(8);
        make.left.equalTo(self.view.mas_left).offset(8);
        make.right.equalTo(self.view.mas_right).offset(-8);
        make.height.offset(30);
    }];
    [self.orderSegmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.countSegmentControl.mas_bottom).offset(8);
        make.left.equalTo(self.view.mas_left).offset(8);
        make.right.equalTo(self.view.mas_right).offset(-8);
        make.height.offset(30);
    }];
    
}


- (void)onSegmentControlChanged:(UISegmentedControl *)segmentControl {
    [self onReset];
}


- (void)countSegmentControlChanged:(UISegmentedControl *)segmentControl{
    NSArray *count = @[@"5", @"10",@"20", @"50",@"100"];
    self.barCount = [count[segmentControl.selectedSegmentIndex] integerValue];
    [self onReset];
}

- (void)orderSegmentControlChanged:(UISegmentedControl *)segmentControl{
    self.repeatState = NO;
    self.orderState = NO;
    if (segmentControl.selectedSegmentIndex == 2) {
        //大量重复元素
        self.repeatState = YES;
    }else if (segmentControl.selectedSegmentIndex == 1){
        //近乎有序
        self.orderState = YES;
    }
    [self onReset];
}


/**
 设置BarView的高度
 
 @param mutArray 高度数组
 @param isReset 是否是重置状态
 */
- (void)setupBarArrayHeight:(NSMutableArray *)mutArray isReset:(BOOL)isReset {
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat barMargin = 1;
    CGFloat barWidth = floorf((width - barMargin * (self.barCount + 1)) / self.barCount);
    CGFloat barOrginX = roundf((width - (barMargin + barWidth) * self.barCount + barMargin) / 2.0);
    
    [self.barArray enumerateObjectsUsingBlock:^(YLShortBarView * _Nonnull bar, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat barHeight = [mutArray[idx] floatValue];
        //重置状态
        if (isReset) {
            if (self.orderState) {
                barHeight = self.barAreaHeight/2 + idx * 2;
            }
            //大量重复元素
            if (self.repeatState) {
                barHeight = self.barAreaHeight/2 + arc4random_uniform(5) * 10;
            }
        }
        
        bar.frame = CGRectMake(barOrginX + idx * (barMargin + barWidth), self.barBottom - barHeight, barWidth, barHeight);
        bar.tag = (int)idx + 2;
    }];
    
    //近乎有序
    if (self.orderState && isReset) {
        for (int i = 0; i < 10; i++) {
            int posx = arc4random() % self.barCount;
            YLShortBarView *bar = (YLShortBarView *)self.barArray[posx];
            CGRect frame = bar.frame;
            CGFloat h = arc4random() % 100;
            frame.size.height += h ;
            frame.origin.y -= h;
            bar.frame = frame;
        }
    }
}

- (void)onReset {
    
    [self invalidateTimer];
    self.index = 0;
    [self setupBarArray];
    
    CGFloat barAreaY = 64 + 8 * 3 + 30 * 3 + 10 ;
    CGFloat barBottom = CGRectGetHeight(self.view.bounds) * 0.95;
    CGFloat barAreaHeight = barBottom - barAreaY;
    self.barBottom = barBottom;
    self.barAreaHeight = barAreaHeight;
    NSMutableArray *mutArray = [NSMutableArray array];
    for (int i = 0; i < self.barArray.count; i++) {
        CGFloat barHeight = 20 + arc4random_uniform(barAreaHeight - 20);
        [mutArray addObject:[NSString stringWithFormat:@"%f",barHeight]];
    }
    
    [self setupBarArrayHeight:mutArray isReset:YES];
    
}

- (void)onSort {
    if (self.timer || [self judgeArrayIsSorted:self.barArray]) {
        return;
    }
    if (!self.sema) {
        self.sema = dispatch_semaphore_create(0);
        dispatch_semaphore_signal(self.sema); // 先触发一次，避免排序先于定时器，会导致 dispatch_semaphore_wait 等待锁死
    }
    self.nowTime = [[NSDate date] timeIntervalSince1970];
    
    
    // 定时器信号
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(fireTimerAction) userInfo:nil repeats:YES];
    self.barArray.vc = self;
    
    NSInteger selectedSegmentIndex = self.segmentControl.selectedSegmentIndex;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __unsafe_unretained __block typeof(self) weakSelf = self;
        [self.barArray mb_sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [weakSelf compareWithBarOne:obj1 andBarTwo:obj2];
        } sortType:selectedSegmentIndex];
        
        [self invalidateTimer];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] - self.nowTime;
            if ([self judgeArrayIsSorted:self.barArray]) {
                self.timeLabel.text = [NSString stringWithFormat:@"排序成功：耗时:%2.3f (秒)", interval];
            }else{
                self.timeLabel.text = [NSString stringWithFormat:@"排序失败：耗时:%2.3f (秒)", interval];
            }
        });
        
    });
}




#pragma mark - 比较
- (NSComparisonResult)compareWithObjectOne:(NSNumber * )objOne objTwo:(NSNumber *)objTwo {
    if (objOne == nil || objTwo == nil) {
        return objOne == nil ? (objTwo == nil ? NSOrderedSame : NSOrderedAscending) : NSOrderedDescending;
    }
    // 模拟进行比较所需的耗时
    if (self.sema) {
        dispatch_semaphore_wait(self.sema, DISPATCH_TIME_FOREVER);
    }
    if ([objOne isEqualToNumber:objTwo]) {
        return NSOrderedSame;
    }
    return objOne.intValue < objTwo.intValue ? NSOrderedAscending : NSOrderedDescending;
}

- (NSComparisonResult)compareWithBarOne:(YLShortBarView *)barOne andBarTwo:(YLShortBarView *)barTwo {
    if (barOne == nil || barTwo == nil) {
        return barOne == nil ? (barTwo == nil ? NSOrderedSame : NSOrderedAscending) : NSOrderedDescending;
    }
    // 模拟进行比较所需的耗时
    if (self.sema) {
        dispatch_semaphore_wait(self.sema, DISPATCH_TIME_FOREVER);
    }
    CGFloat height1 = CGRectGetHeight(barOne.copiedFrame);
    CGFloat height2 = CGRectGetHeight(barTwo.copiedFrame);
    if (height1 == height2) {
        return NSOrderedSame;
    }
    return height1 < height2 ? NSOrderedAscending : NSOrderedDescending;
}


/**
 数组是否排序
 
 @param mutArray <#mutArray description#>
 @return <#return value description#>
 */
- (BOOL)judgeArrayIsSorted:(NSMutableArray *)mutArray{
    NSInteger number = mutArray.count - 1;
    for (NSInteger i = 0; i < number; i++) {
        if ([self compareWithBarOne:mutArray[i] andBarTwo:mutArray[i + 1]] == NSOrderedDescending) {
            return false;
        }
    }
    
    return true;
}

#pragma mark - 回调
- (void)resetSortArray:(NSMutableArray *)mutArray{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setupBarArrayHeight:mutArray isReset:NO];
    });
    
}
- (void)exchangePositionWithBarOne:(YLShortBarView *)barOne andBarTwo:(YLShortBarView *)barTwo {
    dispatch_async(dispatch_get_main_queue(), ^{
//        CGRect frameOne = barOne.frame;
//        CGRect frameTwo = barTwo.frame;
//        frameOne.origin.x = barTwo.frame.origin.x;
//        frameTwo.origin.x = barOne.frame.origin.x;
//        barOne.frame = frameOne;
//        barTwo.frame = frameTwo;
//
    });
}
#pragma mark - 定时器
- (void)fireTimerAction {
    // 发出信号量，唤醒排序线程
    dispatch_semaphore_signal(self.sema);
    dispatch_async(dispatch_get_main_queue(), ^{
        // 更新计时
        NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] - self.nowTime;
        self.timeLabel.text = [NSString stringWithFormat:@"耗时:%2.3f (秒)", interval];
    });
    
    
}
- (void)invalidateTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.sema = nil;
}


#pragma mark - Getter && Setter
- (UISegmentedControl *)segmentControl {
    if (!_segmentControl) {
        _segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"选择", @"冒泡", @"插入",@"归并", @"快速", @"双路", @"三路", @"堆排序"]];
        _segmentControl.selectedSegmentIndex = 0;
        [_segmentControl addTarget:self action:@selector(onSegmentControlChanged:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:_segmentControl];
    }
    return _segmentControl;
}

- (UISegmentedControl *)countSegmentControl {
    if (!_countSegmentControl) {
        _countSegmentControl = [[UISegmentedControl alloc] initWithItems:@[@"5", @"10",@"20", @"50",@"100"]];
        _countSegmentControl.selectedSegmentIndex = 4;
        [_countSegmentControl addTarget:self action:@selector(countSegmentControlChanged:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:_countSegmentControl];
    }
    return _countSegmentControl;
}
- (UISegmentedControl *)orderSegmentControl {
    if (!_orderSegmentControl) {
        _orderSegmentControl = [[UISegmentedControl alloc] initWithItems:@[@"乱序", @"近乎有序", @"大量重复元素"]];
        _orderSegmentControl.selectedSegmentIndex = 0;
        [_orderSegmentControl addTarget:self action:@selector(orderSegmentControlChanged:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:_orderSegmentControl];
    }
    return _orderSegmentControl;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:14];
        _timeLabel.textColor = [UIColor darkTextColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        self.timeLabel.frame = CGRectMake(0,
                                          CGRectGetHeight(self.view.bounds) * 0.95, self.view.bounds.size.width, 40);
        [self.view addSubview:_timeLabel];
    }
    return _timeLabel;
}
/**
 初始化barArray
 */
- (void)setupBarArray{
    [self.barArray removeAllObjects];
    for (YLShortBarView *bar in self.view.subviews) {
        if (bar.tag > 1) {
            [bar removeFromSuperview];
        }
    }
    _barArray = [NSMutableArray arrayWithCapacity:self.barCount];
    for (NSInteger index = 0; index < self.barCount; index ++) {
        YLShortBarView *bar = [[YLShortBarView alloc] init];
        bar.backgroundColor = [UIColor colorWithRed:94.0/255.0 green:171.0/255.0 blue:210.0/255.0 alpha:1];
        [self.view addSubview:bar];
        [_barArray addObject:bar];
    }
}







@end
