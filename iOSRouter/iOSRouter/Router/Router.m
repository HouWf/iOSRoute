//
//  Router.m
//  BFPlus
//
//  Created by hzhy002 on 2019/7/2.
//  Copyright © 2019 hzhy001. All rights reserved.
//

#import "Router.h"
#import "DefaultWebViewController.h"
#import "State.h"

static NSMutableArray <RouterRule *>*routers;
static RouterRule *defaultView;

@implementation Router

+ (void)initial {
    routers = [[NSMutableArray alloc] init];
    defaultView = [[RouterRule alloc] init];
    defaultView.clazz = [DefaultWebViewController class];
    [State initial];
}

+ (void)initial:(nullable Class)clazz {
    [Router initial];
    [Router setDefaultView:clazz];
}

+ (void)setDefaultView:(nullable Class)clazz {
    defaultView.clazz = clazz;
}

+ (void)reg:(NSString *)pattern clazz:(nullable Class)clazz {
    RouterRule *rule = [[RouterRule alloc] init];
    rule.pattern = pattern;
    rule.clazz = clazz;
    [routers addObject:rule];
}
+ (void)reg:(NSString *)pattern clazzString:(NSString *)clazzString{
    Class class = NSClassFromString(clazzString);
    [Router reg:pattern clazz:class];
}

+ (UIViewController *)view:(NSString *)url {
    RouterRule *rule = [Router match:url];
    UIViewController *view = (UIViewController *)[[rule.clazz alloc] init];
    NSMutableDictionary* params = [rule getParams:url];
    [params setValue:url forKey:@"_url"];
    [params setValue:rule.pattern forKey:@"_pattern"];
    [State set:view params:params];
//    if ([view isKindOfClass:[BaseWebViewController class]]) {
//        [(BaseWebViewController *)view ]
//    }
    [view.navigationController setNavigationBarHidden:NO animated:YES];
    return view;
}

+ (RouterRule *)match:(NSString *)url {
    for (int i = 0; i < [routers count]; i++) {
        if ([routers[i] matches:url]) {
            return routers[i];
        }
    }
    return defaultView;
}

+ (BOOL)supports:(NSString *)url {
    for (int i = 0; i < [routers count]; i++) {
        if ([routers[i] matches:url]) {
            return YES;
        }
    }
    return NO;
}

+ (void)push:(UIViewController *)controller url:(NSString *)url params:(NSDictionary *)params {
    [Router push:controller url:[Router join:url params:params]];
}

+ (void)push:(UIViewController *)controller url:(NSString *)url {
    [Router push:controller url:url animated:YES];
}

+ (void)push:(UIViewController *)controller url:(NSString *)url params:(NSDictionary *)params animated:(BOOL)animated {
    [Router push:controller url:[Router join:url params:params] animated:YES];
}

+ (void)push:(UIViewController *)controller url:(NSString *)url animated:(BOOL)animated {
    [controller.navigationController pushViewController:[Router view:url] animated:animated];
}

+ (void)present:(UIViewController *)controller url:(NSString *)url params:(NSDictionary *)params {
    [Router present:controller url:[Router join:url params:params]];
}

+ (void)present:(UIViewController *)controller url:(NSString *)url {
    [Router present:controller url:url animated:YES];
}

+ (void)present:(UIViewController *)controller url:(NSString *)url params:(NSDictionary *)params animated:(BOOL)animated {
    [Router present:controller url:[Router join:url params:params] animated:YES];
}

+ (void)present:(UIViewController *)controller url:(NSString *)url animated:(BOOL)animated {
    [controller.navigationController presentViewController:[Router view:url] animated:animated completion:nil];
}

+ (NSString *)join:(NSString *)baseUrl params:(NSDictionary *)params {
    //需要拼接参数
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSString *name in [params allKeys]) {
        NSString * value = [params[name] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

//        NSString *value = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(nil,
//                                                                                               (CFStringRef)params[name], nil,
//                                                                                               (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
        [array addObject:[NSString stringWithFormat:@"%@=%@", name, value]];
    }
    return [NSString stringWithFormat:@"%@?%@", baseUrl, [array componentsJoinedByString:@"&"]];
}

@end

@implementation RouterRule
// TODO: 使用正则匹配://
- (BOOL)matches:(NSString *)url {
    if ([self.pattern isEqualToString:url]) {
        return YES;
    } else {
        NSRange range = [url rangeOfString:@"://"];
        if(range.length != 0) {
            NSString *uri = [url substringFromIndex:range.length + range.location];
            return [uri isEqualToString:self.pattern] || [uri hasPrefix:[NSString stringWithFormat:@"%@?", self.pattern]];
        } else {
            return NO;
        }
    }
}

- (NSMutableDictionary *)getParams:(NSString *)url {
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    NSString*utf8_url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *uri = [NSURL URLWithString:utf8_url];
    NSString *query = uri.query;
    NSArray *paramArray = [query componentsSeparatedByString:@"&"];
    for (int i = 0; i < [paramArray count]; i++) {
        NSString *param = paramArray[i];
        NSRange range = [param rangeOfString:@"="];
        if (range.length > 0) {
            NSString *name = [param substringToIndex:range.location];
            NSString *value = [[param substringFromIndex:range.location + range.length] stringByRemovingPercentEncoding];
            NSString *new_value = [value stringByRemovingPercentEncoding];
            [result setValue:new_value forKey:name];
        }
    }
    return result;
}

@end

