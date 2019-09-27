iOSRouter路由介绍
===================================  

iOS路由跳转，通过url跳转到指定页面。支持push、present。
-----------------------------------  

路由地址对应有注册路由地址的Controller会直接进行跳转，否则会跳转到WKWebviwe界面加载URL。

使用方式：引入头文件 --- 配置路由地址 --- 设置初始化页面 --- AppDelegate调用初始化 --- 触发页面跳转 --- 获取路由传输params数据

###  step 1：

        引入头文件：
        #import "Router.h"
        #import "AppRoutorURL.h"


### step 2：

AppRoutorURL.h配置路由地址

        #define APP_ROUTOR_BUSINESSSETTINGS     ROUTER(@"consumer/settings")

### step 3:

AppRoutorConfig.m通过initial初始化指定Controller。

        + (void)initial{\n
            // 通过类名初始化
            [Router reg:APP_ROUTOR_BUSINESSSETTINGS clazzString:@"RouterViewController"];
            // 通过class初始化
            //      [Router reg:APP_ROUTOR_BUSINESSSETTINGS clazz:[RouterViewController class]];
        }

### step 4：\<br /\>

AppDelegate.m中初始化路由和路由跳转Controller

// 初始化router

        [Router initial:[WebViewController class]];
// 初始化路由页面

        [AppRoutorConfig initial];


### step 5：

触发页面跳转支持push和present

// PUSH 

// 单纯跳转

        [Router push:self url:kRouterUrl(APP_ROUTOR_BUSINESSSETTINGS)];

// 携带数据跳转方式一

        [Router push:self url:kRouterUrl(APP_ROUTOR_BUSINESSSETTINGS) params:@{@"routerId":@"123"}];

// 携带数据跳转方式二

        NSString *urlStr = [NSString stringWithFormat:@"%@?routerId=%@",kRouterUrl(APP_ROUTOR_BUSINESSSETTINGS),@"123"];
        [Router push:self url:urlStr];

// PRESENT

// 同样的三种跳转方式

        [Router present:self url:kRouterUrl(APP_ROUTOR_BUSINESSSETTINGS)];

// 携带数据跳转方式一

        [Router present:self url:kRouterUrl(APP_ROUTOR_BUSINESSSETTINGS) params:@{@"routerId":@"123"}];

// 携带数据跳转方式二

        NSString *urlStr = [NSString stringWithFormat:@"%@?routerId=%@", kRouterUrl(APP_ROUTOR_BUSINESSSETTINGS),@"123"];
        [Router present:self url:urlStr];


### step 6:

路由页接收指定数据：

        NSString *routerId = [State get:self key:@"routerId"];

至此路由跳转指定页已完成。

不足：<\br  />
跳转方式单一，可扩展性高。
数据单向传输，未实现数据回传。
