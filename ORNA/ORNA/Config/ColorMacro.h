//
//  ColorConfig.h
//  常用分类收集
//
//  Created by 丁付德 on 16/8/3.
//  Copyright © 2016年 dfd. All rights reserved.
//

#ifndef ColorMacro_h
#define ColorMacro_h

#define RGBA(_R,_G,_B,_A)       [UIColor colorWithRed:_R / 255.0f green:_G / 255.0f blue:_B / 255.0f alpha:_A]
#define RGB(_R,_G,_B)           RGBA(_R,_G,_B,1)
#define DWhite                  [UIColor whiteColor]
#define DRed                    [UIColor redColor]
#define DBlue                   [UIColor blueColor]
#define DBlack                  [UIColor blackColor]
#define DYellow                 [UIColor yellowColor]
#define DBlack                  [UIColor blackColor]
#define DClear                  [UIColor clearColor]
#define DLightGray              [UIColor lightGrayColor]
#define DWhiteA(_k)             [UIColor colorWithWhite:255 alpha:_k]
#define DBlackA(_k)             [UIColor colorWithWhite:0 alpha:_k]



#endif
