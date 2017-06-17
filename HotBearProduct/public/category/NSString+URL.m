//
//  NSString+URL.m
//  HotBear
//
//  Created by Cody on 2017/4/19.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "NSString+URL.h"

@implementation NSString (URL)

- (BOOL)isUrl
{
    NSString *regex =@"[a-zA-z]+://[^\\s]*";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [urlTest evaluateWithObject:self];
}

@end
