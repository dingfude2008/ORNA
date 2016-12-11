//
//  HelperConfig.h
//  常用分类收集
//
//  Created by 丁付德 on 16/8/3.
//  Copyright © 2016年 dfd. All rights reserved.
//

#ifndef HelperMacro_h
#define HelperMacro_h

// ------- 本地存储
#define GetUserDefault(key)                 [[NSUserDefaults standardUserDefaults] objectForKey:key]
#define SetUserDefault(k, v)                [[NSUserDefaults standardUserDefaults] setObject:v forKey:k]; [[NSUserDefaults standardUserDefaults]  synchronize];
#define RemoveUserDefault(k)                [[NSUserDefaults standardUserDefaults] removeObjectForKey:k]; [[NSUserDefaults standardUserDefaults] synchronize];


// 系统相关
#define SystemVersion              [[[UIDevice currentDevice] systemVersion] doubleValue]  // 当前系统版本
#define IOS7Later                  ((SystemVersion>=7.0)?YES:NO)    // 系统版本是否是iOS7+
#define IS_IPad                    [[UIDevice currentDevice].model rangeOfString:@"iPad"].length > 0// 是否是ipad
#define IPhone4                    (ScreenHeight == 480)
#define IPhone5                    (ScreenHeight == 568)
#define IPhone6                    (ScreenHeight == 667)
#define IPhone6P                   (ScreenHeight == 736)
#define DString(_S)                NSLocalizedString(_S, @"")
#define ScreenHeight               [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth                [[UIScreen mainScreen] bounds].size.width
#define StateBarHeight             20
#define NavBarHeight               64
#define BottomHeight               49
#define RealHeight(_k)             ScreenHeight * (_k / 1280.0)
#define RealWidth(_k)              ScreenWidth * (_k / 720.0)
#define ScreenRadio                0.562 // 屏幕宽高比
#define DFontSize(_key)            [UIFont systemFontOfSize:_key]   // 字体

#define MBShow(message)             [MBProgressHUD show:message toView:self.windowView];
#define MBShowAll                   [MBProgressHUD showHUDAddedTo:self.windowView animated:YES];
#define MBHide                      [MBProgressHUD hideAllHUDsForView:self.windowView animated:YES];
// 测试
#if DEBUG
    #import <FBRetainCycleDetector/FBRetainCycleDetector.h>
#endif

#define Border(_label, _color)     _label.layer.borderWidth = 1; _label.layer.borderColor = _color.CGColor;
#define BorderRed(_label)     _label.layer.borderWidth = 3; _label.layer.borderColor = DRed.CGColor;
#define BorderBlue(_label)     _label.layer.borderWidth = 4; _label.layer.borderColor = DBlue.CGColor;

#define DefaultLogoImage                    [UIImage imageNamed:DefaultLogo]
#define DefaultCircleLogoImage              [UIImage imageNamed:DefaultCircleLogo]
#define DefaultLogo_Gender(_k)              [UIImage imageNamed:(_k ? DefaultLogo_girl:DefaultLogo_boy)]
#define LoadingImage                        [UIImage imageNamed:LoadImage]


#define ConnectedImage                      @"connected"
#define DisConnectedImage                   @"disconnected"
#define DefaultUUIDString                   @"DefaultUUIDString"
#define DefaultDeviceValue                  @"DefaultDeviceValue"


// 时间
#define DNow                       [NSDate date]

#define DDBLE                      [BLEManager sharedManager]
#define DDSearchTime               10

// 测试
#if DEBUG
    #import <FBRetainCycleDetector/FBRetainCycleDetector.h>
#endif

#endif /* HelperConfig_h */
