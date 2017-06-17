//
//  HBBaseSheetView.h
//  HotBear
//
//  Created by Cody on 2017/6/16.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HBBaseSheetViewBlock)(NSInteger index);


@interface HBBaseSheetView : UIView

- (id)initWithDeSelectedBlock:(HBBaseSheetViewBlock)selected;

@property (copy , nonatomic)HBBaseSheetViewBlock selectedBlock;

- (void)showInView:(UIView *)view;

- (void)dismiss;

@end
