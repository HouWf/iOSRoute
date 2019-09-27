//
//  AppRoutorURL.h
//  BFPlus
//
//  Created by hzhy002 on 2019/7/2.
//  Copyright © 2019 hzhy001. All rights reserved.
//

#ifndef AppRoutorURL_h
#define AppRoutorURL_h

static NSString * const APP_SERVER = @"www.baidu.com";
static NSString * const APP_PROTOCOL = @"http://";

// 设置路由地址
#define ROUTER(url) [NSString stringWithFormat:@"%@/%@",APP_SERVER, url]
// 跳转路由地址
#define kRouterUrl(url) [NSString stringWithFormat:@"%@%@", APP_PROTOCOL, url]

// viewController
#define APP_ROUTOR_BUSINESSSETTINGS     ROUTER(@"consumer/settings")

#endif /* BFPAppRoutorURL_h */
