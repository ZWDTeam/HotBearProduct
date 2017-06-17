//
//  HBVideoEditingHeaderView.h
//  HotBear
//
//  Created by Cody on 2017/4/1.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^videoEditingTapImage)(UIView * tapView);

@interface HBVideoEditingHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UIImageView *centerImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthLayoutConstraint;

@property (copy ,nonatomic) videoEditingTapImage tapBlock;

@end
