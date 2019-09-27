//
//  GCWKWebViewController.m
//  GueCompetition
//
//  Created by hzhy001 on 2018/6/25.
//  Copyright © 2018年 hzhy001. All rights reserved.
//

#import "GCWKWebViewController.h"

@interface GCWKWebViewController ()<WKScriptMessageHandler, WKNavigationDelegate, WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *content;

@end

@implementation GCWKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadWebView];
    [self loadPregressView];
}

- (void)back{
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }else{
        [self.webView stopLoading];
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)viewWillDisappear:(BOOL)animated{
    if (@available(iOS 9.0, *)) {
        //        NSSet *websiteDataTypes = [NSSet setWithArray:@[WKWebsiteDataTypeDiskCache]];
        NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        NSDate *dataFrom = [NSDate dateWithTimeIntervalSince1970:0];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dataFrom completionHandler:^{
            
        }];
    } else {
        // Fallback on earlier versions
    }
}

- (void)loadWebView{
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.preferences = [[WKPreferences alloc] init];
    config.preferences.minimumFontSize = 10;
    config.preferences.javaScriptEnabled = YES;
    config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
    // 初始化wkWeb
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds
                                      configuration:config];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    self.webView.allowsBackForwardNavigationGestures = NO;
    [self.view addSubview:self.webView];
    
    // 添加KVO监听
    [self.webView addObserver:self
                   forKeyPath:@"loading"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    [self.webView addObserver:self
                   forKeyPath:@"title"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    [self.webView addObserver:self
                   forKeyPath:@"estimatedProgress"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    
    [self.webView addObserver:self
                   forKeyPath:@"URL"
                      options:NSKeyValueObservingOptionNew
                      context:nil];

    if (@available(iOS 12.0, *)){
        NSString *baseAgent = [self.webView valueForKey:@"applicationNameForUserAgent"];
        [self.webView setValue:[self userAgent:baseAgent] forKey:@"applicationNameForUserAgent"];
        [self requeUrl];
    }
    else{
        __weak typeof(self) weakSelf = self;
        [self.webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError *error) {
            __strong typeof(weakSelf) self = weakSelf;
            if (@available(iOS 9.0, *)) {
                [self.webView setCustomUserAgent:[self userAgent:result]];
            } else {
                [self.webView setValue:[self userAgent:result] forKey:@"applicationNameForUserAgent"];
            }
            
            [self requeUrl];
        }];
    }
}

- (void)requeUrl{
    if ([self getUrl]) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[self getUrl]]]];
    } else if (self.content) {
        [self.webView loadHTMLString:self.content baseURL:nil];
    }
}

- (NSString *)userAgent:(NSString *)oldUserAgent {
    return oldUserAgent;
}

- (void)dealloc{
    [self.webView removeObserver:self forKeyPath:@"loading"];
    [self.webView removeObserver:self forKeyPath:@"title"];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (NSString *)getUrl {
    return self.url;
}

- (void)loadHtml:(NSString *)path {
    // 本地html文件
    NSURL *pathdd = [[NSBundle mainBundle] URLForResource:path withExtension:@"html"];
    self.url = [NSURLRequest requestWithURL:pathdd];
}

- (void)loadContent:(NSString *)content {
    self.content = content;
}

- (void)loadURL:(NSString *)url {
    self.url = url;
}

- (void)reloadWebViewWithUrl:(NSURL *)url
{
    self.url = url.absoluteString;
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)loadPregressView{
    self.progressView = [[UIProgressView alloc] init];
    self.progressView.frame = self.view.bounds;
    [self.progressView setTintColor:[UIColor colorWithRed:0.400 green:0.863 blue:0.133 alpha:1.000]];
    self.progressView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.progressView];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"loading"]) {
        NSLog(@"loading");
    }
    else if ([keyPath isEqualToString:@"title"]) {
        if (self.navigationItem.title.length == 0) {
            self.title = self.webView.title;
        }
    }
    else if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.webView.estimatedProgress;
    }
    else if ([keyPath isEqualToString:@"URL"]){
        if ([Router supports:self.webView.URL.absoluteString]) {
            if (self.webView.canGoBack) {
                [self.webView goBack];
            }
            
            [Router push:self url:self.webView.URL.absoluteString];
        }
    }
    
    // 加载完成
    if (!self.webView.loading) {
        // 处理JS代码.
#if 0
        NSString *js = @"callJsAlert()";  // 所执行的js代码
        [self.webView evaluateJavaScript:js completionHandler:^(id _Nullable response, NSError * _Nullable error) {
            NSLog(@"response: %@ error: %@", response, error);
            self.progressView.alpha = 0;
        }];
#else
        [UIView animateWithDuration:0.5 animations:^{
            self.progressView.alpha = 0;
        }];
#endif
    }
    
    [self handleValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (void)handleValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSString *,id> *)change
                      context:(void *)context {
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString *hostname = navigationAction.request.URL.host.lowercaseString;
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated
        && [hostname containsString:@"itunes.apple.com"]) {
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        if (!self.webView.isLoading) {
            self.progressView.alpha = 0;
        }
        else{
            self.progressView.alpha = 1.0;
        }
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    decisionHandler(WKNavigationResponsePolicyAllow);
    
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    if ([error code] == NSURLErrorCancelled) {
        return;
    }
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    
}

#pragma mark - WKUIDelegate
- (void)webViewDidClose:(WKWebView *)webView {
    
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *__nullable credential))completionHandler {
    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
#if DEBUG
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
#else
    completionHandler();
#endif
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    
    //    NSLog(@"runJavaScriptConfirmPanelWithMessage : %@", message);
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
