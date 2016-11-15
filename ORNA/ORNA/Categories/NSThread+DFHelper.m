//
//  NSThread+DFHelper.m
//  常用分类收集
//
//  Created by 丁付德 on 16/8/3.
//  Copyright © 2016年 dfd. All rights reserved.
//

#import "NSThread+DFHelper.h"

@implementation NSThread (DFHelper)

+ (BOOL)isMainQueue {
    static const void* mainQueueKey = @"mainQueue";
    static void* mainQueueContext = @"mainQueue";
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_queue_set_specific(dispatch_get_main_queue(), mainQueueKey, mainQueueContext, nil);
    });
    return dispatch_get_specific(mainQueueKey) == mainQueueContext;
}

@end
