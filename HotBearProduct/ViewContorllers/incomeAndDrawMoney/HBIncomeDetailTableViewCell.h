//
//  HBIncomeDetailTableViewCell.h
//  HotBear
//
//  Created by Cody on 2017/5/2.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBIncomeDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *hotBearCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@end
