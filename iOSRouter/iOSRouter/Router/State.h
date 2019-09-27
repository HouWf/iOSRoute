//
//  State.h
//  BFPlus
//
//  Created by hzhy002 on 2019/7/2.
//  Copyright © 2019 hzhy001. All rights reserved.
//

#import <XAspect/XAspect.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface State : NSObject

+ (void)initial;

+ (void)set:(UIViewController *)instance params:(NSDictionary *)params;

+ (void)remove:(UIViewController *)instance;

+ (NSString *)get:(UIViewController *)instance key:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
