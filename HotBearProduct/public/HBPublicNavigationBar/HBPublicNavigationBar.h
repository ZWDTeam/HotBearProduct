//
//  HBPublicNavigationBar.h
//  HotBear
//
//  Created by Cody on 2017/3/31.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBPublicNavigationBar : UIView


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *returnBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@property (strong , nonatomic)UIColor * contentColor;

@end
