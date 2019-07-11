//
//  CLScanAnimationView.m
//  ScanCodeDemo
//
//  Created by CL on 2019/6/11.
//  Copyright © 2019 CL. All rights reserved.
//

#import "CLScanAnimationView.h"

@interface CLScanAnimationView ()

@end

@implementation CLScanAnimationView

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self setup];
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
	self = [super initWithCoder:coder];
	if (self) {
		[self setup];
	}
	return self;
}

- (void)setup {
	self.backgroundColor = UIColor.clearColor;
	self.clipsToBounds = YES;
	
	self.imageView = [[UIImageView alloc] init];
	self.imageView.backgroundColor = UIColor.clearColor;
	self.imageView.contentMode = UIViewContentModeScaleToFill;
	[self addSubview:self.imageView];
	
	self.scanLine = [[UIImageView alloc] init];
	self.scanLine.backgroundColor = UIColor.clearColor;
	[self addSubview:self.scanLine];
}

- (void)layoutSubviews {
	[super layoutSubviews];

	self.imageView.frame = self.bounds;
	self.scanLine.frame = CGRectMake(0, 0, self.frame.size.width, 128.0);
}

- (void)startAnimation {
	[self.scanLine.layer addAnimation:[self moveAnimation] forKey:nil];
}

- (void)stopAnimation {
	[self.scanLine.layer removeAllAnimations];
}

//扫描动画
- (CABasicAnimation *)moveAnimation {
	[self layoutIfNeeded];
	CGFloat height = self.scanLine.frame.size.height / 2;
	CGPoint starPoint = CGPointMake(self.scanLine.center.x  , -height);
	CGPoint endPoint = CGPointMake(self.scanLine.center.x, self.bounds.size.height - height);
	
	CABasicAnimation *translation = [CABasicAnimation animationWithKeyPath:@"position"];
	translation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	translation.fromValue = [NSValue valueWithCGPoint:starPoint];
	translation.toValue = [NSValue valueWithCGPoint:endPoint];
	translation.duration = 1.0;
	translation.repeatCount = CGFLOAT_MAX;
	translation.autoreverses = NO;
	
	return translation;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
// 覆盖drawRect方法，你可以在此自定义绘画和动画
//- (void)drawRect:(CGRect)rect
//{
//	//An opaque type that represents a Quartz 2D drawing environment.
//	//一个不透明类型的Quartz 2D绘画环境,相当于一个画布,你可以在上面任意绘画
//	CGFloat width = self.frame.size.width;		// 视图宽度
//	CGFloat height = self.frame.size.height;    // 视图高度
//
//	CGFloat line_width = 5.0;                   // 线段宽度
//	CGFloat line_length = 15.0;                	// 线段长度
//
//	/// 上下文画布
//	CGContextRef context = UIGraphicsGetCurrentContext();
//
//	CGContextSetLineWidth(context, line_width);	// 线条宽度
//	CGContextSetRGBStrokeColor(context, 0, 1, 0, 1.0);	// 画笔线的颜色
//
//	///坐标点
//	CGPoint aPoints[2];
//	// 左上角1
//	aPoints[0] = CGPointMake(0, line_width/2);//坐标1
//	aPoints[1] = CGPointMake(line_length, line_width/2);//坐标2
//	CGContextAddLines(context, aPoints, 2);//添加线
//	CGContextDrawPath(context, kCGPathStroke); //根据坐标绘制路径
//
//	// 左上角2
//	aPoints[0] = CGPointMake(line_width/2, 0);//坐标1
//	aPoints[1] = CGPointMake(line_width/2 , line_length);//坐标2
//	CGContextAddLines(context, aPoints, 2);//添加线
//	CGContextDrawPath(context, kCGPathStroke); //根据坐标绘制路径
//
//	// 左下角1
//	aPoints[0] = CGPointMake(line_width/2, height - line_length);//坐标1
//	aPoints[1] = CGPointMake(line_width/2 , height);//坐标2
//	CGContextAddLines(context, aPoints, 2);//添加线
//	CGContextDrawPath(context, kCGPathStroke); //根据坐标绘制路径
//
//	// 左下角2
//	aPoints[0] = CGPointMake(0, height - line_width/2);//坐标1
//	aPoints[1] = CGPointMake(line_length , height - line_width/2);//坐标2
//	CGContextAddLines(context, aPoints, 2);//添加线
//	CGContextDrawPath(context, kCGPathStroke); //根据坐标绘制路径
//
//	// 右上角1
//	aPoints[0] = CGPointMake(width - line_length, line_width/2);//坐标1
//	aPoints[1] = CGPointMake(width, line_width/2);//坐标2
//	CGContextAddLines(context, aPoints, 2);//添加线
//	CGContextDrawPath(context, kCGPathStroke); //根据坐标绘制路径
//
//	// 右上角2
//	aPoints[0] = CGPointMake(width - line_width/2, 0);//坐标1
//	aPoints[1] = CGPointMake(width - line_width/2, line_length);//坐标2
//	CGContextAddLines(context, aPoints, 2);//添加线
//	CGContextDrawPath(context, kCGPathStroke); //根据坐标绘制路径
//
//	// 右下角1
//	aPoints[0] = CGPointMake(width - line_width/2, height - line_length);//坐标1
//	aPoints[1] = CGPointMake(width - line_width/2 , height);//坐标2
//	CGContextAddLines(context, aPoints, 2);//添加线
//	CGContextDrawPath(context, kCGPathStroke); //根据坐标绘制路径
//
//	// 右下角2
//	aPoints[0] = CGPointMake(width - line_length, height - line_width/2);//坐标1
//	aPoints[1] = CGPointMake(width, height - line_width/2);//坐标2
//	CGContextAddLines(context, aPoints, 2);//添加线
//	CGContextDrawPath(context, kCGPathStroke); //根据坐标绘制路径
//}

@end
