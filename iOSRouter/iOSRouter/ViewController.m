//
//  ViewController.m
//  iOSRouter
//
//  Created by hzhy001 on 2019/9/27.
//  Copyright © 2019 hzhy001. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"第一页";
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 100, 50);
    [btn setTitle:@"路由跳转" forState:UIControlStateNormal];
    [btn setBackgroundColor:UIColor.greenColor];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

- (void)btnClick:(UIButton *)sender{
    // push
    // 方式1
    [Router push:self url:kRouterUrl(APP_ROUTOR_BUSINESSSETTINGS)];
    // 方式2
//    [Router push:self url:kRouterUrl(APP_ROUTOR_BUSINESSSETTINGS) params:@{@"routerId":@"123"}];
    // 方式3
//    NSString *urlStr = [NSString stringWithFormat:@"%@?routerId=%@", kRouterUrl(APP_ROUTOR_BUSINESSSETTINGS),@"123"];
//    [Router push:self url:urlStr];
    
    // present
    // 方式1
//    [Router present:self url:kRouterUrl(APP_ROUTOR_BUSINESSSETTINGS)];
    // 方式2
//    [Router present:self url:kRouterUrl(APP_ROUTOR_BUSINESSSETTINGS) params:@{@"routerId":@"123"}];
    // 方式3
//    [Router present:self url:urlStr];
}


@end
