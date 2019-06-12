# ScanDemo
生成二维码，可添加中心logo图。<br>
支持识别二维码、条形码DM码等，具体可以查看sdk。<br>
适配iOS10，info.plist文件添加相机权限Privacy - Camera Usage Description<br>

<img src="https://github.com/cjq002/ScanCode/raw/master/Media/demo.png" width="375">
<img src="https://github.com/cjq002/ScanCode/raw/master/Media/demo1.png" width="375">

### 使用方法
#### 1.包含头文件
```objc
#import "CLScanCodeManeger.h"
```

#### 2.设置扫描区域，设置加载图层
```objc
// 设置扫描识别区域(不是必要操作)
[[CLScanCodeManeger manager] setRecognitionAreaRect:self.scanView.frame];

// 显示预览（必要操作）
[[CLScanCodeManeger manager] loadWithView:self.view resultHandler:^(NSString * _Nonnull result) {
    // 可以执行跳转到指定页了
    
}];
```
#### 3.开始和停止扫描
```objc
- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  // 开始扫描
  [[CLScanCodeManeger manager] startScan];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  // 停止扫描
  [[CLScanCodeManeger manager] stopScan];
}
```

### 其他
CLScanCodeManeger 	二维码识别类
UIImage+CLQRCode 	二维码生成类
CLScanAnimationView 扫描框视图类