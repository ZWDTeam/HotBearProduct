//
//  HBUserDetailVideoTableViewCell.h
//  HotBear
//
//  Created by Cody on 2017/4/23.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import <UIKit/UIKit.h>



@class HBUserDetailVideoTableViewCell;

@protocol HBUserDetailVideoTableViewCellDelegate <NSObject>

- (void)userDetailVideoCell:(HBUserDetailVideoTableViewCell *)cell withType:(NSInteger)index;

@end

@interface HBUserDetailVideoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyCountLabel;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *typeViews;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (assign , nonatomic)NSInteger checkType; //审核类型 0 等待审核 1 审核通过 2 审核不通过
@property (weak, nonatomic) IBOutlet UILabel *checkTypeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeLabelLayoutConstraint;

@property (weak , nonatomic)id <HBUserDetailVideoTableViewCellDelegate>delegate;

@end
