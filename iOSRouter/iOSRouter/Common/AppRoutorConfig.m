//
//  AppRoutorConfig.m
//  iOSRouter
//
//  Created by hzhy001 on 2019/9/27.
//  Copyright © 2019 hzhy001. All rights reserved.
//

#import "AppRoutorConfig.h"
//#import "RouterViewController.h"

@implementation AppRoutorConfig

+ (void)initial{
  
    // 初始化方式一
    [Router reg:APP_ROUTOR_BUSINESSSETTINGS clazzString:@"RouterViewController"];
    // 初始化方式二
//    [Router reg:APP_ROUTOR_BUSINESSSETTINGS clazz:[RouterViewController class]];
   
}

@end
