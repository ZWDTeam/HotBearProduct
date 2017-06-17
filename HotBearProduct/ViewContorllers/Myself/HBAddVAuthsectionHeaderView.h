//
//  HBAddVAuthsectionHeaderView.h
//  HotBear
//
//  Created by Cody on 2017/5/24.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HBAddVAhthSeletType)(NSInteger type);

@interface HBAddVAuthsectionHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *personImageView;
@property (weak, nonatomic) IBOutlet UIImageView *organizationImageView;

/*
 选择的类型： 0 个人 ，1  机构
 */
@property (assign , nonatomic)NSInteger type;

@property (copy , nonatomic)HBAddVAhthSeletType seletTypeBlock;

@end
