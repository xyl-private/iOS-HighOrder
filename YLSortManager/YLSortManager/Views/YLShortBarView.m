//
//  YLShortBarView.m
//  YLSortManager
//
//  Created by xyanl on 2019/8/1.
//  Copyright © 2019 xyanl. All rights reserved.
//

#import "YLShortBarView.h"
@interface YLShortBarView()
@property(nonatomic, strong) UILabel *label;
@end

@implementation YLShortBarView

- (void)layoutSubviews{
    self.label.center = self.center;
    self.label.frame = CGRectMake(0, 10, self.frame.size.width, 10);
    self.label.hidden = self.frame.size.width < [UIScreen mainScreen].bounds.size.width/15?YES:NO;
    self.label.text = [NSString stringWithFormat:@"%d",(int)self.frame.size.height];
}


- (UILabel *)label{
    if (!_label) {
        _label = [UILabel new];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont systemFontOfSize:12];
        [self addSubview:_label];
    }
    return _label;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    _copiedFrame = frame;
}

@end
