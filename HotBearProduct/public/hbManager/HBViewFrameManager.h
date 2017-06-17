//
//  HBViewFrameManager.h
//  HotBear
//
//  Created by Cody on 2017/3/28.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HBViewFrameManager : NSObject

+ (CGPoint)viewStartPoint:(UIView *)view;

+ (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font constraintSize:(CGSize)constraintSize;

@end
