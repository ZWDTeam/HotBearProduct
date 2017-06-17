//
//  UIView+Badge.m
//  HotBear
//
//  Created by Cody on 2017/6/9.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

NSString * const HBViewBadgeKey;
NSString * const HBAnnotationTypeKey;
NSString * const HBBadgeCountKey;

#import "UIView+Badge.h"
#import <objc/runtime.h>


@interface UIView()

@property (strong , nonatomic )UILabel * badgeLabel;

@end

@implementation UIView (Badge)


- (void)setOffPoint:(CGPoint)offPoint{
    
    [self.badgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(offPoint.x));
        make.top.equalTo(@(offPoint.y));
    }];
}

- (UILabel *)badgeLabel{
    
    UILabel * _badgeLabel = objc_getAssociatedObject(self, &HBViewBadgeKey);
    if (!_badgeLabel) {
        _badgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        _badgeLabel.font = [UIFont systemFontOfSize:13];
        _badgeLabel.textColor =[UIColor whiteColor];
        _badgeLabel.backgroundColor = [UIColor redColor];
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        _badgeLabel.layer.cornerRadius = 10.0f;
        _badgeLabel.layer.masksToBounds = YES;
        [self addSubview:_badgeLabel];
        
        
        [_badgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(20));
            make.width.equalTo(@(20));
            make.right.equalTo(@(-10));
            make.top.equalTo(@20);
            
        }];
        
        self.badgeLabel = _badgeLabel;
    }

    return _badgeLabel;
}

- (void)setBadgeLabel:(UILabel *)badgeLabel{
    objc_setAssociatedObject(self, &HBViewBadgeKey, badgeLabel,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (HBAnnotationType)annotationType{
    return [objc_getAssociatedObject(self, &HBAnnotationTypeKey) integerValue];
}

- (void)setAnnotationType:(HBAnnotationType)annotationType{
    objc_setAssociatedObject(self, &HBAnnotationTypeKey, @(annotationType),OBJC_ASSOCIATION_COPY_NONATOMIC);

    
    switch (annotationType) {
        case HBAnnotationTypePoint:
        {
            self.badgeLabel.layer.cornerRadius = 4.0f;
            self.badgeLabel.hidden = NO;
            self.badgeLabel.textColor = self.badgeLabel.backgroundColor;
            
            [self.badgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(8));
                make.width.equalTo(@(8));
                make.right.equalTo(@(-10));
                make.top.equalTo(@10);
            }];
            
        }
            break;
        case HBAnnotationTypeNumber:
        {
            self.badgeLabel.layer.cornerRadius = 10.0f;
            self.badgeLabel.hidden = NO;
            self.badgeLabel.textColor = [UIColor whiteColor];

            [self.badgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(20));
                make.width.equalTo(@(20));
                make.right.equalTo(@0);
                make.top.equalTo(@0);
                
            }];
        }
            break;
        default:
        {
            self.badgeLabel.hidden = YES;
        }
            break;
    }
}

- (int)badgeCount{
    return [objc_getAssociatedObject(self, &HBBadgeCountKey) intValue];
}

- (void)setBadgeCount:(int)badgeCount{
    objc_setAssociatedObject(self, &HBBadgeCountKey, @(badgeCount),OBJC_ASSOCIATION_COPY_NONATOMIC);

    self.badgeLabel.text = [NSString stringWithFormat:@"%d",badgeCount];
}


@end
