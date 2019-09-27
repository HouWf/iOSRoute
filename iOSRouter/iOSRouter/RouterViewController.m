//
//  RouterViewController.m
//  iOSRouter
//
//  Created by hzhy001 on 2019/9/27.
//  Copyright © 2019 hzhy001. All rights reserved.
//

#import "RouterViewController.h"

@interface RouterViewController ()

@end

@implementation RouterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"第二页";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 30)];
    label.textColor = UIColor.greenColor;
    NSString *routerId = [State get:self key:@"routerId"];
    if (routerId.length) {
        label.text = routerId;
    }
    else{
        label.text = @"无信息";
    }
    [self.view addSubview:label];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
