//
//  HBChatMsgNavigationBar.m
//  HotBear
//
//  Created by Cody on 2017/6/15.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBChatMsgNavigationBar.h"

@implementation HBChatMsgNavigationBar


- (void)drawRect:(CGRect)rect{
    
    CGContextRef context  = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextSetLineWidth(context, 0.5);
    CGContextMoveToPoint(context, 0, rect.size.height);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
    CGContextStrokePath(context);
    
}

@end
