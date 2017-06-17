//
//  HBViewFrameManager.m
//  HotBear
//
//  Created by Cody on 2017/3/28.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBViewFrameManager.h"

@implementation HBViewFrameManager

+ (CGPoint)viewStartPoint:(UIView *)view{
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect rect=[view convertRect:view.bounds toView:window];
    return rect.origin;
}

+ (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font constraintSize:(CGSize)constraintSize
{
    CGSize stringSize = CGSizeZero;
    
    NSDictionary *attributes = @{NSFontAttributeName:font};
    NSInteger options = NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin;
    CGRect stringRect = [string boundingRectWithSize:constraintSize options:options attributes:attributes context:NULL];
    stringSize = stringRect.size;
    
    return stringSize;
}


@end
