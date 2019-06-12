//
//  CLScanCodeManeger.m
//  ScanCodeDemo
//
//  Created by CL on 2019/6/10.
//  Copyright © 2019 CL. All rights reserved.
//

#import "CLScanCodeManeger.h"

@interface CLScanCodeManeger ()<AVCaptureMetadataOutputObjectsDelegate>

/** 链接对象 */
@property (nonatomic, strong) AVCaptureSession *captureSession;

/** 捕捉设备输入流 */
@property (nonatomic, strong) AVCaptureDeviceInput *deviceInput;

/** 捕捉数据输出流 */
@property (nonatomic, strong) AVCaptureMetadataOutput *metadataOutput;

/** 捕捉视频预览层 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

/** 描边的图层，加载围绕二维码 */
@property (nonatomic,strong) CAShapeLayer *strokeLayer;

/** 蒙版图层，遮挡不识别二维码区域 */
@property (nonatomic,strong) CAShapeLayer *maskLayer;

/** 扫描结果回调 */
@property (nonatomic, copy) CLScanCodeManegerResultHandler resultHandler;

@end

@implementation CLScanCodeManeger

#pragma mark - Lazy
#pragma mark 捕捉设备输入流
- (AVCaptureDeviceInput *)deviceInput {
	if (!_deviceInput) {
		//获取摄像设备
		AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
		//创建输入流
		NSError *error = nil;
		_deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
		if (error) {
			NSLog(@"捕抓设备不可用");
			_deviceInput = nil;
			return nil;
		}
	}
	return _deviceInput;
}

#pragma mark 捕捉数据输出流
- (AVCaptureMetadataOutput *)metadataOutput {
	if (!_metadataOutput) {
		//创建输出流
		_metadataOutput = [[AVCaptureMetadataOutput alloc] init];
		//设置代理 在主线程里刷新
		[_metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
	}
	return _metadataOutput;
}

#pragma mark 捕获会话对象
- (AVCaptureSession *)captureSession {
	if (!_captureSession) {
		//初始化链接对象
		_captureSession = [[AVCaptureSession alloc]init];
		//高质量采集率
		[_captureSession setSessionPreset:AVCaptureSessionPresetHigh];
		
		if (self.deviceInput) {
			[_captureSession addInput:self.deviceInput];
		}
		if (self.metadataOutput) {
			[_captureSession addOutput:self.metadataOutput];
			// 设置扫码支持的编码格式(如下设置条形码和二维码兼容)， 在addOutput之后
			self.metadataOutput.metadataObjectTypes = self.metadataOutput.availableMetadataObjectTypes;
		}
	}
	return _captureSession;
}

#pragma mark 捕捉视频预览层
- (AVCaptureVideoPreviewLayer *)previewLayer {
	if (!_previewLayer) {
		_previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
		_previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
	}
	return _previewLayer;
}

#pragma mark 描边图层
- (CAShapeLayer *)strokeLayer {
	if (!_strokeLayer) {
		_strokeLayer = [[CAShapeLayer alloc] init];
		
		// 设置线宽
		_strokeLayer.lineWidth = 1;
		// 设置描边颜色
		_strokeLayer.strokeColor = [UIColor greenColor].CGColor;
		_strokeLayer.fillColor = [UIColor clearColor].CGColor;
	}
	return _strokeLayer;
}

#pragma mark 蒙版图层
- (CAShapeLayer *)maskLayer {
	if (!_maskLayer) {
		UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:self.previewLayer.bounds];
		[maskPath appendPath:[[UIBezierPath bezierPathWithRoundedRect:self.recognitionAreaRect cornerRadius:1] bezierPathByReversingPath]];
		
		_maskLayer = [[CAShapeLayer alloc] init];
		_maskLayer.fillColor = [UIColor colorWithWhite:0 alpha:0.4].CGColor;
		_maskLayer.strokeColor = UIColor.clearColor.CGColor;
		_maskLayer.path = maskPath.CGPath;
	}
	return _maskLayer;
}

#pragma mark - Init
+ (instancetype)manager {
	return [[self alloc] init];
}

- (instancetype)init
{
	static CLScanCodeManeger *instance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instance = [super init];
		
		// 捕捉输入变化通知 - 实现限定扫描区域
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rectOfInterest) name:AVCaptureInputPortFormatDescriptionDidChangeNotification object:nil];
	});
	return instance;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:AVCaptureInputPortFormatDescriptionDidChangeNotification object:nil];
}

#pragma mark - 设置扫描识别区域
- (void)rectOfInterest {
	// 不存在识别区域，整个预览大小都可以识别。默认为(0,0,1,1);
	if (CGRectIsEmpty(self.recognitionAreaRect) || CGRectIsNull(self.recognitionAreaRect)) {
		self.metadataOutput.rectOfInterest = CGRectMake(0, 0, 1, 1);
	}
	// 存在识别区域，二维码只有在区域里才能识别
	else {
		CGRect areaInterestRect = [self.previewLayer metadataOutputRectOfInterestForRect:self.recognitionAreaRect];
		self.metadataOutput.rectOfInterest = areaInterestRect;
	}
}

#pragma mark - 加载扫描预览图
- (void)loadWithView:(UIView *)previewView resultHandler:(CLScanCodeManegerResultHandler)resultHandler {
	self.resultHandler = resultHandler;
	self.previewLayer.frame = previewView.layer.frame;
	// 插入预览图层
	[previewView.layer insertSublayer:self.previewLayer atIndex:0];
	
	// 插入蒙版层，要先拿到self.previewLayer.frame和self.recognitionAreaRect
	[previewView.layer insertSublayer:self.maskLayer above:self.previewLayer];
	
	// 添加描边图层
	[previewView.layer addSublayer:self.strokeLayer];
}


#pragma mark - 开始扫描
- (void)startScan {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		[self.captureSession startRunning];
	});
}

#pragma mark - 停止扫描
- (void)stopScan {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		if (self.captureSession.isRunning) {
			[self.captureSession stopRunning];
			// 清除之前的描边
			[self clearLayers];
		}
	});
}

#pragma mark - AVCaptureMetadataOutputObjects Delegate
- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
	AVMetadataMachineReadableCodeObject *readableObject = (AVMetadataMachineReadableCodeObject *)metadataObjects.firstObject;
	if (!readableObject || ![readableObject isKindOfClass:AVMetadataMachineReadableCodeObject.class]) {
		// 有时候返回AVMetadataObject，不存在.stringValue属性，会crash
		return;
	}
	//输出扫描字符串
	NSLog(@"%@ %@",readableObject.stringValue, readableObject.class);
	if (self.resultHandler) {
		self.resultHandler(readableObject.stringValue);
	}
	// 对扫描到的二维码进行描边
	AVMetadataMachineReadableCodeObject *foundObject = (AVMetadataMachineReadableCodeObject *)[self.previewLayer transformedMetadataObjectForMetadataObject:readableObject];
	
	// 清除之前的描边
	[self clearLayers];
	// 绘制描边
	[self drawLine:foundObject];
}

#pragma mark - 附加的描边功能
- (void)drawLine:(AVMetadataMachineReadableCodeObject *)object {
	NSArray *array = object.corners;
	
	// 2.创建UIBezierPath, 绘制矩形
	UIBezierPath *path = [[UIBezierPath alloc] init];
	CGPoint point = CGPointZero;
	int index = 0;
	CFDictionaryRef dict = (__bridge CFDictionaryRef)(array[index++]);
	// 把点转换为不可变字典
	// 把字典转换为点，存在point里，成功返回true 其他false
	CGPointMakeWithDictionaryRepresentation(dict, &point);
	
	// 设置起点
	[path moveToPoint:point];
	
	// 2.2连接其它线段
	for (int i = 1; i<array.count; i++) {
		CGPointMakeWithDictionaryRepresentation((__bridge CFDictionaryRef)array[i], &point);
		[path addLineToPoint:point];
	}
	// 2.3关闭路径
	[path closePath];
	self.strokeLayer.hidden = NO;
	self.strokeLayer.path = path.CGPath;
	
}

- (void)clearLayers {
	self.strokeLayer.hidden = YES;
}

#pragma mark - 闪光灯
- (void)torchChange {
	AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
	[device lockForConfiguration:nil];
	if (device.torchMode == AVCaptureTorchModeOff) {
		[device setTorchMode:AVCaptureTorchModeOn];
	} else {
		[device setTorchMode:AVCaptureTorchModeOff];
	}
	[device unlockForConfiguration];
}

- (BOOL)torchStatus {
	AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
	if (device.torchMode == AVCaptureTorchModeOff) {
		return NO;
	} else {
		return YES;
	}
}

#pragma mark - 获取相机当前权限状态
- (AVAuthorizationStatus)captureDeviceAuthorizationStatus {
	/*
	 * AVAuthorizationStatusNotDetermined = 0,// 用户尚未做出选择这个应用程序的问候
	 * AVAuthorizationStatusRestricted,// 此应用程序没有被授权访问的照片数据。
	 * AVAuthorizationStatusDenied,// 用户已经明确否认了这一照片数据的应用程序访问
	 * AVAuthorizationStatusAuthorized// 用户已经授权应用访问照片数据
	 */
	AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
	return authStatus;
}

@end
