//
//  HBUploadStatusBar.h
//  HotBear
//
//  Created by Cody on 2017/4/18.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBUploadStatusBar : UIView


+ (instancetype)shareStatusbar;

@property (assign , nonatomic)float progress;

- (void)show;

- (void)dismiss;

@end
