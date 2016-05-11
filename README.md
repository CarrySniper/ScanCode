# Sacn-QRCode-BarCode
支持iOS7及以上级版本，支持二维码和条形码。
AVMetadataObject类，使用原生Api扫描和处理的效率非常高，瞬间完成。

已经封装成CKScanHelper，只有复制这两个文件，就可以快速实现扫描。

###使用方法
```
[[CKScanHelper manager] showLayer:self.view];

CGSize windowSize = [UIScreen mainScreen].bounds.size;
CGSize scanSize = CGSizeMake(windowSize.width*3/4, windowSize.width*3/4);
CGRect scanRect = CGRectMake((windowSize.width-scanSize.width)/2, 30, scanSize.width, scanSize.height);

UIView *scanRectView = [UIView new];
scanRectView.layer.borderColor = [UIColor redColor].CGColor;
scanRectView.layer.borderWidth = 1;

[[CKScanHelper manager] setScanningRect:scanRect scanView:scanRectView];

[[CKScanHelper manager] setScanBlock:^(NSString *scanResult){
     NSLog(@"%@", scanResult);
}];

[[CKScanHelper manager] startRunning];//开始扫描

[[CKScanHelper manager] stopRunning];//结束扫描
```
###1.包含头文件：AVFoundation/AVFoundation.h
###2.引用协议代理： AVCaptureMetadataOutputObjectsDelegate

###3.声明对象
```
AVCaptureSession *_session;             //输入输出的中间桥梁
AVCaptureVideoPreviewLayer *_layer;     //捕捉视频预览层
AVCaptureMetadataOutput *_output;       //捕获元数据输出
AVCaptureDeviceInput *_input;           //采集设备输入
UIView *_superView;                     //图层的父类
```
###4.实例化对象
```
初始化链接对象
_session = [[AVCaptureSession alloc]init];
高质量采集率
[_session setSessionPreset:AVCaptureSessionPresetHigh];

// 避免模拟器运行崩溃
if(!TARGET_IPHONE_SIMULATOR) {
//获取摄像设备
AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
     //创建输入流
     _input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
     [_session addInput:_input];

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
```
###5.实现扫描代理方法 成功输出
```
#pragma mark - AVCaptureMetadataOutputObjects Delegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count > 0) {
        //[_session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex :0];
        if (self.scanBlock) {
            self.scanBlock(metadataObject.stringValue);
        }
        //输出扫描字符串
        NSLog(@"%@",metadataObject.stringValue);
    }
}
```
###6.开始结束扫描
```
- (void)startRunning {
    //开始捕获
    [_session startRunning];
}

- (void)stopRunning {
    //停止捕获
    [_session stopRunning];
}
```
###7.优化扫描区域
CGRectMake（y的起点/屏幕的高，x的起点/屏幕的宽，扫描的区域的高/屏幕的高，扫描的区域的宽/屏幕的宽）
```
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
```
###8.添加显示图层
```
- (void)showLayer:(UIView *)superView {
    _superView = superView;
    _layer.frame = superView.layer.frame;
    [superView.layer insertSublayer:_layer atIndex:0];
}
```
