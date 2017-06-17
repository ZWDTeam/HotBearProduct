//
//  HBWithdrawDetailTableViewCell.h
//  HotBear
//
//  Created by Cody on 2017/5/2.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBWithdrawDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *backContentView;
@property (weak, nonatomic) IBOutlet UILabel *commitTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *toUserNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *finishTimeLabel;

@end
