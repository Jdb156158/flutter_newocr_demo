//
//  WebVC.m
//  Thunder
//
//  Created by 鞠汶成 on 2018/11/24.
//  Copyright © 2018 Lance Wu. All rights reserved.
//

#import "WebVC.h"
#import <WebKit/WebKit.h>

@interface WebVC ()<WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler>

@property(nonatomic, copy) NSString *originalUrl;
@property(nonatomic, strong) WKWebView *webView;

@end

@implementation WebVC

- (instancetype)initWithUrlString:(NSString *)urlString {
    if (self = [super init]) {
        _originalUrl = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupWebView];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(dismissVC)];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.originalUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [self.webView loadRequest:request];
    
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _webView.frame = self.view.bounds;
}

- (void)setupWebView {
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.userContentController = [WKUserContentController new];
    [configuration.userContentController addScriptMessageHandler:self name:@"AppModel"];
    _webView = [[WKWebView alloc] initWithFrame:[UIScreen mainScreen].bounds configuration:configuration];
    _webView.configuration.allowsInlineMediaPlayback = NO;
    _webView.navigationDelegate = self;
    _webView.UIDelegate = self;
    [self.view addSubview:_webView];
    _webView.backgroundColor = [UIColor clearColor];
    [_webView setOpaque:NO];
    
    
    
        // 设置user agent
    NSString * customUserAgent = @"Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_3 like Mac OS X) AppleWebKit/603.3.8 (KHTML, like Gecko) Mobile/14G60 NetType/WIFI Language/en";
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent": customUserAgent}];
    
        //    [_webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError *error) {
        //        NSLog(@"%@", result);
        //    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self.webView selector:@selector(reload) name:@"RefreshWKWebView" object:nil];
}

- (void)changeUrl:(NSString *)url {
    _originalUrl = url;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.originalUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [self.webView loadRequest:request];
}

- (void)dismissVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)userContentController:(nonnull WKUserContentController *)userContentController didReceiveScriptMessage:(nonnull WKScriptMessage *)message {
    NSLog(@"未实现");
}

@end
