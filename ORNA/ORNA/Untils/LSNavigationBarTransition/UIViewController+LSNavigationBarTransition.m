

//
//  UIViewController+LSNavigationBarTransition.m
//  LSNavigationBarTransition
//
//  Created by ls on 16/1/16.
//  Copyright © 2016年 song. All rights reserved.
//

#import "UIColor+Extension.h"
#import "UIViewController+LSNavigationBarTransition.h"
#import <objc/runtime.h>

@implementation UIViewController (LSNavigationBarTransition)
- (void)ls_viewDidLoad
{
    [self ls_viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[[UIColor blackColor] imageWithColor] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = DBlack;
}

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ls_swizzleInstanceMethod([self class],
            @selector(viewDidLoad),
            @selector(ls_viewDidLoad));
        ls_swizzleInstanceMethod([self class],
            @selector(viewWillLayoutSubviews),
            @selector(ls_viewWillLayoutSubviews));

    });
}
- (void)ls_viewWillLayoutSubviews
{
    if ([self.navigationController isKindOfClass:NSClassFromString(@"LSNavigationController")]) {
        if (self.navigationController.viewControllers.count) {

            if (!self.ls_navigationBar) {
                [self ls_addNavigationBarIfNeed];
                self.ls_prefersNavigationBarBackgroundViewHidden = YES;
            }
        }
    }
    [self ls_viewWillLayoutSubviews];
}

- (UINavigationBar*)ls_navigationBar
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setLs_navigationBar:(UINavigationBar*)ls_navigationBar
{
    objc_setAssociatedObject(self, @selector(ls_navigationBar), ls_navigationBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)ls_prefersNavigationBarBackgroundViewHidden
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
- (void)setLs_prefersNavigationBarBackgroundViewHidden:(BOOL)hidden
{
    [[self.navigationController.navigationBar valueForKey:@"_backgroundView"]
        setHidden:hidden];
    objc_setAssociatedObject(self, @selector(ls_prefersNavigationBarBackgroundViewHidden), @(hidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)ls_addNavigationBarIfNeed
{
    if (!self.view.window) {
        return;
    }
    if (!self.navigationController.navigationBar) {
        return;
    }
    
    UIView* backgroundView = [self.navigationController.navigationBar valueForKey:@"_backgroundView"];
    CGRect rect = [backgroundView.superview convertRect:backgroundView.frame toView:self.view];
    UINavigationBar* bar = [[UINavigationBar alloc] initWithFrame:rect];
    bar.barStyle = self.navigationController.navigationBar.barStyle;
    if (bar.translucent != self.navigationController.navigationBar.translucent) {
        bar.translucent = self.navigationController.navigationBar.translucent;
    }
    bar.barTintColor = self.navigationController.navigationBar.barTintColor;
    bar.backgroundColor = self.navigationController.navigationBar.backgroundColor;
    [bar setBackgroundImage:[self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault] forBarMetrics:UIBarMetricsDefault];
    bar.shadowImage = self.navigationController.navigationBar.shadowImage;
    
    bar.translucent = self.navigationController.navigationBar.translucent;
    self.ls_navigationBar = bar;
    
    if (!self.navigationController.navigationBarHidden) {
        [self.view addSubview:self.ls_navigationBar];
    }
}


void ls_swizzleInstanceMethod(Class class, SEL originalSelector, SEL swizzledSelector)
{
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

    BOOL didAddMethod = class_addMethod(class,
        originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(class,
            swizzledSelector,
            method_getImplementation(originalMethod),
            method_getTypeEncoding(originalMethod));
    }
    else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
