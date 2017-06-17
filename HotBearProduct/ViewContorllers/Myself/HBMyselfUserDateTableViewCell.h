//
//  HBMyselfUserDateTableViewCell.h
//  HotBear
//
//  Created by Cody on 2017/4/13.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HBMyselfUserDateTableViewCell;

@protocol HBMyselfUserDateTableViewCellDelegate <NSObject>

- (void)myselfUserDateCell:(HBMyselfUserDateTableViewCell*)cell withType:(NSInteger)type;

@end

@interface HBMyselfUserDateTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dynamicCountLabel;//动态数目
@property (weak, nonatomic) IBOutlet UILabel *fansCountLabel;//粉丝数目
@property (weak, nonatomic) IBOutlet UILabel *incomeCountLabel;//收益数目
@property (weak , nonatomic) id<HBMyselfUserDateTableViewCellDelegate>delegate;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *detailBackgroudView;
@property (weak, nonatomic) IBOutlet UILabel *PlayTourCountLabel;//账户数目
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *spaceLayoutConstraints;
@end
