//
//  CLScanAnimationView.h
//  ScanCodeDemo
//
//  Created by CL on 2019/6/11.
//  Copyright © 2019 CL. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLScanAnimationView : UIView

/** 边框背景图 */
@property (nonatomic, strong) UIImageView *imageView;

/** 扫描线条图 */
@property (nonatomic, strong) UIImageView *scanLine;

/**
 开始动画
 */
- (void)startAnimation;

/**
 停止动画
 */
- (void)stopAnimation;

@end

NS_ASSUME_NONNULL_END
