//
//  SSVideoFastForwardView.h
//  HotBear
//
//  Created by Cody on 2017/6/1.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSVideoFastForwardView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;

- (id)initWithShowInView:(UIView *)view;

- (void)dismiss;

- (void)dismissAfterDelay:(NSTimeInterval)afterDelay;

@end
