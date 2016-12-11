//
//  AppDelegate.m
//  ORNA
//
//  Created by DFD on 16/11/2.
//  Copyright © 2016年 dfd. All rights reserved.
//

#import "AppDelegate.h"
#import "YRSideViewController.h"
#import "CustomTabBarController.h"
#import "LeftViewcontroller.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.sideViewController = [[YRSideViewController alloc] init];
    self.sideViewController.leftViewController = NSClassFromString(@"LeftViewcontroller").new;
    
    
    self.sideViewController.leftViewShowWidth = 160;
    self.sideViewController.needSwipeShowMenu = YES;
    
    self.customTb = [CustomTabBarController new];
    self.sideViewController.rootViewController = self.customTb;
    self.window.rootViewController = self.sideViewController;
    
    [self.window makeKeyAndVisible];
    
    [application setStatusBarHidden:NO];
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self runLoopBLE];
    
    return YES;
}

- (void)runLoopBLE{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
        NSString *defaultUUID = GetUserDefault(DefaultUUIDString);
        if (defaultUUID && !DDBLE.isLink && DDBLE.isOn) {
            NSLog(@"不停的连接");
            [DDBLE retrievePeripheral:defaultUUID];
            [self runLoopBLE];
        }
    });
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"applicationDidEnterBackground");
    //[self saveLastValue];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"applicationWillTerminate");
    //[self saveLastValue];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)saveLastValue
{
    if (DDBLE.arrValue) {
        SetUserDefault(DefaultDeviceValue, DDBLE.arrValue);
    }
}


@end
