//
//  DFSound.m
//  ORNA
//
//  Created by DFD on 2016/12/9.
//  Copyright © 2016年 dfd. All rights reserved.
//

#import "DFSound.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation DFSound

+ (void)vibrate   {
    AudioServicesPlaySystemSound(1057);
}

@end
