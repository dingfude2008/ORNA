//
//  NSTimer+DF_helper.m
//  EasyIOSDemo
//
//  Created by 丁付德 on 16/5/7.
//  Copyright © 2016年 dfd. All rights reserved.
//

#import "NSTimer+DFHelper.h"

@implementation NSTimer (DFHelper)

// 停止
-(void)stop
{
    NSLog(@"----------- NSTimer  停止");
    if (self) {
        [self setFireDate:[NSDate distantFuture]];
        [self invalidate];
    }
}

// 暂停
-(void)pause
{
    if (self) {
        [self setFireDate:[NSDate distantFuture]];
    }
}

// 继续
-(void)_continue
{
    if (self) {
        [self setFireDate:[NSDate date]];
    }
}

// 初始化
+(instancetype)sheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                          block:(void(^)())block
                                        repeats:(BOOL)repeats{
    if (![NSThread currentThread].isMainThread) {
        NSLog(@"当前线程   不是主线程");return nil;
    }else{
        NSTimer *timer = [self scheduledTimerWithTimeInterval:interval
                                                       target:self
                                                     selector:@selector(DF_blockInvoke:)
                                                     userInfo:[block copy]
                                                      repeats:repeats];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        return timer;
    }
}

+(void)DF_blockInvoke:(NSTimer *)timer{
    void (^block)() = timer.userInfo;
    if (block) {
        block();
        block = NULL;
    }
}



@end
