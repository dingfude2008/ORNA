//
//  NSThread+DFHelper.h
//  常用分类收集 -- 判断主队列(因为 [NSThread isMainThread] 存在BUG )
//
//  Created by 丁付德 on 16/8/3.
//  Copyright © 2016年 dfd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSThread (DFHelper)

+ (BOOL)isMainQueue;

@end
