//
//  CLScanCodeManeger.h
//  ScanCodeDemo
//
//  Created by CL on 2019/6/10.
//  Copyright © 2019 CL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CLScanCodeManegerResultHandler)(NSString *result);

@interface CLScanCodeManeger : NSObject

/** 识别区域范围，默认为CGRectZero，全屏识别 */
@property (nonatomic, assign) CGRect recognitionAreaRect;

/**
 单例管理
 */
+ (instancetype)manager;

/**
 加载扫描预览图

 @param previewView 装载预览图
 @param resultHandler 扫描结果回调
 */
- (void)loadWithView:(UIView * _Nonnull)previewView resultHandler:(CLScanCodeManegerResultHandler _Nonnull)resultHandler;

#pragma mark - 开始和停止扫描
/**
 开始扫描
 */
- (void)startScan;

/**
 停止扫描
 */
- (void)stopScan;

#pragma mark - 闪光灯
/**
 开关闪光灯
 */
- (void)torchChange;

/**
 获取闪光灯开关状态
 */
- (BOOL)torchStatus;

/**
 获取相机当前权限状态
 
 * AVAuthorizationStatusNotDetermined = 0,// 用户尚未做出选择这个应用程序的问候
 * AVAuthorizationStatusRestricted,// 此应用程序没有被授权访问的照片数据。
 * AVAuthorizationStatusDenied,// 用户已经明确否认了这一照片数据的应用程序访问
 * AVAuthorizationStatusAuthorized// 用户已经授权应用访问照片数据
 */
- (AVAuthorizationStatus)captureDeviceAuthorizationStatus;

@end

NS_ASSUME_NONNULL_END
