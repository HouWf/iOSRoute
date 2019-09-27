//
//  BaseWebViewController.h
//  BFPlus
//
//  Created by hzhy002 on 2019/7/2.
//  Copyright © 2019 hzhy001. All rights reserved.
//

#import "GCWKWebViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseWebViewController : GCWKWebViewController

- (BOOL)handleNavigation:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
