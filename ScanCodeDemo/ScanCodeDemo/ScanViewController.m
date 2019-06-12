//
//  ScanViewController.m
//  ScanCodeDemo
//
//  Created by CL on 2019/6/10.
//  Copyright © 2019 CL. All rights reserved.
//

#import "ScanViewController.h"
#import "CLScanCodeManeger.h"
#import "CLScanAnimationView.h"

#import "WebViewController.h"

@interface ScanViewController ()

@property (weak, nonatomic) IBOutlet CLScanAnimationView *scanView;
@property (weak, nonatomic) IBOutlet UITextView *resultTextView;
@property (weak, nonatomic) IBOutlet UISwitch *torchSwitch;

@end

@implementation ScanViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.resultTextView.layoutManager.allowsNonContiguousLayout = NO;
	self.torchSwitch.on = [[CLScanCodeManeger manager] torchStatus];
	// 高级图片不变形拉伸
	UIImage *image = [UIImage imageNamed:@"qrcode_border"];
	CGFloat inset = 102.0/4;
	image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(inset, inset, inset, inset) resizingMode:UIImageResizingModeStretch];
	self.scanView.imageView.image = image;
	self.scanView.scanLine.image = [UIImage imageNamed:@"qrcode_scanline_barcode"];
	
	// 设置扫描识别区域(不是必要操作)
	[self.scanView.superview layoutIfNeeded];
	[[CLScanCodeManeger manager] setRecognitionAreaRect:self.scanView.frame];
	
	// 获取相机授权状态(不是必要操作)
	AVAuthorizationStatus authStatus = [[CLScanCodeManeger manager] captureDeviceAuthorizationStatus];
	if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied) {
		//无权限
		UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"扫一扫需要开启应用相机权限" preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
			
		}];
		[alertController addAction:cancelAction];
		[self presentViewController:alertController animated:YES completion:nil];
	}
	
	// 显示预览（必要）
	[[CLScanCodeManeger manager] loadWithView:self.view resultHandler:^(NSString * _Nonnull result) {
		// 可以执行跳转到指定页了
		if (self.autoJump && [self achiveStringWithWeb:result]) {
			// 停止扫描
			[[CLScanCodeManeger manager] stopScan];
			
			WebViewController *vc = [[WebViewController alloc]initWithUrlString:result];
			[self.navigationController pushViewController:vc animated:YES];
			self.resultTextView.text = [NSString stringWithFormat:@"%@\n网址：%@", self.resultTextView.text, result];
		} else {
			self.resultTextView.text = [NSString stringWithFormat:@"%@\n%@", self.resultTextView.text, result];
		}
		
		[self.resultTextView scrollRangeToVisible:NSMakeRange(self.resultTextView.text.length, 1)];
	}];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	// 开始扫描
	[[CLScanCodeManeger manager] startScan];
	// 开始扫描动画
	[self.scanView startAnimation];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	// 停止扫描
	[[CLScanCodeManeger manager] stopScan];
	// 停止扫描动画
	[self.scanView stopAnimation];
}

#pragma mark - 正则：是不是有效网址
- (BOOL)achiveStringWithWeb:(NSString *)urlString {
	NSString *regex = @"[a-zA-z]+://.*";
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
	return [predicate evaluateWithObject:urlString];
}

#pragma mark - 闪光灯
- (IBAction)torchDidChangeAction:(UISwitch *)sender {
	[[CLScanCodeManeger manager] torchChange];
	self.torchSwitch.on = [[CLScanCodeManeger manager] torchStatus];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
