//
//  WebViewController.m
//  ScanCodeDemo
//
//  Created by CL on 2019/6/12.
//  Copyright © 2019 CL. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>// iOS12推荐使用WKWebView，支持iOS8+

@interface WebViewController ()<WKNavigationDelegate>

/** WebView */
@property (strong, nonatomic) WKWebView *webView;

/** 链接 */
@property (nonatomic, strong) NSString *urlString;

@end

@implementation WebViewController

- (instancetype)initWithUrlString:(NSString *)urlString
{
	self = [super init];
	if (self) {
		self.urlString = urlString;
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.title = @"Web";
	
	[self.view addSubview:self.webView];
	NSURL *URL = [NSURL URLWithString:self.urlString];
	NSURLRequest *request = [NSURLRequest requestWithURL:URL];
	[self.webView loadRequest:request];
}

- (WKWebView *)webView {
	if (_webView == nil) {
		_webView = [[WKWebView alloc]initWithFrame:self.view.bounds];
		_webView.backgroundColor = UIColor.whiteColor;
		_webView.scrollView.bounces = NO;
		_webView.opaque = NO;
		_webView.navigationDelegate = self;
	}
	return _webView;
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
