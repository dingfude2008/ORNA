//
//  AppDelegate.h
//  ORNA
//
//  Created by DFD on 16/11/2.
//  Copyright © 2016年 dfd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YRSideViewController.h"
#import "CustomTabBarController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic          ) YRSideViewController   *sideViewController;
@property (strong, nonatomic          ) CustomTabBarController *customTb;
@property (assign, nonatomic          ) id                     left;

@end

