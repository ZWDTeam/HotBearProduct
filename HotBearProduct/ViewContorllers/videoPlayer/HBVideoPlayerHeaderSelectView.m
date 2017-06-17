//
//  HBVideoPlayerHeaderSelectView.m
//  HotBear
//
//  Created by Cody on 2017/6/11.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBVideoPlayerHeaderSelectView.h"

@implementation HBVideoPlayerHeaderSelectView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.7 alpha:1.0].CGColor);
    
    CGFloat startY = 7;
    CGContextMoveToPoint(context, 0, startY);
    CGContextAddLineToPoint(context, 0, rect.size.height-startY);
    
    CGContextMoveToPoint(context, rect.size.width, startY);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height-startY);
    
    CGContextDrawPath(context, kCGPathStroke);
    
}


@end
