//
//  HBHomeLocationHeaderReusableView.h
//  HotBear
//
//  Created by Cody on 2017/6/14.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBHomeLocationHeaderReusableView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleCenterXConstraint;
@property (weak, nonatomic) IBOutlet UIButton *showSettingSystemBtn;

- (void)updateLocationTitle;

@end
