//
//  Router.h
//  BFPlus
//
//  Created by hzhy002 on 2019/7/2.
//  Copyright © 2019 hzhy001. All rights reserved.
//

#import "State.h"

NS_ASSUME_NONNULL_BEGIN

@interface Router : NSObject

/**
 初始化
 */
+ (void)initial;

/**
 初始化指定对象

 @param clazz 指定默认webview组件
 */
+ (void)initial:(nullable Class)clazz;

/**
 修改默认的webview组件
 */
+ (void)setDefaultView:(nullable Class)clazz;


/**
 路由系统是否可以处理当前的url
 */
+ (BOOL)supports:(NSString *)url;

/**
 注册路由

 @param pattern 路由url地址
 @param clazz 对象
 */
+ (void)reg:(NSString *)pattern clazz:(nullable Class)clazz;

+ (void)reg:(NSString *)pattern clazzString:(NSString *)clazzString;

// push
+ (void)push:(UIViewController *)controller url:(NSString *)url;

+ (void)push:(UIViewController *)controller url:(NSString *)url params:(NSDictionary *)params;

+ (void)push:(UIViewController *)controller url:(NSString *)url params:(NSDictionary *)params animated:(BOOL)animated;

+ (void)push:(UIViewController *)controller url:(NSString *)url animated:(BOOL)animated;

// present
+ (void)present:(UIViewController *)controller url:(NSString *)url;

+ (void)present:(UIViewController *)controller url:(NSString *)url animated:(BOOL)animated;

+ (void)present:(UIViewController *)controller url:(NSString *)url params:(NSDictionary *)params;

+ (void)present:(UIViewController *)controller url:(NSString *)url params:(NSDictionary *)params animated:(BOOL)animated;

@end

@interface RouterRule : NSObject

- (BOOL)matches:(NSString *)url;

- (NSMutableDictionary *)getParams:(NSString *)url;

@property (nonatomic, strong) NSString *pattern;

@property (nonatomic, strong) Class clazz;

@end

NS_ASSUME_NONNULL_END
