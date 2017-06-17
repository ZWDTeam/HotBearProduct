//
//  HBPayCoinAlertTableViewCell.h
//  HotBear
//
//  Created by Cody on 2017/4/27.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HBPayCoinAlertTableViewCell;

@protocol  HBPayCoinAlertTableViewCellDelegate <NSObject>

- (void)payCoinCell:(HBPayCoinAlertTableViewCell *)cell withBtn:(UIButton *)sender;

@end

@interface HBPayCoinAlertTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UILabel *moneyCountLabel;

@property (weak , nonatomic)id <HBPayCoinAlertTableViewCellDelegate >delegate;


@end
