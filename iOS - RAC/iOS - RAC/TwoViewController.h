//
//  TwoViewController.h
//  iOS - RAC
//
//  Created by xyanl on 2019/7/29.
//  Copyright © 2019 徐彦龙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveObjC.h>
NS_ASSUME_NONNULL_BEGIN

@interface TwoViewController : UIViewController
@property (nonatomic, strong) RACSubject * twoSubject;
@end

NS_ASSUME_NONNULL_END
