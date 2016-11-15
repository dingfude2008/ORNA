//
//  NSTimer+DF_helper.h
//  常用分类收集 -- NSTimer 帮助类
//
//  Created by 丁付德 on 16/5/7.
//  Copyright © 2016年 dfd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (DFHelper)

// 停止
-(void)stop;

// 暂停
-(void)pause;

// 继续
-(void)_continue;

// 初始化
+(instancetype)sheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                          block:(void(^)())block
                                        repeats:(BOOL)repeats;

@end
