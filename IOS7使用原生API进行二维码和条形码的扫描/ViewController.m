//
//  ViewController.m
//  iOS7使用原生API进行二维码和条形码的扫描
//
//  Created by 思久科技 on 16/5/6.
//  Copyright © 2016年 Seejoys. All rights reserved.
//

#import "ViewController.h"

#import "CKScanHelper.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //扫描框定义（可不要，全屏扫描）
    CGSize windowSize = [UIScreen mainScreen].bounds.size;    
    CGSize scanSize = CGSizeMake(windowSize.width * 3/4, windowSize.width * 3/4);
    CGRect scanRect = CGRectMake((windowSize.width-scanSize.width)/2, 30, scanSize.width, scanSize.height);
    UIView *scanRectView = [UIView new];
    scanRectView.layer.borderColor = [UIColor redColor].CGColor;
    scanRectView.layer.borderWidth = 1;
    
    //封装调用方法
    [[CKScanHelper manager] showLayer:self.view];
    [[CKScanHelper manager] setScanningRect:scanRect scanView:scanRectView];
    [[CKScanHelper manager] setScanBlock:^(NSString *scanResult){
        NSLog(@"%@", scanResult);
    }];
}

- (IBAction)scan:(id)sender {
    
    [[CKScanHelper manager] startRunning];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
