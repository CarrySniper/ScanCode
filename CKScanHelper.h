//
//  CKScanManager.h
//  iOS7使用原生API进行二维码和条形码的扫描
//
//  Created by 思久科技 on 16/5/6.
//  Copyright © 2016年 Seejoys. All rights reserved.
//

// FIXME:iOS10权限
/**
 <key>NSCameraUsageDescription</key>
 <string>cameraDesciption</string>
 <key>NSContactsUsageDescription</key>
 <string>contactsDesciption</string>
 <key>NSMicrophoneUsageDescription</key>
 <string>microphoneDesciption</string>
 <key>NSPhotoLibraryUsageDescription</key>
 <string>photoLibraryDesciption</string>
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^CKScanSuccessBlock)(NSString *scanResult);

@interface CKScanHelper : NSObject

//第一步：创建声明单例方法
+ (instancetype)manager;

@property (nonatomic, strong) UIView *scanView;

@property (nonatomic, copy) CKScanSuccessBlock scanBlock;

- (void)showLayer:(UIView *)viewContainer;

- (void)setScanningRect:(CGRect)scanRect scanView:(UIView *)scanView;

- (void)startRunning;

- (void)stopRunning;

@end
