//
//  UIImage+CLQRCode.h
//  ScanCodeDemo
//
//  Created by CL on 2019/6/10.
//  Copyright © 2019 CL. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (CLQRCode)

/**
 生成默认二维码
 
 @param text 二维码文本
 @param logo 中心logo图
 @param tintColor 二维码颜色
 @return w二维码
 */
+ (UIImage *)generateQRCodeWithText:(NSString *)text logo:(UIImage *_Nullable)logo tintColor:(UIColor *)tintColor;

/**
 文字过滤转换成核心图像
 
 @param text 二维码文本
 @param tintColor 二维码的颜色
 @param backgroundColor 背景颜色，一般以浅色为主，比tintColor浅，不然识别不出来
 @return 图像
 */
+ (UIImage *)generateImageWithText:(NSString *)text size:(CGSize)size tintColor:(UIColor *)tintColor backgroundColor:(UIColor *)backgroundColor;

/**
 绘制二维码图片
 
 @param image 二维码
 @param logo logo
 @param borderColor 外边框颜色
 @return 二维码
 */
+ (UIImage *)drawQRImageWithImage:(UIImage *)image logo:(UIImage *_Nullable)logo borderColor:(UIColor *)borderColor;

@end

NS_ASSUME_NONNULL_END
