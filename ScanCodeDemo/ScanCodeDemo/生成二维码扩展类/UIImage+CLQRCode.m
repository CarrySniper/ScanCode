//
//  UIImage+CLQRCode.m
//  ScanCodeDemo
//
//  Created by CL on 2019/6/10.
//  Copyright © 2019 CL. All rights reserved.
//

#import "UIImage+CLQRCode.h"
#import <CoreImage/CoreImage.h>

@implementation UIImage (CLQRCode)

/**
 生成默认二维码

 @param text 二维码文本
 @param logo 中心logo图
 @param tintColor 二维码颜色
 @return w二维码
 */
+ (UIImage *)generateQRCodeWithText:(NSString *)text logo:(UIImage *_Nullable)logo tintColor:(UIColor *)tintColor {
	UIColor *backgroundColor = [UIColor whiteColor];
	UIImage *qrImage = [UIImage generateImageWithText:text size:CGSizeMake(500, 500) tintColor:tintColor backgroundColor:backgroundColor];
	return [UIImage drawQRImageWithImage:qrImage logo:logo borderColor:backgroundColor];
}

/**
 文字过滤转换成二维码图像

 @param text 二维码文本
 @param size 大小
 @param tintColor 二维码的颜色
 @param backgroundColor 背景颜色，一般以浅色为主，比tintColor浅，不然识别不出来
 @return 图像
 */
+ (UIImage *)generateImageWithText:(NSString *)text size:(CGSize)size tintColor:(UIColor *)tintColor backgroundColor:(UIColor *)backgroundColor {
	// 二维码滤镜
	CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
	//过滤器恢复默认
	[filter setDefaults];
	// 设置二维码的纠错水平，越高纠错水平越高H:30%，可以污损的范围越大，中间加logo需要高容错率
	[filter setValue:@"H" forKey:@"inputCorrectionLevel"];
	// 将文本转为UTF8的数据，并设置给filter
	NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
	[filter setValue:data forKeyPath:@"inputMessage"];
	// 生成处理
	CIImage *dataCIImage = filter.outputImage;
	
	// 颜色滤镜
	CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"];
	[colorFilter setValue:dataCIImage forKey:@"inputImage"];
	[colorFilter setValue:[CIColor colorWithCGColor:tintColor.CGColor] forKey:@"inputColor0"];// 二维码颜色
	[colorFilter setValue:[CIColor colorWithCGColor:backgroundColor.CGColor] forKey:@"inputColor1"];// 背景色
	
	// 生成处理
	CIImage *colorCIImage = colorFilter.outputImage;
	
	/*
	 // 转换size大小,这个转换感觉会卡主线程，在viewcontroller push显示的时候会卡一下
	 CGFloat scale = size / colorCIImage.extent.size.width;
	 CIImage *scaleCIImage = [colorCIImage imageByApplyingTransform:CGAffineTransformMakeScale(scale, scale)];
	 // 转换成UIImage
	 UIImage *qrImage = [UIImage imageWithCIImage:scaleCIImage];
	 */
	
	// 绘制制定大小图片，性能比较好的
	CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:colorCIImage fromRect:colorCIImage.extent];
	UIGraphicsBeginImageContext(size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetInterpolationQuality(context, kCGInterpolationNone);
	CGContextScaleCTM(context, 1.0, -1.0);
	CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
	UIImage *codeImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	CGImageRelease(cgImage);
	return codeImage;
}

/**
 绘制二维码图片

 @param image 二维码
 @param logo logo
 @param borderColor 外边框颜色
 @return 二维码
 */
+ (UIImage *)drawQRImageWithImage:(UIImage *)image logo:(UIImage *_Nullable)logo borderColor:(UIColor *)borderColor {
	
	if (!image) {
		return nil;
	}
	if (!logo) {
		return image;
	}
	
	// 默认logo大小为二维码的1/4，居中显示
	CGFloat logoWidth = image.size.width / 4.0;
	CGRect logoFrame = CGRectMake((image.size.width - logoWidth) / 2, (image.size.width - logoWidth) / 2, logoWidth, logoWidth);
	
	// 为logo添加边框
	// 1.加灰色窄边（内层）
	UIImage *logoBorderImagae = [logo drawBorderWithImageSize:logoWidth borderWidth:2.0 borderColor:UIColor.grayColor];
	// 2.浅色宽边（外层）
	logoBorderImagae = [logoBorderImagae drawBorderWithImageSize:logoWidth borderWidth:8.0 borderColor:borderColor];
	
	// 绘制logo
	UIGraphicsBeginImageContextWithOptions(image.size, false, [UIScreen mainScreen].scale);
	[image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
	
	[logoBorderImagae drawInRect:logoFrame];
	
	// 生成新图片输出
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newImage;
}

/**
 为图片添加边框

 @param size 生成图片大小
 @param borderWidth 边框宽度
 @param borderColor 边框颜色
 @return 新图片
 */
- (UIImage *)drawBorderWithImageSize:(CGFloat)size borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor {
	CGFloat scale = size == 0 ? 0 : self.size.width / size ;
	borderWidth = borderWidth * scale;
	borderColor = borderColor ? borderColor : UIColor.clearColor;
	
	CGFloat radius = 8.0 * scale;
	CGFloat width = self.size.width - 2 * borderWidth;
	CGRect rect = CGRectMake(borderWidth, borderWidth, width, width);

	//绘制图片设置
	UIGraphicsBeginImageContextWithOptions(self.size, false, [UIScreen mainScreen].scale);
	UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius];

	//绘制边框
	bezierPath.lineWidth = borderWidth;
	[borderColor setStroke];
	[bezierPath stroke];
	[bezierPath addClip];
	[self drawInRect:rect];
	
	// 生成新图片输出
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	return newImage;
}

@end
