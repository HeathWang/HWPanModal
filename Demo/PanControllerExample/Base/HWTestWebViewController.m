//
//  HWTestWebViewController.m
//  HWPanModalDemo
//
//  Created by heath wang on 2020/12/9.
//  Copyright © 2020 wangcongling. All rights reserved.
//

#import "HWTestWebViewController.h"
#import <HWPanModal/HWPanModal.h>
#import <WebKit/WebKit.h>


@interface HWTestWebViewController () <HWPanModalPresentable, WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webview;

@end

@implementation HWTestWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.webview = [[WKWebView alloc] initWithFrame:self.view.bounds];
    self.webview.navigationDelegate  = self;
    [self.view addSubview:self.webview];
    
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.webview.frame = self.view.bounds;
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self hw_panModalSetNeedsLayoutUpdate];
}

#pragma mark - HWPanModalPresentable

- (UIScrollView *)panScrollable {
    return self.webview.scrollView;
}

- (PanModalHeight)longFormHeight {
    return PanModalHeightMake(PanModalHeightTypeMaxTopInset, 64);
}

@end
