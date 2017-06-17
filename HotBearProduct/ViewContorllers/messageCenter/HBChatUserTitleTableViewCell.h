//
//  HBChatUserTitleTableViewCell.h
//  HotBear
//
//  Created by Cody on 2017/6/7.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HBChatUserTitleTableViewCell;

@protocol HBChatUserTitleTableViewCellDelegate <NSObject>

- (void)deSelectSwithWithCell:(HBChatUserTitleTableViewCell *)cell;

@end

@interface HBChatUserTitleTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UISwitch *mySwitch;

@property (weak , nonatomic)id<HBChatUserTitleTableViewCellDelegate>delegate;

@end
