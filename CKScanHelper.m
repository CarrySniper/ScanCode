//
//  CKScanManager.m
//  IOS7使用原生API进行二维码和条形码的扫描
//
//  Created by 思久科技 on 16/5/6.
//  Copyright © 2016年 Seejoys. All rights reserved.
//

#import "CKScanHelper.h"
#import <AVFoundation/AVFoundation.h>

@interface CKScanHelper() <AVCaptureMetadataOutputObjectsDelegate>{
    AVCaptureSession *_session;//输入输出的中间桥梁
    AVCaptureVideoPreviewLayer *_layer;//页面图层
    AVCaptureMetadataOutput *_output;
    
    UIView *_superView;
}

@end

@implementation CKScanHelper

#pragma mark - 生命周期
//第二步：实现声明单例方法 GCD
+ (instancetype)manager
{
    static CKScanHelper *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[CKScanHelper alloc] init];
    });
    return singleton;
}

//初始化-单例，只调用一次
- (id)init {
    self = [super init];
    if (self) {
        //初始化链接对象
        _session = [[AVCaptureSession alloc]init];
        //高质量采集率
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
        
        // 避免模拟器运行崩溃
        if(!TARGET_IPHONE_SIMULATOR) {
            //获取摄像设备
            AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
            //创建输入流
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
            [_session addInput:input];
            
            //创建输出流
            _output = [[AVCaptureMetadataOutput alloc]init];
            //设置代理 在主线程里刷新
            [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
            [_session addOutput:_output];
            //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
            _output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,
                                            AVMetadataObjectTypeEAN13Code,
                                            AVMetadataObjectTypeEAN8Code,
                                            AVMetadataObjectTypeCode128Code];
        }
        
        _layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
        _layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    }
    return self;
}

- (void)dealloc
{
    
}

#pragma mark - 方法
- (void)startRunning {
    //开始捕获
    [_session startRunning];
}

- (void)stopRunning {
    //停止捕获
    [_session stopRunning];
}

- (void)showLayer:(UIView *)superView {
    _superView = superView;
    _layer.frame = superView.layer.frame;
    [superView.layer insertSublayer:_layer atIndex:0];
}

//CGRectMake（y的起点/屏幕的高，x的起点/屏幕的宽，扫描的区域的高/屏幕的高，扫描的区域的宽/屏幕的宽）
- (void)setScanningRect:(CGRect)scanRect scanView:(UIView *)scanView
{
    
    CGFloat x,y,width,height;
    
    x = scanRect.origin.y / _layer.frame.size.height;
    y = scanRect.origin.x / _layer.frame.size.width;
    width = scanRect.size.height / _layer.frame.size.height;
    height = scanRect.size.width / _layer.frame.size.width;
    
    _output.rectOfInterest = CGRectMake(x, x, width, height);
    
    self.scanView = scanView;
    if (self.scanView) {
        self.scanView.frame = scanRect;
        if (_superView) {
            [_superView addSubview:self.scanView];
        }
    }
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count > 0) {
        //[_session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex :0];
        if (self.scanBlock) {
            self.scanBlock(YES, metadataObject.stringValue);
        }
        //输出扫描字符串
        NSLog(@"%@",metadataObject.stringValue);
    }else{
        if (self.scanBlock) {
            self.scanBlock(NO, nil);
        }
    }
}

@end
