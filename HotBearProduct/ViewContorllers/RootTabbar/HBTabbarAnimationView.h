//
//  HBTabbarAnimationView.h
//  HotBear
//
//  Created by APPLE on 2017/3/20.
//  Copyright © 2017年 网星传媒. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^selectedBlock) (int index , BOOL cancel);

@interface HBTabbarAnimationView : UIView


- (id)initWithImages:(CGPoint)pointCenter withOnView:(UIView *)onView withSelectedBlock:(selectedBlock)selectedBlock;

- (void)show;

@property (nonatomic , readonly)CGPoint pointCenter;


@property (copy , nonatomic) selectedBlock selectdBl;

+ (CABasicAnimation *)spinAnimation:(NSTimeInterval)duration;

@end
