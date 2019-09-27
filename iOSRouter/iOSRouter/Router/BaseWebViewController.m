//
//  BaseWebViewController.m
//  BFPlus
//
//  Created by hzhy002 on 2019/7/2.
//  Copyright © 2019 hzhy001. All rights reserved.
//
#import "BaseWebViewController.h"
#import "Router.h"
#import "State.h"

@interface BaseWebViewController ()

@property (nonatomic, assign) BOOL inited;

@end

@implementation BaseWebViewController

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString *hostname = navigationAction.request.URL.host.lowercaseString;
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated
        && [hostname containsString:@"itunes.apple.com"]) {
        // 对于跨域，需要手动跳转
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        // 不允许web内跳转
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        if (self.inited) {
            if ([self handleNavigation:navigationAction.request.URL]) {
                decisionHandler(WKNavigationActionPolicyCancel);
            } else {
                decisionHandler(WKNavigationActionPolicyAllow);
            }
        } else {
            NSURL *handledUrl = [self handleUrl:navigationAction.request.URL];
            if (handledUrl == navigationAction.request.URL) {
                decisionHandler(WKNavigationActionPolicyAllow);
                self.inited = YES;
            } else {
                decisionHandler(WKNavigationActionPolicyCancel);
                [self reloadWebViewWithUrl:handledUrl];
            }
        }
    }
}

- (BOOL)handleNavigation:(NSURL *)url {
    if ([Router supports:[NSString stringWithFormat:@"%@", url]]) {
        [Router push:self url:[NSString stringWithFormat:@"%@", url]];
        return YES;
    } else {
        return NO;
    }
}

- (NSURL *)handleUrl:(NSURL *)url {
    return url;
}

- (NSString *)getUrl {
    NSString *url = [State get:self key:@"_url"];
    if (url) {
        return url;
    } else {
        return [super getUrl];
    }
}

//- (void)handleValueForKeyPath:(NSString *)keyPath
//                      ofObject:(id)object
//                        change:(NSDictionary<NSString *,id> *)change
//                       context:(void *)context {
//    [super handleValueForKeyPath:keyPath ofObject:object change:change context:context];
//    if ([keyPath isEqualToString:@"URL"]) {
//        [Router push:self url:[NSString stringWithFormat:@"%@", change[keyPath]]];
//    }
//}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

@end
