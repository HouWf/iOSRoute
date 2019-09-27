//
//  State.m
//  BFPlus
//
//  Created by hzhy002 on 2019/7/2.
//  Copyright © 2019 hzhy001. All rights reserved.
//

#import "State.h"

#define AtAspect UIViewControllerDealloc
#define AtAspectOfClass UIViewController
@classPatchField(UIViewController)

AspectPatch(-, void, dealloc)
{
    [State remove:self];
    XAMessageForwardDirectly(dealloc);
}

@end

#undef AtAspectOfClass
#undef AtAspect

static NSMutableDictionary *states;

@implementation State

+ (void)initial {
    states = [NSMutableDictionary dictionary];
}

+ (void)set:(UIViewController *)instance params:(NSMutableDictionary *)params{
    [states setValue:params forKey:[NSString stringWithFormat:@"%p", instance]];
}

+ (void)remove:(UIViewController *)instance {
    [states removeObjectForKey:[NSString stringWithFormat:@"%p", instance]];
}

+ (NSString *)get:(UIViewController *)instance key:(NSString *)key {
    NSDictionary* params = (NSMutableDictionary*) states[[NSString stringWithFormat:@"%p", instance]];
    if (params) {
        return (NSString *)params[key];
    } else {
        return nil;
    }
}

@end
