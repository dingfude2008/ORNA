//
//  DFSlider.m
//  ORNA
//
//  Created by DFD on 2016/12/9.
//  Copyright © 2016年 dfd. All rights reserved.
//

#import "DFSlider.h"

@implementation DFSlider

- (CGRect)trackRectForBounds:(CGRect)bounds {
    return CGRectMake(0, 0, bounds.size.width, 5);
}

@end
