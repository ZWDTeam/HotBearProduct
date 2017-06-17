//
//  UIView+Badge.h
//  HotBear
//
//  Created by Cody on 2017/6/9.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HBAnnotationType) {
    HBAnnotationTypePoint,
    HBAnnotationTypeNumber,
    HBAnnotationTypeNone
};

@interface UIView (Badge)

@property (assign , nonatomic)int badgeCount;

@property (assign , nonatomic)HBAnnotationType annotationType;


- (void)setOffPoint:(CGPoint)offPoint;

@end
