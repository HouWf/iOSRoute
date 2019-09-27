//
//  GCWKWebViewController.h
//  GueCompetition
//
//  Created by hzhy001 on 2018/6/25.
//  Copyright © 2018年 hzhy001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface GCWKWebViewController : UIViewController

- (void)loadHtml:(NSString *)html;

- (void)loadContent:(NSString *)content;

- (void)loadURL:(NSString *)url;

/**
 刷新webView

 @param url url地址
 */
- (void)reloadWebViewWithUrl:(NSURL *)url;

- (NSString *)userAgent:(NSString *)oldUserAgent;

- (NSString *)getUrl;

- (void)handleValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context;

@end
