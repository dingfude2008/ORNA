//
//  Macro.h
//  VitaFun
//
//  Created by 丁付德 on 16/9/6.
//  Copyright © 2016年 dfd. All rights reserved.
//

#ifndef Macro_h
#define Macro_h

#import <Availability.h>

#ifdef __OBJC__
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#endif


#ifdef DEBUG
    #define isDeve                        YES
#else
    #define isDeve                        NO
#endif


#ifndef __OPTIMIZE__
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...) {}
#endif


#define DDWeakVV                            DDWeak(self)
#define DDStrongVV                          DDStrong(self)

#define DDWeak(type)                        __weak typeof(type) weak##type = type;
#define DDStrong(type)                      __strong typeof(type) type = weak##type;


// ------- 系统相关
#define IPhone4                             (ScreenHeight == 480)
#define IPhone5                             (ScreenHeight == 568)
#define IPhone6                             (ScreenHeight == 667)
#define IPhone6P                            (ScreenHeight == 736)

// 中英文
#define kString(_S)                         NSLocalizedString(_S, @"")
#define St(_k)                              [@(_k) description]

// ------- 宽高
#define ScreenHeight                        [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth                         [[UIScreen mainScreen] bounds].size.width
#define StateBarHeight                      20
#define NavBarHeight                        64
#define BottomHeight                        49
#define RealHeight(_k)                      ScreenHeight * (_k / 1280.0)
#define RealWidth(_k)                       ScreenWidth * (_k / 720.0)
#define ScreenRadio                         0.562                           // 屏幕宽高比


#define NextWaitInMain(_k)                  [DFD performBlockInMain:^{ _k }]
#define NextWaitInMainAfter(_k, _v)         [DFD performBlockInMain:^{ _k } afterDelay:_v]
#define NextWaitInCurrentTheard(_k, _v)     [DFD performBlockInCurrentTheard:^{ _k } afterDelay:_v]
#define NextWaitInGlobal(_k)                [DFD performBlockInGlobal:^{ _k }]
#define NextWaitInGlobalAfter(_k, _v)       [DFD performBlockInGlobal:^{ _k } afterDelay:_v]
#define NextWaitOnce(_k)                    [DFD performBlockOnce:^{ _k }]

#define Bigger(_a, _b)                      ((_a) > (_b) ? _a : _b)
#define Smaller(_a, _b)                     ((_a) < (_b) ? _a : _b)




#endif /* Macro_h */
