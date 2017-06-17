//
//  HBMyMsgSystemTableViewCell.h
//  HotBear
//
//  Created by Cody on 2017/5/3.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBMyMsgSystemTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
@property (weak, nonatomic) IBOutlet UIButton *shadeBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
