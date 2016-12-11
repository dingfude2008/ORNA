//
//  UINavigationBar+DFBackgroundImage.m
//  ORNA
//
//  Created by DFD on 2016/12/10.
//  Copyright © 2016年 dfd. All rights reserved.
//

#import "UINavigationBar+DFBackgroundImage.h"
#import <objc/runtime.h>

@implementation UINavigationBar (DFBackgroundImage)
- (void)drawRect:(CGRect)rect {
    UIImage *image = [UIImage imageNamed:@"tabar"];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}
@end
