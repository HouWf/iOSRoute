//
//  WebViewController.m
//  BFPlus
//
//  Created by hzhy002 on 2019/7/2.
//  Copyright © 2019 hzhy001. All rights reserved.
//
#import "WebViewController.h"

@implementation WebViewController

- (NSString *)userAgent:(NSString *)oldUserAgent {
    NSDictionary *bundleDic = [[NSBundle mainBundle] infoDictionary];
    NSString *version = bundleDic[@"CFBundleShortVersionString"];
    return [NSString stringWithFormat:@"%@ BFPLUS %@", oldUserAgent, version];
}

- (BOOL)handleNavigation:(NSURL *)url {
    if ([url.host.lowercaseString hasSuffix:@".buff8.com"]) {
        if (url.query) {
            if (![url.query hasPrefix:@"token="] && ![url.query containsString:@"&token="]) {
                url = [NSURL URLWithString:[NSString stringWithFormat:@"%@&token=%@", url, [self urlStringWithUrl:url]]];
            }
        } else {
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?token=%@", url, [self urlStringWithUrl:url]]];
        }
    }
    return [super handleNavigation:url];
}

- (NSURL *)handleUrl:(NSURL *)url {
    if ([url.host.lowercaseString hasSuffix:@".buff8.com"]) {
        if (url.query) {
            if ([url.query hasPrefix:@"token="] || [url.query containsString:@"&token="]) {
                return url;
            } else {
                return [NSURL URLWithString:[NSString stringWithFormat:@"%@&token=%@", url, [self urlStringWithUrl:url]]];
            }
        } else {
            return [NSURL URLWithString:[NSString stringWithFormat:@"%@?token=%@", url, [self urlStringWithUrl:url]]];
        }
    } else {
        return url;
    }
}

- (NSString *)urlStringWithUrl:(NSURL *)url{
    NSString *currentToken = @"可以填充token";
    if (currentToken == nil) {
        currentToken = @"";
    }
    return currentToken;
}

@end
