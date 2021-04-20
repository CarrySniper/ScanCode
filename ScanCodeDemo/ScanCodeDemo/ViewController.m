//
//  ViewController.m
//  ScanCodeDemo
//
//  Created by CL on 2019/6/10.
//  Copyright © 2019 CL. All rights reserved.
//

#import "ViewController.h"
#import "ScanViewController.h"

#import "UIImage+CLQRCode.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UISwitch *mySwitch;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	
	// 导航栏不透明
	self.navigationController.navigationBar.translucent = NO;
	
	NSString *text = @"https://github.com/CarrySniper/ScanCode.git";
	UIImage *logo = [UIImage imageNamed:@"avatar"];
	self.imageView.image = [UIImage generateQRCodeWithText:text logo:logo tintColor:[UIColor colorWithRed:227.0/255 green:129.0/255 blue:31.0/255 alpha:1.0]];
	
	self.textField.text = text;
}

#pragma mark 生成二维码
- (IBAction)generateButtonAction:(id)sender {
	if (self.textField.text.length == 0) {
		NSLog(@"文本内容为空");
		return;
	}
	self.imageView.image = [UIImage generateQRCodeWithText:self.textField.text logo:nil tintColor:[UIColor colorWithRed:227.0/255 green:129.0/255 blue:31.0/255 alpha:1.0]];
}

- (IBAction)scanPageAction:(id)sender {
	UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
	ScanViewController *vc = [story instantiateViewControllerWithIdentifier:@"ScanViewController"];
	vc.autoJump = self.mySwitch.isOn;
	[self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 监听点击事件，结束所有编辑状态。
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesBegan:touches withEvent:event];
	[self.view endEditing:YES];
}

@end
