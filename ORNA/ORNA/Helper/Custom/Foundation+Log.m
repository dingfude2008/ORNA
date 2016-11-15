//
//  Foundation+Log.m
//  VitaFun
//
//  Created by 丁付德 on 16/10/28.
//  Copyright © 2016年 dfd. All rights reserved.
//

//#import "Foundation+Log.h"

#import "Foundation+Log.h"

@implementation NSArray (Log)

#ifdef DEBUG

- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *strM = [NSMutableString stringWithString:@"(\n"];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [strM appendFormat:@"\t%@,\n", obj];
    }];
    
    [strM appendString:@")"];
    
    return strM;
}

#endif

@end

@implementation NSDictionary (Log)

#ifdef DEBUG

- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *strM = [NSMutableString stringWithString:@"{\n"];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [strM appendFormat:@"\t%@ = %@;\n", key, obj];
    }];
    
    [strM appendString:@"}\n"];
    
    return strM;
}

#endif

@end
