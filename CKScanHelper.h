//
//  CKScanManager.h
//  iOS7使用原生API进行二维码和条形码的扫描
//
//  Created by 思久科技 on 16/5/6.
//  Copyright © 2016年 Seejoys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^CKScanSuccessBlock)(NSString *scanResult);

@interface CKScanHelper : NSObject

//第一步：创建声明单例方法
+ (instancetype)manager;

@property (nonatomic, strong) UIView *scanView;

@property (nonatomic, copy) CKScanSuccessBlock scanBlock;

- (void)startRunning;

- (void)stopRunning;

- (void)showLayer:(UIView *)superView;

- (void)setScanningRect:(CGRect)scanRect scanView:(UIView *)scanView;

@end
